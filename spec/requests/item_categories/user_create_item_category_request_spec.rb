require 'rails_helper'

describe 'Usuário tenta criar uma categoria' do 
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    post(item_categories_path, params: {item_category: {name: 'Placa de Vídeo'}})
    expect(response).to redirect_to(new_item_category_path)
    expect(ItemCategory.count).to eq(1)
    expect(ItemCategory.find(1).name).to eq('Placa de Vídeo')
  end
  it 'e não tem autorização' do
    user = User.create!(email: 'gustavo@1234.com', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    post(item_categories_path, params: {item_category: {name: 'Placa de Vídeo'}})
    expect(response).to redirect_to(root_path)
    expect(ItemCategory.count).to eq(0)
  end
  it 'e não está autenticado' do 
    post(item_categories_path, params: {item_category: {name: 'Placa de Vídeo'}})
    expect(response).to redirect_to(new_user_session_path)
    expect(ItemCategory.count).to eq(0)
  end
end