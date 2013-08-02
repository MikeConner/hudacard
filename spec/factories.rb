FactoryGirl.define do
  factory :card do
    suit generate { Card::SUIT_WEIGHT.keys.sample }
    value geneate { Card::VALUE_WEIGHT.keys.sample }
  end
end