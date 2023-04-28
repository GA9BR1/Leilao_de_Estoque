require 'rails_helper'

describe 'Usuário visita a tela inicial' do
  it 'Usuário entra no endereço da tela inicial' do
    visit root_path
    expect(current_path).to eq(root_path)
  end

  it 'Usuário vê o nome do site' do
    visit root_path
    within('nav') do
      expect(page).to have_content('Leilão do Desenvolvedor')
    end
  end
end
