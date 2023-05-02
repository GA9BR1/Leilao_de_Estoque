require 'rails_helper'

describe 'Usuário tenta registar uma categoria de item' do 
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    visit root_path
    click_on 'Cadastrar Categoria'
    fill_in 'Nome', with: 'Processador'
    click_on 'Enviar'

    expect(page).to have_content('Categoria cadastrada com sucesso')
    expect(page).to have_content('Processador')
  end
  it 'com o campo faltante' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    visit root_path
    click_on 'Cadastrar Categoria'
    fill_in 'Nome', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Não foi possível cadastrar a categoria')
    expect(page).not_to have_content('Processador')
  end
end