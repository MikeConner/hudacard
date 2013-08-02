# == Schema Information
#
# Table name: btc_transactions
#
#  id             :integer          not null, primary key
#  satoshi        :integer
#  address        :string(255)
#  transaction_id :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe BtcTransaction do
  pending "add some examples to (or delete) #{__FILE__}"
end
