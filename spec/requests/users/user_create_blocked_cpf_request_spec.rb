require 'rails_helper'

describe 'Usuário cria request para bloquear ou desbloquer um cpf' do
  it 'pelo id para um usuário cadastrado e tem sucesso bloqueando' do 
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user)
    patch(block_user_cpf_path(id: user3.id))
    expect(user3.reload.blocked_cpf).not_to eq(nil)
    expect(BlockedCpf.count).not_to eq(0)
  end

  it 'pelo id para um usuário cadastrado e tem sucesso desbloqueando' do 
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user)
    blocked_cpf = BlockedCpf.create!(cpf: user3.cpf)
    user3.blocked_cpf_id = blocked_cpf.id
    user3.save

    patch(block_user_cpf_path(id: user3.id))
    expect(user3.reload.blocked_cpf).to eq(nil)
    expect(BlockedCpf.count).to eq(0)
  end

  it 'e falha em tentar bloquear um cpf por não ter autorização' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user3)
    patch(block_user_cpf_path(id: user.id))
    expect(user.reload.blocked_cpf).to eq(nil)
    expect(BlockedCpf.count).to eq(0)
  end

  it 'e falha ao bloquear o cpf de um usuário que o id não existe' do 
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user)
    expect { patch block_user_cpf_path(id: 50) }.to raise_error(ActiveRecord::RecordNotFound)
    expect(user3.reload.blocked_cpf).to eq(nil)
    expect(BlockedCpf.count).to eq(0)
  end

  it 'pelo cpf para um usuário cadastrado e tem sucesso bloqueando' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user)
    patch(block_user_cpf_in_page_path(cpf: user3.cpf))
    expect(user3.reload.blocked_cpf).not_to eq(nil)
    expect(BlockedCpf.count).not_to eq(0)
  end

  
  it 'pelo cpf para um usuário não cadastrado e tem sucesso bloqueando' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    patch(block_user_cpf_in_page_path(cpf: 61492939048))
    expect(BlockedCpf.count).not_to eq(0)
  end

  it 'pelo cpf para um usuário não cadastrado e tem sucesso desbloqueando' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    BlockedCpf.create!(cpf: 61492939048)
    login_as(user)
    patch(block_user_cpf_in_page_path(cpf: 61492939048))
    expect(BlockedCpf.count).to eq(0)
  end

  it 'pelo cpf para um usuário cadastrado e tem sucesso desbloqueando' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user)
    blocked_cpf = BlockedCpf.create!(cpf: user3.cpf)
    user3.blocked_cpf_id = blocked_cpf.id
    user3.save

    patch(block_user_cpf_in_page_path(cpf: user3.cpf))
    expect(user3.reload.blocked_cpf).to eq(nil)
    expect(BlockedCpf.count).to eq(0)
  end

  it 'e falha ao bloquear o cpf de um usuário que o cpf não é válido' do 
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    login_as(user)
    patch(block_user_cpf_in_page_path(cpf: 61492939045))
    expect(user3.reload.blocked_cpf).to eq(nil)
    expect(BlockedCpf.count).to eq(0)
  end
end