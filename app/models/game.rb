#make sure balance does not go below zero
#make sure bet is reasonable - balance in account at least 3x bet
# DONEmake sure bet is not negative
# load up deck of cards in memory one time so we're nothitting the db every game


class Game < ActiveRecord::Base
  attr_accessible :bet, :card1, :card2, :card3, :card4, :card5, :payout, :user_id, :session_id, :color, :security_code
  attr_accessible :payout_ratio
  attr_accessible :game_key

  belongs_to :user
  def deal_cards
    new_deck = Card.all
    self.card1 = new_deck[rand(new_deck.length)]
    new_deck.delete(card1)

    self.card2 = new_deck[rand(new_deck.length)]
    new_deck.delete(card2)

    self.card3 = new_deck[rand(new_deck.length)]
    new_deck.delete(card3)

    self.card4 = new_deck[rand(new_deck.length)]
    new_deck.delete(card4)

    self.card5 = new_deck[rand(new_deck.length)]
    new_deck.delete(card5)

    self.security_code = ""

    self.cards.each do |card|
      self.security_code = self.security_code + card.value + card.suit 
    end
    self.security_code = self.security_code + (0...40).map{(65+rand(26)).chr}.join
    #JEFF _> SECURERANDOM THIS MOTHER!!!

    self.game_key = Digest::MD5.hexdigest(self.security_code)
  end

  def compute_payout
    red = 0
    black = 0
    joker = 0

    cards.each do |card|
      if card.suit == "heart" or card.suit == "diamond"
        red = red + 1
      elsif card.suit == "club" or card.suit == "spade"
        black = black + 1
      elsif card.suit == "joker"
        joker = joker + 1
      end
    end
    if self.color == "Red" #bet is on red
      case red
      when 0
        self.payout_ratio = -3
      when 1
        self.payout_ratio = -2
      when 2
        self.payout_ratio = -1
      when 3
        self.payout_ratio = 1.2
      when 4
        self.payout_ratio = 2
      when 5
        self.payout_ratio = 5
      end
    else                #bet is on black
      case black
      when 0
        self.payout_ratio = -3
      when 1
        self.payout_ratio = -2
      when 2
        self.payout_ratio = -1
      when 3
        self.payout_ratio = 1.2
      when 4
        self.payout_ratio = 2
      when 5
        self.payout_ratio = 5
      end
    end
  end


  def conclude
    compute_payout

    self.payout = bet*self.payout_ratio
    self.save!
    if !self.user.nil?
      if self.user.balance.nil?
        self.user.balance = 0
      end
      self.user.balance = self.user.balance + self.payout
      self.user.save!
    end
  end
  def cardify
    self.card1 = Card.find(self.card1.to_i)
    self.card2 = Card.find(self.card2.to_i)
    self.card3 = Card.find(self.card3.to_i)
    self.card4 = Card.find(self.card4.to_i)
    self.card5 = Card.find(self.card5.to_i)
  end
  def cards
    cards = []
    cards.push self.card1
    cards.push self.card2
    cards.push self.card3
    cards.push self.card4
    cards.push self.card5
    cards

  end
end
