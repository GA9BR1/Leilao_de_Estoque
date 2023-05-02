require 'rails_helper'

describe 'Usuário tenta editar um Item' do 
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    visit root_path
    click_on 'Itens Cadastrados'
    click_on 'Editar'
    fill_in 'Nome', with: 'RTX 4090'
    fill_in 'Descrição', with: 'Placa de Vídeo RTX 4090 Asus NVIDIA ROG Strix, 24 GB GDDR6X, ARGB, DLSS, Ray Tracing - ROG-STRIX-RTX4090-O24G-GAMING'
    attach_file("Imagem", Rails.root.join("spec/system/items/imgs/4090.jpg"))
    click_on 'Enviar'

    expect(page).to have_content('RTX 4090')
    expect(page).to have_content('Placa de Vídeo RTX 4090 Asus NVIDIA ROG Strix, 24 GB GDDR6X, ARGB, DLSS, Ray Tracing - ROG-STRIX-RTX4090-O24G-GAMING')
    expect(page).to have_css("img[src*='4090']")
    expect(page).to_not have_css("img[src*='download']")
  end

  it 'com dados faltantes' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')
    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save

    visit root_path
    click_on 'Itens Cadastrados'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Não foi possível atualizar o item')
    expect(page).to have_content('Verifique os erros abaixo')
  end
end
