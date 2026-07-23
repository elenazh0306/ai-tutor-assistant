# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.find_or_initialize_by(email: "test@example.com")

if user.new_record?
  user.password = "password123"
  user.password_confirmation = "password123"
  user.save!
end

tutor = Tutor.find_or_create_by!(name: "Test Tutor")

subject = Subject.find_or_create_by!(
  name: "Test Subject",
  user: user,
  tutor: tutor
)

material = Material.find_or_create_by!(
  title: "Test Material",
  subject: subject
) do |record|
  record.content = "Ruby on Rails is a web application framework written in Ruby."
end

test = Test.find_or_create_by!(
  title: "Ruby on Rails Quiz",
  material: material
)

puts "Seed completed."
puts "Test: #{test.title}"
puts "Subject ID: #{subject.id}"
puts "Tests index: http://localhost:3000/subjects/#{subject.id}/tests"
puts "Test page: http://localhost:3000/subjects/#{subject.id}/tests/#{test.id}"
puts "Login: test@example.com"
puts "Password: password123"
