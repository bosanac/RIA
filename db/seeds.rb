# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Dio koda za dodavanje laznih korisnika u tabelu users
User.create!(name:  "Amer Turcinovic",
             email: "turcinovic@gmail.com",
             password:              "turcinovic",
             password_confirmation: "turcinovic")

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
# kraj dijela koda za dodavanje laznih korisnika
# gornji kod se treba obrisati, u svrhu je testiranja

@brKvizaTemp = 0

10.times do |n|
  @brKvizaTemp = @brKvizaTemp+1
 
  Quiz.create!(naziv:  "kviz#{@brKvizaTemp}",
               opis: "kviz#{@brKvizaTemp}",
               pokusaja: 0,
               user_id: (@brKvizaTemp-1),
               published: 0)
end