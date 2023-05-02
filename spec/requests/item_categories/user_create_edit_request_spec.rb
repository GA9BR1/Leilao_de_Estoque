require 'rails_helper'

describe 'Usuário tenta criar uma categoria' do 
  it 'com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    patch(item_category_path(video_card_category.id), params: {item_category: {name: 'Processador'}})
    expect(response).to redirect_to(new_item_category_path)
    expect(ItemCategory.count).to eq(1)
    expect(ItemCategory.find(video_card_category.id).name).to eq('Processador')
  end
  it 'e não tem autorização' do
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    user = User.create!(email: 'gustavo@1234.com', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    patch(item_category_path(video_card_category.id), params: {item_category: {name: 'Processador'}})
    expect(response).to redirect_to(root_path)
    expect(ItemCategory.count).to eq(1)
    expect(ItemCategory.find(video_card_category.id).name).to eq(video_card_category.name)
  end
  it 'e não está autenticado' do
    video_card_category = ItemCategory.create!(name: 'Placa de Vídeo')
    patch(item_category_path(video_card_category.id), params: {item_category: {name: 'Processador'}})
    expect(response).to redirect_to(new_user_session_path)
    expect(ItemCategory.count).to eq(1)
    expect(ItemCategory.find(video_card_category.id).name).to eq(video_card_category.name)
  end
end