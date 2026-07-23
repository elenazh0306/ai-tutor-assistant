# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "creating tutor and user"
user = User.create!(email: "current_user@example.com", password: "111111")
tutor = Tutor.create!(name: "Tutor")

puts "creating subjects"
Subject.create!(name: "biology", user: user, tutor: tutor)
Subject.create!(name: "math", user: user, tutor: tutor)
Subject.create!(name: "literature", user: user, tutor: tutor)
puts "all done"
