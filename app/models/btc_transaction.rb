class BtcTransaction < ActiveRecord::Base
  attr_accessible :from_address, :label, :satoshi_in, :satoshi_out, :to_address, :txn_date, :user_id
  #from addrss not used 
  belongs_to :user


  def save_incoming(uid, sat_in, add_in)
    self.user_id = uid
    self.satoshi_in = sat_in
    self.to_address = add_in
    self.txn_date = DateTime.now
    self.save!
  end

  def save_outgoing(uid, sat_out, add_out)
    self.user_id = uid
    self.satoshi_out = sat_out
    self.to_address = add_out
    self.txn_date = DateTime.now
    self.save!
  end

end
