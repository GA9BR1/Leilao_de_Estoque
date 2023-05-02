require 'rails_helper'

describe 'Usuário tenta se autenticar' do
  it 'com sucesso' do
    User.create!(email: 'gustavoalberttodev@gmail.com', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    visit root_path

    within 'form' do
      click_on 'Entrar'
    end
    within 'form#new_user' do
      fill_in 'E-mail', with: 'gustavoalberttodev@gmail.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Login efetuado com sucesso.')
  end

  it 'com dados incorretos' do
    User.create!(email: 'gustavoalberttodev@gmail.com', name: 'Gustavo Alberto', password: 'password', cpf: '70575930152')
    visit root_path

    within 'nav' do
      click_on 'Entrar'
    end
    within 'form#new_user' do
      fill_in 'E-mail', with: 'gustavo@gmail.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('E-mail ou senha inválidos')
  end
end
