require 'rails_helper'

describe 'Usuário tenta editar uma categoria' do
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    ItemCategory.create!(name: 'Placa de Vídeo')
    visit root_path
    click_on 'Cadastrar Categoria'
    click_on 'Editar'
    fill_in 'Nome', with: 'Processador'
    click_on 'Enviar'
    expect(page).to have_content('Categoria editada com sucesso')
    expect(page).to have_content('Processador')
    expect(page).not_to have_content('Placa de vídeo')
  end

  it 'com dados faltantes' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    ItemCategory.create!(name: 'Placa de Vídeo')
    visit root_path
    click_on 'Cadastrar Categoria'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    click_on 'Enviar'
    expect(page).to have_content('Não foi possível editar a categoria')
    expect(page).to have_content('Verifique o erro abaixo')
  end

end