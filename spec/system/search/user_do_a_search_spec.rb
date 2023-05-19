require 'rails_helper'

describe 'Usuário faz uma busca de um lote' do
  it 'pelo código e tem sucesso' do
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
    batch2 = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    BatchItem.create!(batch_id: batch2.id, item_id: item2.id)
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')

    batch.approved_by = user2
    batch2.approved_by = user2
    batch.save
    batch2.save

    login_as(user)


    visit root_path
    fill_in 'Buscar lote', with: batch.code.slice(0, batch.code.length - 3)
    click_on 'Buscar'

    expect(page).to have_content(batch.code)
    expect(page).to have_content(video_card_category.name)
  end

  it 'pelo nome de um item e tem sucesso' do
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
    batch2 = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    BatchItem.create!(batch_id: batch2.id, item_id: item2.id)
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')

    batch.approved_by = user2
    batch2.approved_by = user2
    batch.save
    batch2.save

    login_as(user)


    visit root_path
    fill_in 'Buscar lote', with: 'Ryzen'
    click_on 'Buscar'

    expect(page).to have_content(batch2.code)
    expect(page).to have_content(processor_category.name)
  end

  it 'e não encontra nenhum lote' do
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
    batch2 = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    BatchItem.create!(batch_id: batch2.id, item_id: item2.id)
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch.code = 'YYY-999999'
    batch2.code = 'ZZZ-999999'

    batch.approved_by = user2
    batch2.approved_by = user2
    batch.save
    batch2.save

    login_as(user)


    visit root_path
    fill_in 'Buscar lote', with: 'Mouse Gamer'
    click_on 'Buscar'

    expect(page).not_to have_content(batch2.code)
    expect(page).not_to have_content(batch.code)
    expect(page).to have_content('Nenhum lote foi encontrado')
  end
end