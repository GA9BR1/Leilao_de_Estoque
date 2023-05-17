require 'rails_helper'

describe 'Usuário tenta ver os lances' do
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
    login_as(user3)
    Bid.create!(batch_id: batch.id, user_id: user.id, amount: 30)
    Bid.create!(batch_id: batch.id, user_id: user3.id, amount: 60)

    visit root_path
    click_on 'Leilões em andamento'
    click_on batch.code

    expect(page).to have_content('Lance #1')
    expect(page).to have_content('30')
    expect(page).to have_content(user.name)
    expect(page).to have_content('Lance #2')
    expect(page).to have_content('60')
    expect(page).to have_content(user3.name)
  end


  it 'e falha pelo leilão do lote ainda não estar em andamento' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: 2.day.from_now, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user3)
    Bid.create!(batch_id: batch.id, user_id: user.id, amount: 30)
    Bid.create!(batch_id: batch.id, user_id: user3.id, amount: 60)

    visit batch_path(batch.id)

    expect(page).to have_content('O leilão ainda não iniciou')
  end

  it 'e não há lances ainda' do
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
    login_as(user3)

    visit root_path
    click_on 'Leilões em andamento'
    click_on batch.code

    expect(page).to have_content('Ainda não existem lances nesse lote')
  end

  it 'e não está autenticado, atuentica-se, volta para a página e consegue dar lances', selenium: true do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    Bid.create!(batch_id: batch.id, user_id: user.id, amount: 30)
    Bid.create!(batch_id: batch.id, user_id: user2.id, amount: 60)


    visit root_path
    click_on 'Leilões em andamento'
    click_on batch.code

    expect(page).to have_content('Faça login para realizar um lance')
    within 'p#do_login_bid' do
      click_on 'Faça login'
    end
    fill_in 'E-mail', with: 'leticia@gmail.com'
    fill_in 'Senha', with: 'password'
    within 'form#new_user' do
      click_on 'Entrar'
    end

    fill_in 'Valor', with: '90'
    click_on 'Fazer lance!'

    expect(page).to have_content('Lance #1')
    expect(page).to have_content('30')
    expect(page).to have_content(user.name)
    expect(page).to have_content('Lance #2')
    expect(page).to have_content('60')
    expect(page).to have_content(user2.name)
    expect(page).to have_content('Lance #3')
    expect(page).to have_content('90')
    expect(page).to have_content(user3.name)
    expect(Bid.count).to eq(3)
  end
end