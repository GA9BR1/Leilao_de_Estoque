require 'rails_helper'

describe 'Usuário tenta se registrar' do
  it 'com sucesso' do
    visit root_path

    click_on 'Entrar'
    
    click_on 'Cadastrar-se'
    expect(page).to have_content('Cadastrar-se')

    within 'form#new_user' do
      fill_in 'Nome', with: 'Gustavo Alberto'
      fill_in 'E-mail', with: 'gustavoalberttodev@gmail.com'
      fill_in 'CPF', with: '73896923080'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Cadastrar-se'
    end

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
  end

  it 'com campos incompletos' do
    visit root_path

    within 'nav' do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'
    expect(page).to have_content('Cadastrar-se')

    within 'form#new_user' do
      click_on 'Cadastrar-se'
    end

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('CPF inválido')
    expect(page).to have_content('E-mail não pode ficar em branco')
    expect(page).to have_content('Senha não pode ficar em branco')
  end
end