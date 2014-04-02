# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string(255)      default(""), not null
#  encrypted_password       :string(255)      default(""), not null
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0)
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  inbound_bitcoin_address  :string(255)
#  current_game_id          :integer
#  outbound_bitcoin_address :string(255)
#  msg_email                :string(255)
#  admin                    :boolean          default(FALSE), not null
#

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  
  subject { user }
  
  it "should respond to everything" do
    user.should respond_to(:email)
    user.should respond_to(:msg_email)
    user.should respond_to(:inbound_bitcoin_address)
    user.should respond_to(:outbound_bitcoin_address)
    user.should respond_to(:current_game)
    user.should respond_to(:admin)
  end
  
  it { should be_valid }

  it "should not be an admin" do
    user.admin?.should be_false
    admin.admin?.should be_true
  end
  
  describe "duplicate email" do
    before { @user2 = user.dup }
    
    it "shouldn't allow exact duplicates" do
      @user2.should_not be_valid
    end
    
    describe "case sensitivity" do
      before do
        @user2 = user.dup
        @user2.email = user.email.upcase
      end
      
      it "shouldn't allow case variant duplicates" do
        @user2.should_not be_valid
      end
    end
  end

  describe "duplicate msg_email" do
    before do 
      @user2 = user.dup
      @user2.email = 'fish@fishy.com'
    end
    
    it "should allow exact duplicates" do
      @user2.should be_valid
    end
  end
  
  describe "missing email address" do
    before { user.email = nil }
    
    it { should_not be_valid }
  end
  
  describe "missing msg email address" do
    before { user.msg_email = nil }
    
    it { should be_valid }
  end
  
  describe "missing inbound address" do
    before { user.inbound_bitcoin_address = nil }
    
    it "should have created one" do
      user.inbound_bitcoin_address.should be_nil
      user.should be_valid # this creates it
      user.inbound_bitcoin_address.should_not be_nil
    end
  end
  
  describe "transactions" do
    let(:user) { FactoryGirl.create(:user_with_transactions) }

    before do
      @total = 0
      user.btc_transactions.each do |tx|
        @total += tx.satoshi
      end    
    end  
      
    it "should have transactions" do
      user.btc_transactions.count.should be == 5
      user.reload.balance.as_satoshi.should be == @total
    end
    
    describe "add some queued ones" do
      before do
        tx = user.btc_transactions.create(:satoshi => 234234, :address => 'alksdjfalskfj', :transaction_id => 'adsfasdf')
        tx.pending = true
        tx.save!
      end
      
      it "should not count queued transactions in the balance" do
        user.btc_transactions.count.should be == 6
        user.btc_transactions.settled.count.should be == 5
        user.btc_transactions.queued.count.should be == 1
        user.balance.as_satoshi.should be == @total        
      end
      
      describe "clear, then check balance" do
        before do
          q = user.btc_transactions.last
          q.pending = false
          q.save!
          @new_total = @total + 234234
        end
        
        it "should show the full balance now" do
          user.btc_transactions.count.should be == 6
          user.btc_transactions.settled.count.should be == 6
          user.btc_transactions.queued.count.should be == 0
          user.balance.as_satoshi.should be == @new_total                  
        end
      end
    end
    
    describe "try to destroy" do
      it "shouldn't let you" do
        expect { user.destroy }.to raise_exception(ActiveRecord::DeleteRestrictionError)
      end
    end
    
    describe "delete transactions first" do
      before { user.btc_transactions.destroy_all }
      
      it "should have none" do
        BtcTransaction.count.should be == 0
      end
      
      it "now it should allow" do
        expect { user.reload.destroy }.to_not raise_exception
      end
    end
  end

  describe "games" do
    let(:user) { FactoryGirl.create(:user_with_games) }
    
    it "should have games" do
      user.games.count.should be == 2
      user.balance.as_satoshi.should be == 0
    end
    
    describe "try to destroy" do
      it "shouldn't let you" do
        expect { user.destroy }.to raise_exception(ActiveRecord::DeleteRestrictionError)
      end
    end
    
    describe "delete games first" do
      before { user.games.destroy_all }
      
      it "should have none" do
        Game.count.should be == 0
      end
      
      it "now it should allow" do
        expect { user.reload.destroy }.to_not raise_exception
      end
    end
  end
end
