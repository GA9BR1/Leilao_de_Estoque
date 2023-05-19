require 'rails_helper'

describe 'Usuário tenta criar uma resposta para uma dúvida', selenium: true do
  it 'e consegue com sucesso' do
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
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')

    visit root_path
    click_on "Leilões em andamento"
    click_on batch.code
    
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
      fill_in 'Resposta', with: 'Alguém aí?'
      click_on 'Enviar'
    end

    expect(page).to have_content('Alguém aí?')
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).not_to have_content('Alguém aí?')
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).to have_content('Alguém aí?')
  end

  it 'e falha por estar com o CPF bloqueado' do
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
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
    blocked_cpf = BlockedCpf.create!(cpf: user3.cpf)
    user3.blocked_cpf_id = blocked_cpf.id
    user3.save

    visit root_path
    click_on "Leilões em andamento"
    click_on batch.code
    
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
      fill_in 'Resposta', with: 'Alguém aí?'
      click_on 'Enviar'
    end

    expect(Answer.count).to eq(0)
    expect(page).to have_content('Sua conta está suspensa')
  end

  it 'e falha porque o campo está vazio' do
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
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')

    visit root_path
    click_on "Leilões em andamento"
    click_on batch.code
    
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
      click_on 'Enviar'
    end

    expect(Answer.all.count).to eq(0) 
  end

  it 'e consegue com sucesso(ADM)' do
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
    login_as(user)
    doubt = Doubt.create!(user_id: user.id, batch_id: batch.id, content: 'O local de retirada é em Tangará da Serra')

    visit root_path
    click_on "Leilões em andamento"
    click_on batch.code
    
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
      sleep 1
      fill_in 'Resposta', with: 'Dia 28'
      click_on 'Enviar'
    end

    sleep 1

    expect(page).to have_content('Dia 28')
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).not_to have_content('Dia 28')
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).to have_content('Dia 28')
  end

  it 'e falha porque o campo está vazio(ADM)' do
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
    login_as(user)
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'O local de retirada é em Tangará da Serra')

    visit root_path
    click_on "Leilões em andamento"
    click_on batch.code
    
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
      fill_in 'Resposta', with: ''
      click_on 'Enviar'
    end


    expect(Answer.all.count).to eq(0)
  end
end