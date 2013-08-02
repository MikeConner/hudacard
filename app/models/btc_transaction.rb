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

class BtcTransaction < ActiveRecord::Base
  MINER_FEE = 50000
  
  # Satoshi reflects the net deposit (so, negative = withdrawal)
  #   if a withdrawal, address has the destination; otherwise it's deposited into the inbound address associated with the user
  attr_accessible :satoshi, :address, :transaction_id,
                  :user_id

  belongs_to :user
  
  validates :satoshi, :presence => true,
                      :numericality => { :only_integer => true },
                      :exclusion => { :in => [0.0] }
  validates :address, :presence => { :if => :outbound? }
  validates :transaction_id, :presence => { :if => :outbound? }
  
  scope :inbound, where('satoshi > 0')
  scope :outbound, where('satoshi < 0')
  
private
  def outbound?
    self.satoshi < 0
  end
end
