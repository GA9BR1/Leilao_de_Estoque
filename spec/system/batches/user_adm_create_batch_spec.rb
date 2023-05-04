require 'rails_helper'

describe 'Usuário(adm) tenta criar um lote' do
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    visit root_path
    click_on 'Cadastrar Lote'
    fill_in 'Data de início', with: Date.today
    fill_in 'Data do término', with: 7.day.from_now
    fill_in 'Lance mínimo', with: 100
    fill_in 'Diferença mínima entre lances', with: 30
    click_on 'Enviar'
    expect(Batch.count).to eq(1)
    expect(page).to have_content('Lote cadastrado com sucesso')
  end

  it 'com campos faltantes' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    visit root_path
    click_on 'Cadastrar Lote'
    fill_in 'Data de início', with: Date.today
    fill_in 'Data do término', with: 7.day.from_now
    fill_in 'Diferença mínima entre lances', with: 30
    click_on 'Enviar'
    expect(Batch.count).to eq(0)
    expect(page).to have_content('Não foi possível cadastrar o lote')
  end
end