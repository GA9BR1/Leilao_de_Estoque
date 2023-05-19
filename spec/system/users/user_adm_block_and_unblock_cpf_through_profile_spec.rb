require 'rails_helper'


describe 'Usuário(adm) bloqueia e desbloqueia um CPF através do perfil dele', selenium: true do
  it 'com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    doubt = Doubt.create!(content: 'SITE FAKE !', user_id: user3.id, batch_id: batch.id)
    login_as(user)

    visit root_path
    click_on "Leilões em andamento"
    click_on batch.code
    
    click_on user3.name
    click_on 'Bloquear CPF'
    
    expect(page).to have_content('Desbloquear CPF')

    expect(BlockedCpf.find(1).cpf.to_i).to eq(user3.cpf.to_i)
    expect(user3.reload.blocked_cpf_id).to eq(1)
    
    click_on 'Desbloquear CPF'
    sleep 0.5
    expect(BlockedCpf.count).to eq(0)
    expect(user3.reload.blocked_cpf_id).to eq(nil)
    sleep 0.3
    
    click_on 'Bloquear CPF'

    sleep 0.3
    expect(BlockedCpf.find(2).cpf.to_i).to eq(user3.cpf.to_i)
    expect(user3.reload.blocked_cpf_id).to eq(2)
    
    click_on 'Desbloquear CPF'
    sleep 0.5
    expect(BlockedCpf.count).to eq(0)
    expect(user3.reload.blocked_cpf_id).to eq(nil)
  end
end