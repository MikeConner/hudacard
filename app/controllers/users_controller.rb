class UsersController < ApplicationController
  respond_to :html, :svg
  
  before_filter :authenticate_user!, :except => [:show]
  before_filter :ensure_current_user, :except => [:show, :account]
  before_filter :ensure_correct_user_or_admin, :only => [:account]
  
  def balance_inquiry
    # Creates funding transaction if they've deposited (0 confirmations required)
    @user.get_btc_total_received
    
    # Shows calculated balance: 0 if sum of "external" transactions (including unconfirmed deposits) is 0
    #   Otherwise show sum of external transactions + payout from last game
    redirect_to @user
  end
  
  def qrcode
    qr_uri = "bitcoin:" + @user.inbound_bitcoin_address

    respond_to do |format|
      format.html
      format.svg  { render :qrcode => qr_uri, :level => :l, :unit => 10, :offset => 14 }
    end    
  end
  
  def withdrawal
    if params['extract_addy'].blank?
      redirect_to @user, :alert => 'Bitcoin address required for withdrawal' and return
    end
    
    @message = @user.withdraw(params['extract_addy'])
    
  rescue RuntimeError => err
    @errors = err
    render 'games/error'
  end
  
  def update
    @user = User.find_by_email(params[:id] + User::EMAIL_SUFFIX)
    
    if @user.update_attributes(params[:user])
      redirect_to root_path, :notice => I18n.t('user_updated')
    else
      render 'account'
    end
  end
  
  def show
    @user = User.find_by_email(params[:id] + User::EMAIL_SUFFIX)
    
    raise 'User not found' if @user.nil?
    
    if current_user != @user
      sign_out current_user unless current_user.nil?
      sign_in(:user, @user)
    end
    
    # if a user has pending withdrawals, don't let them keep playing
    if @user.has_pending_withdrawals?
      @message = 'You have pending withdrawals.'
      render 'withdrawal' and return
    end

    @game = @user.current_game
    
    if @game.new_game?
      render 'games/edit' and return
    else
      # update (bet that finishes a game) creates a new game, but the "current_game" is still the old one until it's displayed
      @new_game = @user.games.last
      
      # if these are not equal, we've just done an update and the user hasn't been shown the result yet
      # Update the current game to the new one, then show the old one
      # A new bet will use the "new" game
      if @new_game.id != @game.id
        @user.update_attributes!(:current_game_id => @new_game.id)
      end
      @cards = YAML::load(@game.cards)
    
      # If 0 balance, don't count up/down to 0; allow "betting" with zero balance
      old = 0 == @game.user.balance.as_satoshi ? 0 : @game.user.balance.as_satoshi - (Bitcoin.new(:mb => @game.payout).as_satoshi).round
      @old_balance = Bitcoin.new(:satoshi => old)
      
      @cards = YAML::load(@game.cards)
      render 'games/show' and return
    end
    
  rescue RuntimeError => err
    @errors = err
    render 'games/error'
  end

  def account
    @transactions = @user.btc_transactions.external
    @games = @user.games
    
    # Details
    @deposits = @transactions.inbound.inject(0) { |sum, d| sum + d.satoshi }
    @withdrawals = @transactions.outbound.inject(0) { |sum, w| sum - w.satoshi }
    @total_dw = @deposits - @withdrawals
    @winnings = @user.btc_transactions.game.inject(0) { |sum, g| sum + g.satoshi }
    @grand_total = @total_dw + @winnings
    @pending_deposits = @transactions.inbound.queued.inject(0) { |sum, d| sum + d.satoshi }
    @pending_withdrawals = @transactions.outbound.queued.inject(0) { |sum, w| sum - w.satoshi }
  end
  
private
  def ensure_current_user
    @user = User.find_by_email(params[:id] + User::EMAIL_SUFFIX)
    
    if @user != current_user
      @errors = 'Wrong user'
      render 'games/error'
    end
  end
  
  def ensure_correct_user_or_admin
    @user = User.find_by_email(params[:id] + User::EMAIL_SUFFIX)
    
    if !current_user.admin? and (@user != current_user)
      @errors = 'Wrong user'
      render 'games/error'
    end
  end
end