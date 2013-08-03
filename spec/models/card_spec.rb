describe Card do
  let(:card) { Card.new(:suit => Card::SUIT_WEIGHT.keys.sample, :value => Card::VALUE_WEIGHT.keys.sample) }
  
  subject { card }
  
  it "should respond to everything" do
    card.should respond_to(:suit)
    card.should respond_to(:value)
  end
  
  it { should be_valid }
  
  describe "Missing suit" do
    before { card.suit = nil }
    
    it { should_not be_valid }
  end

  describe "Invalid suit" do
    before { card.suit = 'Black' }
    
    it { should_not be_valid }
  end

  describe "Missing value" do
    before { card.value = nil }
    
    it { should_not be_valid }
  end
  
  describe "Invalid value" do
    before { card.value = 12 }
    
    it { should_not be_valid }
  end
  
  describe "equality operator / color values" do
    before do
      @card1 = Card.new(:suit => Card::DIAMOND, :value => '2')
      @card2 = Card.new(:suit => Card::DIAMOND, :value => '2')
      @card3 = Card.new(:suit => Card::DIAMOND, :value => '3')
      @card4 = Card.new(:suit => Card::SPADE, :value => '2')
      @joker1 = Card.new(:suit => Card::JOKER, :value => 0)
      @joker2 = Card.new(:suit => Card::JOKER, :value => 1)
    end
    
    it "should detect equality" do
      (@card1 == @card2).should be_true
      (@card1 == @card3).should_not be_true
      (@card1 == @card4).should_not be_true
      (@card1 == @joker1).should_not be_true
      (@joker1 == @joker2).should be_true
    end
    
    it "should detect red/black values" do
      @card1.red_value.should be == 1
      @card1.black_value.should be == 0
      @card4.red_value.should be == 0
      @card4.black_value.should be == 1
      @joker1.joker_value.should be == 1
      @card1.joker_value.should be == 0
    end
    
    it "should have proper weights" do
      @card1.suit_weight.should be == 1
      @joker1.suit_weight.should be == 0
      @card1.value_weight.should be == 1
      @card3.value_weight.should be == 2
    end
    
    it "should have text values" do
      @card1.to_s.should be == '2 of Diamonds'
      @joker1.to_s.should be == Card::JOKER
    end
  end
end
