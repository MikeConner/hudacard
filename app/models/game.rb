# == Schema Information
#
# Table name: games
#
#  id            :integer          not null, primary key
#  bet           :integer          default(1), not null
#  user_id       :integer
#  payout        :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string(8)
#  security_code :string(128)
#  game_key      :string(32)
#  cards         :string(255)
#  random_token  :string(48)
#

# CHARTER
#   Represent a single game (a single bet and payout)
#
# USAGE
#   Create a game, "update" it by betting, then "show" the result
#
# NOTES AND WARNINGS
#
class Game < ActiveRecord::Base
  extend FriendlyId
  friendly_id :random_token
  
  RED = 'Red'
  BLACK = 'Black'
  TOKEN_LENGTH = 32
  MINIMUM_BET = Bitcoin.new(:mb => 1)
  
  before_validation :deal_cards
  
  # Bet/payout are in mBTC
  attr_accessible :bet, :cards, :payout, :user_id, :color, :security_code, :game_key, :random_token

  belongs_to :user

  validates_presence_of :random_token
  validates_presence_of :security_code
  validates_presence_of :game_key
  validates_presence_of :cards
  # These only defined if there's a bet
  validates :color, :inclusion => { :in => [RED, BLACK] }, :allow_nil => true
  validates :bet, :numericality => { :greater_than_or_equal_to => 0, :only_integer => true }, :allow_nil => true
  validates_numericality_of :payout, :allow_nil => true
      
  def new_game?
    self.color.nil?
  end
  
  def deal_cards
    if self.new_record?
      cards = []
      while cards.count < 5 do
        new_card = Card.pick
        cards.push(new_card) unless cards.include?(new_card)
      end
      
      self.security_code = ''
      cards.each do |card|
        self.security_code += "[" + card.to_s + "]" 
      end
      self.security_code += SecureRandom.hex(20)
      self.game_key = Digest::MD5.hexdigest(self.security_code)
      
      self.cards = YAML::dump(cards)
    end
  end
  
  # Don't want to store in the database, but needed for display
  def ratio
    if 0 == self.bet
      0
    else
      self.payout / self.bet
    end
  end
  
  def play
    # Given the color, bet is already stored - compute everything (if zero balance, don't add any transactions)
    self.payout = self.bet * payout_ratio
    if user.balance.value > 0
      self.user.btc_transactions.create!(:satoshi => (Bitcoin.new(:mb => self.payout).as_satoshi).round, 
                                         :address => user.inbound_bitcoin_address, 
                                         :transaction_id => game_tx_id,
                                         :transaction_type => BtcTransaction::GAME_TRANSACTION)
    end
    
    save!
  end
  
  def mid_game_notes
    red = 0
    black = 0
    joker = 0
    count = 0
    notes = []

    YAML::load(self.cards).each do |card|
      count += 1
      red += card.red_value
      black += card.black_value
      
      if count >= 2 && count != 5
        case count
        when 2
          if RED == self.color #bet is on red
            case red
            when 0
              notes.push("One more BLACK and you LOSE!" )
            when 1
              notes.push("")
            when 2
              notes.push("One more RED and you WIN!" )
            end
          else                #bet is on black
            case black
            when 0
              notes.push("One more RED and you LOSE!" )
            when 1
              notes.push("")
            when 2
              notes.push("One more BLACK and you WIN!" )
            end
          end
        when 3
          if RED == self.color #bet is on red
            case red
            when 0
              notes.push("Sorry, one more BLACK and you LOSE DOUBLE!" )
            when 1
              notes.push("One more BLACK and you LOSE!")
            when 2
              notes.push("One more RED and you WIN!" )
            when 3
              notes.push("You WIN!  One more RED and you win DOUBLE!" )
            end
          else                #bet is on black
            case black
            when 0
              notes.push("Sorry, One more RED and you LOSE DOUBLE!" )
            when 1
              notes.push("One more RED and you LOSE!")
            when 2
              notes.push("One more BLACK and you WIN!" )
            when 3
              notes.push("You WIN! One more BLACK and you WIN DOUBLE!")
            end
          end
        when 4
          if RED == self.color #bet is on red
            case red
            when 0
              notes.push("You lose double, one more BLACK and you LOSE 3x!" )
            when 1
              notes.push("Sorry, One more BLACK and you LOSE DOUBLE!")
            when 2
              notes.push("Game is tied. Next card determines winner" )
            when 3
              notes.push("You WIN!  One more RED and you win DOUBLE!" )
            when 4
              notes.push("You WIN DOUBLE!  One more RED to win 5x JACKPOT!" )
            end
          else                #bet is on black
            case black
            when 0
              notes.push("You lose double, one more RED and you LOSE 3x!" )
            when 1
              notes.push("Sorry, One more RED and you LOSE DOUBLE!")
            when 2
              notes.push("Game is tied. Next card determines winner." )
            when 3
              notes.push("You WIN! One more BLACK and you WIN DOUBLE!")
            when 4
              notes.push("You WIN DOUBLE!  One more BLACK to win 5x JACKPOT!" )
            end
          end
        end
      end
    end
    
    notes
  end
  
private
  def game_tx_id
    "game:#{self.id}"
  end
  
  def payout_ratio
    value = 0
    
    YAML::load(self.cards).each do |card|
      value += (RED == self.color) ? card.red_value : card.black_value
    end
        
    case value
    when 0
      payout_ratio = -3
    when 1 
      payout_ratio = -2
    when 2
      payout_ratio = -1
    when 3
      payout_ratio = 1.2
    when 4
      payout_ratio = 2
    when 5
      payout_ratio = 5
    end
    
    payout_ratio
  end
end
