require 'rails_helper'

describe 'Usuário deletar itens do lote' do 
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save
    BatchItem.create!(batch_id: batch.id, item_id: item.id)

    login_as(user)
    delete(batch_items_path, params: { batch_item: { batch_id: batch.id, ids: ['', '1'] } })
    expect(response).to redirect_to(show_admin_batch_path(batch.id))
    expect(BatchItem.count).to eq(0)
  end

  it 'e não tem autorização' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@email.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save
    BatchItem.create!(batch_id: batch.id, item_id: item.id)

    login_as(user2)
    delete(batch_items_path, params: { batch_item: { batch_id: batch.id, ids: ['', '1'] } })
    expect(response).to redirect_to(root_path)
    expect(BatchItem.count).to eq(1)
  end

  it 'e não está autenticado' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save
    BatchItem.create!(batch_id: batch.id, item_id: item.id)

    post(batch_items_path, params: { batch_item: { batch_id: batch.id, item_ids: ['', '1'] } })
    expect(response).to redirect_to(new_user_session_path)
    expect(BatchItem.count).to eq(1)
  end

  it 'e falso quando usúario autorizado tenta remover itens após lote ser aprovado' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'Joao Almeida', password: 'password', cpf: '72385675048')

    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    image_file2 = File.open("#{Rails.root}/spec/system/items/imgs/ryzen-9-7950X3D.jpg")
    processor_category = ItemCategory.create!(name: 'Processador')
    item2 = Item.new(name: 'AMD Ryzen 9 7950X3D', description: 'Processador AMD Ryzen 9 7950X3D, 5.7GHz Max Turbo, Cache 144MB, AM5, 16 Núcleos, Vídeo Integrado - 100-100000908WOF',
                      weight: 100, width: 3, height: 3, depth: 1, item_category_id: processor_category.id)
    item2.image.attach(io: image_file2, filename: 'ryzen-9-7950X3D.jpg')
    item2.save!
    
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    BatchItem.create!(batch_id: batch.id, item_id: item2.id)

    batch.approved_by = user2
    batch.save!
    login_as(user)
  
    delete(batch_items_path, params: { batch_item: { batch_id: batch.id, ids: ['', '1', '2'] } })
    expect(response).to redirect_to(show_admin_batch_path(batch.id))
    expect(BatchItem.count).to eq(2)
  end
end