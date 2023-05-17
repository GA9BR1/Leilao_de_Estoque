require 'rails_helper'

describe 'Usuário tenta ver lotes que deu lance' do

  it 'e vê um lote vencedor' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    processor_category = ItemCategory.create!(name: 'Processador')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    Bid.create!(batch_id: batch.id, user_id: user3.id, amount: 100)
    batch.end_date = Date.today
    batch.save!
    batch.end_status = 'closed'
    batch.save!
    login_as(user3)
    visit root_path
    click_on 'Lotes com lances meus'
    expect(page).to have_content('Ganhador')
  end

  it 'e vê um lote perdedor' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    processor_category = ItemCategory.create!(name: 'Processador')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    
    Bid.create!(batch_id: batch.id, user_id: user2.id, amount: 100)
    Bid.create!(batch_id: batch.id, user_id: user3.id, amount: 150)
    Bid.create!(batch_id: batch.id, user_id: user.id, amount: 200)
    batch.end_date = Date.today
    batch.save!
    batch.end_status = 'closed'
    batch.save!
    login_as(user3)
    visit root_path
    click_on 'Lotes com lances meus'
    expect(page).to have_content('Perdedor')
  end

  it 'e vê um lote que está ganhando' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    processor_category = ItemCategory.create!(name: 'Processador')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    Bid.create!(batch_id: batch.id, user_id: user2.id, amount: 100)
    Bid.create!(batch_id: batch.id, user_id: user3.id, amount: 200)
    batch.end_date = Date.today
    batch.save!
    login_as(user3)
    visit root_path
    click_on 'Lotes com lances meus'
    expect(page).to have_content('Vencendo')
  end

  it 'e vê um lote que está perdendo' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    processor_category = ItemCategory.create!(name: 'Processador')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    Bid.create!(batch_id: batch.id, user_id: user2.id, amount: 100)
    Bid.create!(batch_id: batch.id, user_id: user3.id, amount: 150)
    Bid.create!(batch_id: batch.id, user_id: user.id, amount: 200)
    batch.end_date = Date.today
    batch.save!
    login_as(user3)
    visit root_path
    click_on 'Lotes com lances meus'
    expect(page).to have_content('Perdendo')
  end
end