FactoryGirl.define do
  sequence(:random_email) { |n| Faker::Internet.email }
  
  factory :card do
    suit { Card::SUIT_WEIGHT.keys.sample }
    value { Card::VALUE_WEIGHT.keys.sample }
  end
  
  factory :user do
    email { generate(:random_email) }
    password "Password"
    password_confirmation "Password"
    
    ignore do
      num_transactions 5
    end
    
    ignore do
      num_games 2
    end
      
    factory :user_with_transactions do
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:btc_transaction, evaluator.num_transactions, :user => user)
      end
    end

    factory :user_with_games do
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:game, evaluator.num_games, :user => user)
      end
    end
  end
  
  factory :btc_transaction do
    user
    
    satoshi { Random.rand(1000000) + 100000 }
    transaction_type BtcTransaction::FUNDING_TRANSACTION
    pending false
    
    factory :outbound_btc_transaction do
      satoshi { (Random.rand(1000000) + 100000) * -1 }
      address { SecureRandom.hex(16) }
      transaction_id { SecureRandom.base64(12) }
      transaction_type BtcTransaction::WITHDRAWAL_TRANSACTION
    end
    
    factory :queued_transaction do
      pending true
    end
  end
  
  factory :game do
    user
    
    random_token { SecureRandom.urlsafe_base64(Game::TOKEN_LENGTH, false) }
    
    factory :played_game do
      bet { Random.rand(5) + 1 }
      payout { Random.rand(20) + 1}
      color { Game::BLACK }
    end
  end
end