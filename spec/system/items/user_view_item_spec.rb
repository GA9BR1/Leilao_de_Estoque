require 'rails_helper'

describe 'Usuário tenta ver itens cadastrados' do
  it 'e não há itens cadastrados' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    visit root_path
    click_on 'Itens Cadastrados'
    expect(page).to have_content('Não existem itens cadastrados')
  end
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
    expect(page).to have_content('AMD Radeon HD7970 3GB Saphire')
    expect(page).to have_content('Placa de vídeo para computador')
    expect(page).to have_content('3500')
    expect(page).to have_content('25')
    expect(page).to have_content('6')
    expect(page).to have_content('11')
    expect(page).to have_css("img[src*='download']")
  end
end