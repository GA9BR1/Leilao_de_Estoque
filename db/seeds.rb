# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
processor_category = ItemCategory.create!(name: 'Processador')
User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')



# As imagens estão aparecendo sem resize com o seeed, porém no upload da imagem elas sobem no resize correto

image_file = File.open("#{Rails.root}/images/download.jpg")
item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
item.image.attach(io: image_file, filename: 'download.jpg')
item.save!


image_file2 = File.open("#{Rails.root}/spec/system/items/imgs/ryzen-9-7950X3D.jpg")
item2 = Item.new(name: 'AMD Ryzen 9 7950X3D', description: 'Processador AMD Ryzen 9 7950X3D, 5.7GHz Max Turbo, Cache 144MB, AM5, 16 Núcleos, Vídeo Integrado - 100-100000908WOF',
                 weight: 100, width: 3, height: 3, depth: 1, item_category_id: processor_category.id)
item2.image.attach(io: image_file2, filename: 'ryzen-9-7950X3D.jpg')
item2.save!
