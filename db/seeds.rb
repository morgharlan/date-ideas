# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Clear existing data
SavedDate.destroy_all
DateIdea.destroy_all
User.destroy_all

# Create sample users
users = User.create!([
  { email: 'john@example.com', password: 'password123' },
  { email: 'jane@example.com', password: 'password123' }
])

# Create sample date ideas
date_ideas = DateIdea.create!([
  {
    title: 'Romantic Dinner',
    description: 'Fine dining at a cozy restaurant',
    budget: 150.00,
    time_of_day: 'evening',
    setting: 'indoor',
    effort: 'low',
    city: 'New York'
  },
  {
    title: 'Hiking Adventure',
    description: 'Scenic trail hike with picnic',
    budget: 25.00,
    time_of_day: 'morning',
    setting: 'outdoor',
    effort: 'high',
    latitude: 40.7128,
    longitude: -74.0060,
    city: 'New York'
  },
  {
    title: 'Movie Night',
    description: 'Cozy night in watching movies',
    budget: 20.00,
    time_of_day: 'evening',
    setting: 'indoor',
    effort: 'low',
    city: 'New York'
  }
])

# Create some saved dates
SavedDate.create!([
  {
    user: users.first,
    date_idea: date_ideas.first,
    note: 'Perfect for anniversary!',
    favorite: true,
    completed: false
  },
  {
    user: users.first,
    date_idea: date_ideas.second,
    note: 'Great weekend activity',
    favorite: false,
    completed: true
  }
])

puts "Created #{User.count} users, #{DateIdea.count} date ideas, and #{SavedDate.count} saved dates"
