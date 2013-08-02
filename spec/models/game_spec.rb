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

require 'spec_helper'

describe Game do
  pending "add some examples to (or delete) #{__FILE__}"
end
