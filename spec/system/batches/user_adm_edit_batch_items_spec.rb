require 'rails_helper'

describe 'Usuário(adm) edita o lote' do
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
                      weight: 100, width: 3, height: 3, depth: 1, item_category_id: processor_category.id)
    item2.image.attach(io: image_file2, filename: 'ryzen-9-7950X3D.jpg')
    item2.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)

    visit root_path
    click_on 'Lotes Cadastrados'
    click_on batch.code
    find("#batch_item_item_ids option", text: "#{item.registration_code} - #{item.name}").select_option
    find("#batch_item_item_ids option", text: "#{item2.registration_code} - #{item2.name}").select_option
    
    click_on 'Adicionar'
    expect(page).to have_content('Itens adicionados com sucesso')
    expect(BatchItem.count).to eq(2)
    expect(item.batch_items).not_to eq(nil)
    expect(item2.batch_items).not_to eq(nil)
  end

  it 'e falha ao tentar adicionar itens sem nenhum item selecionado' do
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
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)

    visit root_path
    click_on 'Lotes Cadastrados'
    click_on batch.code
    
    click_on 'Adicionar'
    expect(page).to have_content('Não foi possível adicionar o item')
    expect(BatchItem.count).to eq(0)
    expect(item.batch_items.count).to eq(0)
    expect(item2.batch_items.count).to eq(0)
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
    click_on 'Lotes Cadastrados'
    click_on batch.code


    find("#batch_item_ids option", text: "#{item.registration_code} - #{item.name}").select_option
    find("#batch_item_ids option", text: "#{item2.registration_code} - #{item2.name}").select_option

    click_on 'Remover'
    expect(page).to have_content('Itens removidos com sucesso')
    expect(BatchItem.count).to eq(0)
    expect(item.batch_items.count).to eq(0)
    expect(item2.batch_items.count).to eq(0)
  end

  it 'e falha ao tentar remover itens sem nenhum item selecionado' do
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
    click_on 'Lotes Cadastrados'
    click_on batch.code

    click_on 'Remover'
    expect(page).to have_content('Não foi possível remover o item')
    expect(BatchItem.count).to eq(2)
    expect(item.batch_items.count).to eq(1)
    expect(item2.batch_items.count).to eq(1)
  end

  it 'e aprova o lote com sucesso' do
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
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    BatchItem.create!(batch_id: batch.id, item_id: item2.id)
    login_as(user2)

    visit root_path
    click_on 'Lotes Cadastrados'
    click_on batch.code

    click_on 'Aprovar Lote'
    expect(page).to have_content('Lote aprovado com sucesso')
    expect(page).to have_content('Status: Aprovado')
    expect(page).not_to have_button('Aprovar Lote')
  end

  it 'e falha ao tentar aprovar o lote por si mesmo' do
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
    login_as(user)

    visit root_path
    click_on 'Lotes Cadastrados'
    click_on batch.code

    click_on 'Aprovar Lote'
    expect(page).to have_content('Você mesmo não pode aprovar o lote')
    expect(page).to have_content('Status: Aguardando aprovação')
    expect(page).to have_button('Aprovar Lote')
  end

  it 'e falha ao tentar aprovar o lote sem itens adicionados' do
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
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)

    login_as(user2)

    visit root_path
    click_on 'Lotes Cadastrados'
    click_on batch.code

    click_on 'Aprovar Lote'
    expect(page).to have_content('Você não pode aprovar um lote sem itens')
    expect(page).to have_content('Status: Aguardando aprovação')
    expect(page).to have_button('Aprovar Lote')
  end
end