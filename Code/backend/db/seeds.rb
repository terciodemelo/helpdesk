# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SupportAgent.create(
  name: 'Support Um',
  email: 'support1@mailinator.com',
  password: 'support1'
)


Admin.create(
  name: 'Admin',
  email: 'admin@mailinator.com',
  password: 'admin'
)
