require 'bitcoin'

describe BtcTransaction do
  let(:btc) { Bitcoin.new(:btc => 1 ) }
  let(:mb) { Bitcoin.new(:mb => 1) }
  let(:ub) { Bitcoin.new(:ub => 1) }
  let(:satoshi) { Bitcoin.new(:satoshi => 1) }
  
  subject { btc }
  
  it "should report correct values" do
    btc.as_btc.should be == 1
    btc.as_mb.should be == 1000
    btc.as_ub.should be == 1000000
    btc.as_satoshi.should be == 100000000
    
    mb.as_satoshi.should be == 100000
    ub.as_satoshi.should be == 100
    satoshi.as_satoshi.should be == 1
  end
end
