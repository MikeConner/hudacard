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

describe Game do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, :user => user) }
  
  subject { game }
  
  it "should respond to everything" do
    game.should respond_to(:bet)
    game.should respond_to(:payout)
    game.should respond_to(:color)
    game.should respond_to(:security_code)
    game.should respond_to(:game_key)
    game.should respond_to(:cards)
    game.should respond_to(:random_token)
  end
  
  its(:user) { should be == user }
  
  it { should be_valid }
  
  describe "should have dealt cards" do
    before { @cards = YAML::load(game.cards) }
    
    it "should have cards" do
      game.cards.should_not be_nil
      @cards.class.name.should be == 'Array'
      @cards.count.should be == 5
    end
    
    it "but not a payout" do
      game.bet.should be_nil
      game.payout.should be_nil
      game.color.should be_nil
    end
  end
  
  describe "played game" do
    let(:game) { FactoryGirl.create(:played_game, :user => user) }
    
    it { should be_valid }
    
    it "should have a payout" do
      game.payout.should_not be_nil
      game.color.should_not be_nil
    end
    
    describe "missing color" do
      before { game.color = ' ' }
      
      it { should_not be_valid }
    end
    
    describe "invalid color" do
      before { game.color = 'Blue' }
      
      it { should_not be_valid }
    end
    
    describe "should allow 0 bet" do
      before { game.bet = 0 }
      
      it { should be_valid }
    end
    
    describe "invalid bet" do
      ['abc', nil, 0.5, -2].each do |value|
        before { game.bet = value }
        
        it { should_not be_valid }
      end
    end
  end
  
  describe "missing token" do
    before { game.random_token = ' ' }
    
    it { should_not be_valid }
  end

  describe "missing security code" do
    before { game.security_code = ' ' }
    
    it { should_not be_valid }
  end

  describe "missing game key" do
    before { game.game_key = ' ' }
    
    it { should_not be_valid }
  end

  describe "missing cards" do
    before { game.cards = '' }
    
    it { should_not be_valid }
  end
end
