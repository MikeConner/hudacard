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
end
