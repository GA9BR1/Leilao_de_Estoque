require 'rails_helper'

describe 'Usuário cria uma request de resposta' do
  it 'com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    user4 = User.create!(email: 'lima@gmail.com ', name: 'João Lima', password: 'password', cpf: '04012209078')
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
    login_as(user4)

    post(batch_doubt_answers_path(batch.id, doubt.id), params: {answer: {doubt_id: doubt.id, user_id: user4.id, content: 'Em Tangará da Serra'}})

    expect(doubt.answers.count).to eq(1)
  end

  it 'e não está autenticado' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    user4 = User.create!(email: 'lima@gmail.com ', name: 'João Lima', password: 'password', cpf: '04012209078')
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')

    post(batch_doubt_answers_path(batch.id, doubt.id), params: {answer: {doubt_id: doubt.id, user_id: user4.id, content: 'Em Tangará da Serra'}})

    expect(doubt.answers.count).to eq(0)
  end

  it 'e o leilão já acabou e não é o ganhador' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: 7.day.ago, end_date: 3.day.ago, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    user4 = User.create!(email: 'lima@gmail.com ', name: 'João Lima', password: 'password', cpf: '04012209078')
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
    login_as(user4)

    post(batch_doubt_answers_path(batch.id, doubt.id), params: {answer: {doubt_id: doubt.id, user_id: user4.id, content: 'Em Tangará da Serra'}})

    expect(doubt.answers.count).to eq(0)
  end

  it 'e o leilão já acabou mas é o ganhador' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: 7.day.ago, end_date: 3.day.ago, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    user4 = User.create!(email: 'lima@gmail.com ', name: 'João Lima', password: 'password', cpf: '04012209078')
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
    Bid.create!(batch_id: batch.id, user_id: user3.id, amount: 30)
    Bid.create!(batch_id: batch.id, user_id: user4.id, amount: 60)
    login_as(user4)

    post(batch_doubt_answers_path(batch.id, doubt.id), params: {answer: {doubt_id: doubt.id, user_id: user4.id, content: 'Em Tangará da Serra'}})

    expect(doubt.answers.count).to eq(1)
  end

  it 'e falha ao tentar criar a resposta com o id de outro usuário' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    user4 = User.create!(email: 'lima@gmail.com ', name: 'João Lima', password: 'password', cpf: '04012209078')
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
    login_as(user4)

    post(batch_doubt_answers_path(batch.id, doubt.id), params: {answer: {doubt_id: doubt.id, user_id: user.id, content: 'ESSE SITE É FAKE ! CORRAM !'}})

    expect(doubt.answers.count).to eq(0)
  end
end