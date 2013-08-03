# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default(""), not null
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  inbound_bitcoin_address :string(255)
#

describe User do
  let(:user) { FactoryGirl.create(:user) }
  
  subject { user }
  
  it "should respond to everything" do
    user.should respond_to(:email)
    user.should respond_to(:inbound_bitcoin_address)
  end
  
  it { should be_valid }

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
    
    it "should have transactions" do
      user.btc_transactions.count.should be == 5
      user.balance.should be > 0
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
      user.balance.should be == 0
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
