require 'rails_helper'


describe 'Usuário(adm) bloqueia e desbloqueia um CPF da página específica para isso', selenium: true do
  it 'bloqueia e desbloqueia um usuário ativo com sucesso' do

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user)

    visit root_path
    click_on "Bloquear ou desbloquear um CPF"
    fill_in 'CPF', with: 61492939048
    click_on 'Enviar'

    expect(page).to have_content('CPF bloqueado com sucesso')
   
    expect(BlockedCpf.find(1).cpf.to_i).to eq(user3.cpf.to_i)
    expect(user3.reload.blocked_cpf_id).to eq(1)
    sleep 0.3

    fill_in 'CPF', with: 61492939048
    click_on 'Enviar'
    
    expect(page).to have_content('CPF desbloqueado com sucesso')
    sleep 0.3
    expect(BlockedCpf.count).to eq(0)
    expect(user3.reload.blocked_cpf_id).to eq(nil)
    sleep 0.3
    
    fill_in 'CPF', with: 61492939048
    click_on 'Enviar'

    expect(page).to have_content('CPF bloqueado com sucesso')

    sleep 0.3
    expect(BlockedCpf.find(2).cpf.to_i).to eq(user3.cpf.to_i)
    expect(user3.reload.blocked_cpf_id).to eq(2)
  end

  it 'bloqueia e desbloqueia um usuário não cadastrado' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user)

    visit root_path
    click_on "Bloquear ou desbloquear um CPF"
    fill_in 'CPF', with: 78480822023
    click_on 'Enviar'

    expect(page).to have_content('CPF bloqueado com sucesso')
   
    expect(BlockedCpf.find(1).cpf.to_i).to eq(78480822023)
    sleep 0.3

    fill_in 'CPF', with: 78480822023
    click_on 'Enviar'
    
    expect(page).to have_content('CPF desbloqueado com sucesso')
    sleep 0.3
    expect(BlockedCpf.count).to eq(0)
    sleep 0.3
    
    fill_in 'CPF', with: 78480822023
    click_on 'Enviar'

    expect(page).to have_content('CPF bloqueado com sucesso')

    sleep 0.3
    expect(BlockedCpf.find(2).cpf.to_i).to eq(78480822023)
  end
end