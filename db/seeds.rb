# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
=begin
%w(club heart spade diamond).each do |suit|
  %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |value|
    card = Card.create(:suit => suit, :value => value.to_s)
  end
end
Card.create(:suit => 'joker', :value => 1.to_s)
Card.create(:suit => 'joker', :value => 2.to_s)
=end