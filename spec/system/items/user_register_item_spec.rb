require 'rails_helper'

describe 'Usuário tenta cadastrar um item' do
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    ItemCategory.create!(name: 'Placa de Vídeo')
    visit root_path
    within('nav') do
      click_on 'Cadastrar Item'
    end
    fill_in 'Nome', with: 'Placa de Vídeo - AMD HD7970 3gb'
    fill_in 'Descrição', with: 'Placa de vídeo AMD 384-bit Sapphire GDDR5'
    attach_file("Imagem", Rails.root.join("spec/system/items/imgs/download.jpg"))
    fill_in 'Peso', with: 400
    fill_in 'Largura', with: 30
    fill_in 'Altura', with: 20
    fill_in 'Profundidade', with: 20
    select 'Placa de Vídeo', from: 'Categoria'
    click_on 'Enviar'

    item = Item.find(1)
    expect(page).to have_content('Item cadastrado com sucesso!')
    expect(page).to have_content(item.registration_code)
  end

  it 'com campos faltantes' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    ItemCategory.create!(name: 'Placa de Vídeo')
    visit root_path
    within('nav') do
      click_on 'Cadastrar Item'
    end
    fill_in 'Nome', with: 'Placa de Vídeo - AMD HD7970 3gb'
    fill_in 'Descrição', with: 'Placa de vídeo AMD 384-bit Sapphire GDDR5'
    attach_file("Imagem", Rails.root.join("spec/system/items/imgs/download.jpg"))
    fill_in 'Peso', with: 400
    fill_in 'Largura', with: 30
    click_on 'Enviar'

    expect(Item.all.count).to eq(0)
    expect(page).to have_content('Não foi possível cadastrar o item')
  end
end
