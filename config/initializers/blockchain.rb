require 'bitcoin_gateway'
require 'bitcoin_test_gateway'

MERCHANT_KEY = '61e9e217-d259-4ed2-9939-09ce5f071fe4'
MERCHANT_PASSWORD = ENV['MERCHANT_PASSWORD'] || '$tamP3d3$!@'

BITCOIN_GATEWAY = BitcoinGateway.instance

ADMIN_KEY = 'bd0d9205-7680-4d15-8f37-985d84871569'
