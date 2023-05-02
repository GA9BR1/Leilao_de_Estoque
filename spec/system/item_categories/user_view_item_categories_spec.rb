require 'rails_helper'

describe 'Usuário vê categorias cadastradas' do
  it 'e não há categorias cadastradas' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    visit root_path
    click_on 'Cadastrar Categoria'
    expect(page).to have_content('Nâo existem categorias cadastradas')
  end
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    ItemCategory.create!(name: 'Placa de Vídeo')
    ItemCategory.create!(name: 'Processador')
    visit root_path
    click_on 'Cadastrar Categoria'
    expect(page).to have_content('Placa de Vídeo')
    expect(page).to have_content('Processador')
  end
end