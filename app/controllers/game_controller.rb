class GameController < ApplicationController
  
  def new_player
    if !current_user.nil?
      sign_out(current_user)
    end 
    random_token = SecureRandom.urlsafe_base64(32, false)
    nu = User.new
    nu.email = random_token + "@me.com"
    nu.password = random_token
    nu.random_token = random_token
    nu.balance = 0
    nu.get_btc_address
    nu.save!
    redirect_to '/secret/' + random_token 
  end

  def load_player
    rt = User.where(random_token: params["random_token"]).first
    if current_user.nil?
      sign_in(:user, rt)
    else
      if !(current_user == rt)
        sign_out(current_user)
        sign_in(:user, rt)
      end
    end
  end

  def qrcode
    qr_uri = "bitcoin:" + current_user.bitcoin_inbound

    respond_to do |format|
      format.html
      format.svg  { render :qrcode => qr_uri, :level => :l, :unit => 10, :offset => 14 }
      #need imagemagik for these:
      #format.png  { render :qrcode => request.url }
      #format.gif  { render :qrcode => request.url }
      #format.jpeg { render :qrcode => request.url }
    end
  end
  def new_game
    # load last game (or remove last game if exists)

    @newgame = Game.new
    @newgame.deal_cards
    @newgame.session_id = session["session_id"]
    @newgame.user = current_user
    @hash = @newgame.game_key
    @newgame.save!
  end

  def load_oldgame

  end

  def finish_game
      @bet = request["bet"]
      @bet = @bet.to_f
      if current_user.balance == 0 
        @bet = 0
      end    
      @balanceCalc = 1
      @balanceCalc = current_user.balance
      if (@bet >= 0.001 and @bet <= 0.05 and @bet*3 <= @balanceCalc/100000000) or @bet == 0
        @betSatoshi = (@bet*100000000).to_i
        @color = request["commit"]
        @game_key = request["game_key"]

        @oldgame = current_user.games.where(game_key: @game_key, bet: nil).order(:id).reverse_order.first

        if !@oldgame.nil?
          @oldgame.cardify

          @oldgame.bet = @betSatoshi.to_i
          @oldgame.color = @color
          @oldgame.conclude
        else
          @bad_bet = "Something went wrong.  Old game corrupt.  Bet Invalid!"
        end
      else
        @bad_bet = "Bet is out of range."
      end
  end

  def play
    load_player
    # Start new game, save to db
    if request["bet"].nil?
      new_game
    else
      finish_game
      new_game
    end
  end

  def fund
    current_user.get_btc_address
    redirect_to '/secret/' + current_user.random_token
  end

  def fundcheck
    current_user.get_btc_total_recieved(0)
    redirect_to '/secret/' + current_user.random_token
  end
  
  def withdraw   
    @message = current_user.withdraw request['extract_addy']
    
  end
end
