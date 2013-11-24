# CHARTER
#   Encapsulate a Bitcoin value and all conversions
#
# USAGE
#   Stored internally as satoshi. Specify units on creation and expression.
#   b = Bitcoin.new(:btc => 0.005)
#   puts b.as_mb # prints 50
#   puts b.as_satoshi # prints 50000
#
# NOTES AND WARNINGS
#
class Bitcoin 
  SATOSHI = :satoshi
  MBTC = :mb
  BTC = :btc
  UBTC = :ub
    
  SATOSHI_MULT = 100000000
  MBTC_MULT = 100000
  UBTC_MULT = 100
  
  attr_accessor :value
  
  def as_satoshi
    self.value
  end
  
  def as_mb
    self.value.to_f / MBTC_MULT.to_f
  end
  
  def as_ub
    self.value.to_f / UBTC_MULT.to_f
  end
  
  def as_btc
    self.value.to_f / SATOSHI_MULT.to_f
  end
  
  def initialize(options)
    if options.has_key?(SATOSHI)
      self.value = options[SATOSHI]
    elsif options.has_key?(MBTC)
      self.value = options[MBTC] * MBTC_MULT
    elsif options.has_key?(UBTC)
      self.value = options[UBTC] * UBTC_MULT
    elsif options.has_key?(BTC)
      self.value = options[BTC] * SATOSHI_MULT
    else
      raise 'Invalid argument'
    end
  end
end