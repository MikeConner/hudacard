# == Schema Information
#
# Table name: btc_transactions
#
#  id               :integer          not null, primary key
#  satoshi          :integer
#  address          :string(255)
#  transaction_id   :string(255)
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pending          :boolean          default(FALSE), not null
#  transaction_type :string(255)      default("Game"), not null
#

describe BtcTransaction do
  let(:user) { FactoryGirl.create(:user) }
  let(:transaction) { FactoryGirl.create(:btc_transaction, :user => user) }
  
  subject { transaction }
  
  it "should respond to everything" do
    transaction.should respond_to(:satoshi)
    transaction.should respond_to(:address)
    transaction.should respond_to(:transaction_id)
    transaction.should respond_to(:pending)
    transaction.should respond_to(:transaction_type)
  end
  
  it "should be inbound" do
    BtcTransaction.inbound.include?(transaction).should be_true
    BtcTransaction.outbound.should be_empty
  end
  
  its(:user) { should be == user }
  
  it { should be_valid }
  
  it "should not allow mass assignment" do
    expect { transaction.update_attributes!(:pending => false) }.to raise_exception(ActiveModel::MassAssignmentSecurity::Error)
  end
  
  describe "Missing type" do
    before { transaction.transaction_type = nil }
    
    it { should_not be_valid }
  end
  
  describe "valid" do
    BtcTransaction::TRANSACTION_TYPES.each do |types|
      before { transaction.transaction_type = types }
      
      it { should be_valid }
    end
  end
  
  describe "invalid" do
    before { transaction.transaction_type = 'Not a type' }
    
    it { should_not be_valid }
  end
  
  describe "invalid pending" do
    before { transaction.pending = nil }
    
    it { should_not be_valid }
  end
  
  it "should show settled" do
    BtcTransaction.settled.should be == [transaction]
    BtcTransaction.queued.should be_empty
  end
  
  describe "queued" do
    let(:transaction) { FactoryGirl.create(:queued_transaction) }
    
    it "should show queued" do
    BtcTransaction.queued.should be == [transaction]
    BtcTransaction.settled.should be_empty      
    end
  end
  describe "invalid satoshi" do
    [nil, 'abc', -2, 1.5, 0.0].each do |value|
      before { transaction.satoshi = value }
      
      it { should_not be_valid }
    end
  end
  
  describe "no address" do
    before { transaction.address = nil }
    
    it { should be_valid }
  end

  describe "no transaction id" do
    before { transaction.transaction_id = nil }
    
    it { should be_valid }
  end
  
  describe "outbound" do
    let(:transaction) { FactoryGirl.create(:outbound_btc_transaction) }
    
    it { should be_valid }
    
    it "should be outbound" do
      BtcTransaction.inbound.should be_empty
      BtcTransaction.outbound.include?(transaction).should be_true
    end

    describe "missing address should fail" do
      before { transaction.address = nil }
      
      it { should_not be_valid }
    end
    
    describe "no transaction id should fail" do
      before { transaction.transaction_id = nil }
      
      it { should_not be_valid }
    end
  end
end
