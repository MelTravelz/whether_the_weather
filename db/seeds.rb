# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Users:
User.create(email: "dumbledoreschoolemail@hogwarts.com", password: "ImmaWizard!", api_key: "t1h2i3s4_i5s6_l7e8g9i10t11")
User.create(email: "harryschoolemail@hogwarts.com", password: "ImmaWizardbyGolly!", api_key: "5s6_l7e8gt1h2i3s4_i9i10t11")
User.create(email: "ronschoolemail@hogwarts.com", password: "ImmaWizardtoo!", api_key: "t1h10t112i3s4_i5s6_l7e8g9i")
User.create(email: "hermioneschoolemail@hogwarts.com", password: "WingardiumLeviosa", api_key: "t3s4_i51h2is6i10t11_l7e8g9")
