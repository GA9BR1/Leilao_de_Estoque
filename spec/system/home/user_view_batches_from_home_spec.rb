require 'rails_helper'

describe 'Usuário/visitante tenta ver lotes a partir da página inicial' do
  it 'e não existem leilões' do
    visit root_path 
    click_on 'Leilões em andamento'
    expect(page).to have_content('Não existem leilões em andamento')
  end

  it 'e vê leilão em andamento com sucesso' do
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
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    BatchItem.create!(batch_id: batch.id, item_id: item2.id)

    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')

    batch.approved_by = user2
    batch.save

    visit root_path
    click_on 'Leilões em andamento'
    click_on batch.code
    expect(page).to have_content("#{item.registration_code} - #{item.name}")
    expect(page).to have_content("#{item2.registration_code} - #{item2.name}")
    expect(page).to have_content('Status: Aprovado')
  end

  it 'e vê leilão futuro com sucesso' do
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
    batch = Batch.create!(start_date: 2.day.from_now, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    BatchItem.create!(batch_id: batch.id, item_id: item2.id)

    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')

    batch.approved_by = user2
    batch.save

    visit root_path
    click_on 'Leilões futuros'
    click_on batch.code
    expect(page).to have_content("#{item.registration_code} - #{item.name}")
    expect(page).to have_content("#{item2.registration_code} - #{item2.name}")
    expect(page).to have_content('Status: Aprovado')
  end
end