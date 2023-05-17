require 'rails_helper'

describe 'Usuário vê a adição de uma resposta em tempo real no lote e na dúvida correta', selenium: true do
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
    doubt2 = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Alguém responde ?')
    doubt3 = Doubt.create!(user_id: user.id, batch_id: batch.id, content: 'Tudo tranquilo gente ?')
    login_as(user4)

    visit root_path
    click_on 'Leilões em andamento'
    click_on batch.code

    sleep 0.5
    within "div#doubt_#{doubt2.id}" do
      click_on 'Respostas'
    end
    answer = Answer.create!(user_id: user2.id, doubt_id: doubt2.id, content: 'Calma kkkk')

    sleep 0.5
    expect(page).to have_content(answer.content)
    expect(page).to have_content(user2.name)
  end

  it 'com sucesso(adm)' do
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
    doubt2 = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Alguém responde ?')
    doubt3 = Doubt.create!(user_id: user2.id, batch_id: batch.id, content: 'Tudo tranquilo gente ?')
    login_as(user)

    visit root_path
    click_on 'Leilões em andamento'
    click_on batch.code
    
    sleep 0.5
    within "div#doubt_#{doubt2.id}" do
      click_on 'Respostas'
    end
    answer = Answer.create!(user_id: user4.id, doubt_id: doubt2.id, content: 'Calma kkkk')

    sleep 1
    expect(Answer.all.count).to eq(1)
    expect(page).to have_content(answer.content)
    expect(page).to have_content(user4.name)
  end
end