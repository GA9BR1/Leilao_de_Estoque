require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'gera um código aleatório' do
    it 'ao criar um novo item' do
      user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
      login_as(user)
      video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
      image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
      item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                      weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
      item.image.attach(io: image_file, filename: 'download.jpg')
      item.save
      expect(item.registration_code).not_to be_empty
      expect(item.registration_code.length).to eq(10)
    end

    it 'e o código é único' do
      user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
      login_as(user)
      video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
      image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
      item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                      weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
      item.image.attach(io: image_file, filename: 'download.jpg')
      item.save
      processor_category = ItemCategory.create!(name: 'Processador')
      image_file2 = File.open("#{Rails.root}/spec/system/items/imgs/ryzen-9-7950X3D.jpg")
      item2 = Item.new(name: 'AMD Ryzen 9 7950X3D', description: 'Processador AMD Ryzen 9 7950X3D, 5.7GHz Max Turbo, Cache 144MB, AM5, 16 Núcleos, Vídeo Integrado - 100-100000908WOF',
                       weight: 100, width: 3, height: 3, depth: 1, item_category_id: processor_category)
      item2.image.attach(io: image_file2, filename: 'ryzen-9-7950X3D.jpg')
      item2.save

      expect(item.registration_code).not_to eq(item2.registration_code)
    end

    it 'e não deve ser modificado' do
      user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
      login_as(user)
      video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
      image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
      item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                      weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
      item.image.attach(io: image_file, filename: 'download.jpg')
      item.save
      original_code = item.registration_code
      item.update(name: 'AMD Radeon HD7970 4gb Saphire')

      expect(original_code).to eq(item.registration_code)
    end
  end
end
