class Card
  # Support validations outside ActiveRecord
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  CLUB = 'Club'
  DIAMOND = 'Diamond'
  SPADE = 'Spade'
  HEART = 'Heart'
  JOKER = 'Joker'
  
  NUM_JOKERS = 2
  
  # "2" => 1, "3" => 2, ...
  VALUE_WEIGHT = Hash[%w(2 3 4 5 6 7 8 9 10 J Q K A).zip((1..13).to_a)]
  SUIT_WEIGHT = {CLUB => 0, DIAMOND => 1, SPADE => 2, HEART => 3} 
  
  RED_WEIGHT = {CLUB => 0, DIAMOND => 1, SPADE => 0, HEART => 1, JOKER => 0}
  BLACK_WEIGHT = {CLUB => 1, DIAMOND => 0, SPADE => 1, HEART => 0, JOKER => 0}
  
  attr_accessor :suit, :value

  validates :suit, :inclusion => { :in => SUIT_WEIGHT.keys }
  validates :value, :inclusion => { :in => VALUE_WEIGHT.keys }

  # Pick a card, any card...
  def self.pick
    # Joker?
    if Random.rand(52 + NUM_JOKERS) < NUM_JOKERS
      Card.new(:suit => JOKER, :value => (Random.rand(2) + 1).to_s)
    else
      Card.new(:suit => SUIT_WEIGHT.keys.sample, :value => VALUE_WEIGHT.keys.sample)
    end
  end
  
  # Equality operator
  def ==(other)
    # Values of Jokers don't matter
    (self.suit == other.suit) and ((self.value == other.value) or (JOKER == self.suit))
  end
  
  # Needed for new to work
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def red_value
    RED_WEIGHT[self.suit]
  end
  
  def black_value
    BLACK_WEIGHT[self.suit]
  end
  
  def joker_value
    JOKER == self.suit ? 1 : 0
  end
  
  def suit_weight
    JOKER == self.suit ? 0 : SUIT_WEIGHT[self.suit]
  end
  
  def value_weight
    VALUE_WEIGHT[self.value]
  end
  
  def to_s
    JOKER == self.suit ? JOKER : "#{self.value} of #{self.suit.pluralize}"
  end

  # Needed for ActiveModel support
  def persisted?
    false
  end  
end
