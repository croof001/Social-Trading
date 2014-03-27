# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Client.new(:email=>'vishnu@yubi.in',:password=>'password',:password_confirmation=>'password').save
Client.new(:email=>'test123@yubi.in',:password=>'testpassword',:password_confirmation=>'testpassword').save
Client.new(:email=>'test1@yubi.in',:password=>'testpassword',:password_confirmation=>'testpassword').save
Client.new(:email=>'test2@yubi.in',:password=>'testpassword',:password_confirmation=>'testpassword').save
Client.new(:email=>'test3@yubi.in',:password=>'testpassword',:password_confirmation=>'testpassword').save