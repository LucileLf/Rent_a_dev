# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

require 'nokogiri'
require 'open-uri'

cities = [
  "Paris",
  "Marseille",
  "Lyon",
  "Toulouse",
  "Nice",
  "Nantes",
  "Strasbourg",
  "Montpellier",
  "Bordeaux",
  "Lille",
  "Rennes",
  "Reims",
  "Le Havre",
  "Cergy-Pontoise",
  "Saint-Étienne",
  "Toulon",
  "Angers",
  "Grenoble",
  "Dijon",
  "Nîmes",
  "Aix-en-Provence",
  "Saint-Quentin-en-Yvelines",
  "Brest",
  "Le Mans",
  "Amiens"
]

file_path = 'app/assets/classmates.html'
html_file = File.read(file_path)

html_doc = Nokogiri::HTML.parse(html_file)

student_divs = html_doc.css('[data-id]')

puts "Cleaning database..."
Developer.destroy_all
User.destroy_all
puts "Creating users..."
User.create!(email: "admin@email.com", first_name: 'Prénom', last_name: 'NOM', password: "admin123", admin: true)
puts "Creating developers..."

student_divs.each do |student_div|
  full_name = student_div.search(".mb-3").text.strip
  Developer.create!(
    first_name: full_name.split[0],
    last_name: full_name.split[1],
    description: student_div.search(".student-bio-wrapper").text,
    city: cities.sample,
    image_url: student_div.search("img").attribute("src").value,
    price_per_day: rand(20..80) * 10,
    user: User.last
  )
end

puts 'Finished!'
