require 'rails_helper'

describe 'Usuário tenta criar um item' do
  it 'com sucesso' do 
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    post(items_path, params: {item: {name: item.name, image: fixture_file_upload(image_file, 'download/jpg'), description: item.description, weight: item.weight, width: item.width, height: item.height, depth: item.depth, item_category_id: item.item_category_id}})
    expect(response).to redirect_to(items_path)
    expect(Item.count).to eq(1)
  end

  it 'e não têm autorização' do
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    user = User.create!(email: 'gustavo@123.com', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    post(items_path, params: {item: {name: item.name, image: fixture_file_upload(image_file, 'download/jpg'), description: item.description, weight: item.weight, width: item.width, height: item.height, depth: item.depth, item_category_id: item.item_category_id}})
    expect(response).to redirect_to(root_path)
    expect(Item.count).to eq(0)
  end
  
  it 'e não está autenticado' do
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    post(items_path, params: {item: {name: item.name, image: fixture_file_upload(image_file, 'download/jpg'), description: item.description, weight: item.weight, width: item.width, height: item.height, depth: item.depth, item_category_id: item.item_category_id}})
    expect(response).to redirect_to(new_user_session_path)
    expect(Item.count).to eq(0)
  end
end