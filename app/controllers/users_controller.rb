class UsersController < ApplicationController
  respond_to :html, :svg
  
  before_filter :authenticate_user!, :except => [:show]
  
  def balance_inquiry
    current_user.get_btc_total_received
    
    redirect_to edit_game_path(current_user.games.last)
  end
  
  def qrcode
    qr_uri = "bitcoin:" + current_user.inbound_bitcoin_address

    respond_to do |format|
      format.html
      format.svg  { render :qrcode => qr_uri, :level => :l, :unit => 10, :offset => 14 }
    end    
  end
  
  def withdrawal
    @message = current_user.withdraw(params['extract_addy'])
  end
  
  def show
    @user = User.find_by_email(params[:id] + User::EMAIL_SUFFIX)
    
    if current_user != @user
      sign_out current_user unless current_user.nil?
      sign_in(:user, @user)
    end
    
    @game = @user.games.last

    redirect_to edit_game_path(@game)
    
  rescue RuntimeError => err
    @errors = '<h1>#{err}</h1>'
    redirect_to error_games_path
  end
end