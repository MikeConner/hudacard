require 'card'

class GamesController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :edit]
  
  # Coming in from root path
  def new    
    # Destroy any current user session
    if !current_user.nil?
      sign_out current_user
    end 
    
    # Generate a new user and token
    token = SecureRandom.urlsafe_base64(Game::TOKEN_LENGTH, false)
    user = User.new(:email => token + User::EMAIL_SUFFIX, :password => token.reverse, :password_confirmation => token.reverse)
    # Save generates bitcoin address and validates
    if user.save
      sign_in user
      
      # Create game
      @game = user.games.build(:random_token => token)
      if @game.save
        render 'edit' and return
      else
        @errors = @game.errors.full_messages
        render 'games/error' and return
      end
    else
      @errors = user.errors.full_messages
      render 'games/error' and return
    end
    
  rescue RuntimeError => err
    @errors = "<h1>#{err}</h1>"
    render 'games/error' and return
  end
  
  # Coming in from "private" saved url - recover user
  def edit
    @game = Game.find(params[:id])
    if current_user != @game.user
      sign_out current_user unless current_user.nil?
      sign_in(:user, @game.user)
    end
    
    # if a user has pending withdrawals, don't let them keep playing
    if @game.user.has_pending_withdrawals?
      @message = 'You have pending withdrawals.'
      render 'users/withdrawal' and return
    end
  rescue RuntimeError => err
    @errors = '<h1>#{err}</h1>'
    render 'games/error'
  end
  
  def update
    @game = Game.find(params[:id])
    @errors = nil
    
    # Stores the bet
    if @game.update_attributes(params[:game].merge(:color => params[:commit]))
      # Commit has red/black; compute payout
      @game.play
      
      if @game.save
        token = SecureRandom.urlsafe_base64(Game::TOKEN_LENGTH, false)
        # create new game
        @game.user.games.create(:random_token => token)
      else
        @errors = @game.errors.full_messages
      end  
    else
      @errors = @game.errors.full_messages    
    end
    
    if @errors.nil?
      # Show displays the results (with JS to make it dynamic)
      @cards = YAML::load(@game.cards)
      redirect_to @game
    else
      render 'games/error' and return
    end    
    
  rescue RuntimeError => err
    @errors = '<h1>#{err}</h1>'
    render 'games/error'
  end
  
  def show
    @game = Game.find(params[:id])
    
    # There should be a defined payout -- otherwise they're manually typing in the URL and trying to cheat
    if @game.payout.nil?
      redirect_to edit_game_path(@game) and return
    end
    
    # if a user has pending withdrawals, don't let them keep playing
    if @game.user.has_pending_withdrawals?
      @message = 'You have pending withdrawals.'
      render 'users/withdrawal' and return
    end

    @cards = YAML::load(@game.cards)
    # if there is a game after this one, set it to "new_game" to display the hash
    @new_game = @game.user.games.last
    # If we get here it'd better have created a new game
    if @game.id == @new_game.id
      raise 'New Game creation failed'
    end
    
    # If 0 balance, don't count up/down to 0; allow "betting" with zero balance
    @old_balance = 0 == @game.user.balance ? 0 : @game.user.balance - (@game.payout * 100000).round
  end
  
  def error
  end
end