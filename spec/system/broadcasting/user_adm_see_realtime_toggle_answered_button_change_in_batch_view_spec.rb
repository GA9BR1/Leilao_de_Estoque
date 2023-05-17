require 'rails_helper'

describe 'Usuário(adm) vê a mudança do botão de mudar o status de resposta no lote', selenium: true do
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
    login_as(user)

    visit root_path
    click_on 'Leilões em andamento'
    click_on batch.code

    sleep 0.3
    expect(page).to have_content('Marcar como respondida')
    answer = Answer.create!(user_id: user2.id, doubt_id: doubt.id, content: 'Tangará da Serra')
  
    sleep 0.5
    expect(page).to have_content('Marcar como não respondida')
  end
end