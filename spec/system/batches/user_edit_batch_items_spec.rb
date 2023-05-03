require 'rails_helper'

describe 'Usuário edita o lote com itens' do
  it 'e adiciona itens com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    processor_category = ItemCategory.create!(name: 'Processador')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    image_file2 = File.open("#{Rails.root}/spec/system/items/imgs/ryzen-9-7950X3D.jpg")
    item2 = Item.new(name: 'AMD Ryzen 9 7950X3D', description: 'Processador AMD Ryzen 9 7950X3D, 5.7GHz Max Turbo, Cache 144MB, AM5, 16 Núcleos, Vídeo Integrado - 100-100000908WOF',
                      weight: 100, width: 3, height: 3, depth: 1, item_category_id: processor_category)
    item2.image.attach(io: image_file2, filename: 'ryzen-9-7950X3D.jpg')
    item2.save

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    Batch.create(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id)
    login_as(user)
    visit root_path
    select "#{item.registration_code} | AMD Radeon HD7970 3GB Saphire", from: 'Itens'
    select "#{item2.registration_code} | AMD Ryzen 9 7950X3D", from: 'Itens'
    click_on 'Adicionar'
    expect(page).to have_content('Itens adicionados com sucesso')
    expect(BatchItems.count).to eq(2)
    expect(item.batch_items).not_to eq(nil)
    expect(item2.batch_items).not_to eq(nil)
  end
  
  it 'e remove itens com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    processor_category = ItemCategory.create!(name: 'Processador')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    image_file2 = File.open("#{Rails.root}/spec/system/items/imgs/ryzen-9-7950X3D.jpg")
    item2 = Item.new(name: 'AMD Ryzen 9 7950X3D', description: 'Processador AMD Ryzen 9 7950X3D, 5.7GHz Max Turbo, Cache 144MB, AM5, 16 Núcleos, Vídeo Integrado - 100-100000908WOF',
                      weight: 100, width: 3, height: 3, depth: 1, item_category_id: processor_category.id)
    item2.image.attach(io: image_file2, filename: 'ryzen-9-7950X3D.jpg')
    item2.save!
    

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    BatchItem.create!(batch_id: batch.id, item_id: item2.id)
    login_as(user)

    visit root_path

    within('form#remove_items') do
      select "#{item.registration_number} | AMD Radeon HD7970 3GB Saphire", from: 'Itens'
      select "#{item2.registration_number} | AMD Ryzen 9 7950X3D", from: 'Itens'
    end
    click_on 'Remover'
    expect(page).to have_content('Itens Removidos com sucesso')
    expect(BatchItems.count).to eq(0)
    expect(item.batch_items).to eq(nil)
    expect(item2.batch_items).to eq(nil)
  end
end