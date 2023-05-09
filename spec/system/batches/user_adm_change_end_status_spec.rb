require 'rails_helper'

describe 'Usuário(adm), tenta mudar o status final do lote' do
  it 'mudando o status final para closed com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    processor_category = ItemCategory.create!(name: 'Processador')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    Bid.create!(batch_id: batch.id, user_id: user.id, amount: 100)
    login_as(user2)
    visit root_path
    click_on 'Leilões em andamento'
    batch.end_date = Date.today
    batch.save!
    click_on batch.code
    click_on 'Concluir leilão'
    expect(batch.reload.end_status).to eq('closed')
  end
  it 'mudando o status final para canceled com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    processor_category = ItemCategory.create!(name: 'Processador')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '72385675048')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 100)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    login_as(user2)
    visit root_path
    click_on 'Leilões em andamento'
    batch.end_date = Date.today
    batch.save!
    click_on batch.code
    click_on 'Cancelar lote'
    expect(batch.reload.end_status).to eq('canceled')
  end
end