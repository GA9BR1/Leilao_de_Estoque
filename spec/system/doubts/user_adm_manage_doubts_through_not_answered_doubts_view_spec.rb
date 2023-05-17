require 'rails_helper'


describe 'Usuário(ADM) gerencia as dúvidas através da view de dúvidas não respondidas', selenium: true, js: true do
  context 'e muda o status de respondido' do
    it 'através de uma resposta' do
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
      doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
      login_as(user)

      visit root_path
      click_on 'Dúvidas em aberto'
     
      sleep 0.5
      within "div#doubt_#{doubt.id}" do
        click_on 'Respostas'
        fill_in 'Resposta', with: 'Presencialmente em Tangará da Serra'
        click_on 'Enviar'
      end

      expect(page).to have_content('Marcar como não respondida')
      expect(doubt.reload.answered).to be(true)
    end

    it 'através do botão, seta e deseta', js: true do
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
      doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
      login_as(user)

      visit root_path
      click_on 'Dúvidas em aberto'

      sleep 0.4
      script = <<-JS
        var button = document.getElementById("button_toggle_answered_1")
        button.click();
      JS

      page.execute_script(script)


      expect(page).to have_content('Marcar como não respondida')
      expect(doubt.reload.answered).to eq(true)
     
      page.execute_script(script)

      expect(page).to have_content('Marcar como respondida')
      expect(doubt.reload.answered).to eq(false)
    end
  end
  context 'oculta e desoculta um comentário' do
    it 'através do botão' do
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
      doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'LEILÃO FAKE !')
      login_as(user)

      visit root_path
      click_on 'Dúvidas em aberto'

      sleep 0.4
      script = <<-JS
        var button = document.getElementById("button_toggle_visibility_1")
        button.click();
      JS

      page.execute_script(script)

      expect(page).to have_content('Desocultar')
      expect(page).to have_content('Oculto')
      expect(doubt.reload.visible).to eq(false)

      page.execute_script(script)

      expect(page).to have_content('Ocultar')
      expect(page).not_to have_content('Oculto')
      expect(doubt.reload.visible).to eq(true)
    end
  end
end