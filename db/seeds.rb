# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env == "test"
	UserRole.new(:name => "admin").save
	UserRole.new(:name => "practitioner").save
	UserRole.new(:name => "patient").save
	UserRole.new(:name => "staff").save
	UserRole.new(:name => "managing_director").save
	UserRole.new(:name => "supplier").save
end
