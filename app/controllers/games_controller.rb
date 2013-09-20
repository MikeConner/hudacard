require 'card'
require 'bitcoin'

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
        user.update_attributes!(:current_game_id => @game.id)
        redirect_to user
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
      redirect_to @game.user
    else
      render 'games/error' and return
    end    
    
  rescue RuntimeError => err
    @errors = '<h1>#{err}</h1>'
    render 'games/error'
  end

  def error
  end
end