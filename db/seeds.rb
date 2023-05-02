# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')

image_file = File.open("#{Rails.root}/images/download.jpg")

item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)

item.image.attach(io: image_file, filename: 'download.jpg')
item.save!
