require 'rails_helper'

describe 'Usuário tenta editar um item' do 
  it 'com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save
    patch(item_path(item.id), params: {item: {name: 'A'}})
    expect(response).to redirect_to(items_path)
    expect(Item.find(item.id).name).to eq('A')
    expect(Item.find(item.id).description).to eq('Placa de vídeo para computador')
  end

  it 'e não tem autorização' do
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    user = User.create!(email: 'gustavo@123.com', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save
    patch(item_path(item.id), params: {item: {name: 'A'}})
    expect(response).to redirect_to(root_path)
    expect(Item.find(item.id).name).to eq('AMD Radeon HD7970 3GB Saphire')
    expect(Item.find(item.id).description).to eq('Placa de vídeo para computador')
  end

  it 'e não está autenticado' do
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save
    patch(item_path(item.id), params: {item: {name: 'A'}})
    expect(response).to redirect_to(new_user_session_path)
    expect(Item.find(item.id).name).to eq('AMD Radeon HD7970 3GB Saphire')
    expect(Item.find(item.id).description).to eq('Placa de vídeo para computador')
  end
end