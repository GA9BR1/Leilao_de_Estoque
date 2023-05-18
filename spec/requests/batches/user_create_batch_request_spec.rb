require 'rails_helper'

describe 'Usuário tenta criar uma lote' do 
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    post(batches_path, params: {batch: {start_date: Date.today, end_date: 7.day.from_now, minimum_bid: 30, minimum_bid_difference: 50, created_by_id: user.id}})
    expect(response).to redirect_to(show_admin_batch_path(1))
    expect(Batch.count).to eq(1)
  end
  it 'e não tem autorização' do
    user = User.create!(email: 'gustavo@gmail.com', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    post(batches_path, params: {batch: {start_date: Date.today, end_date: 7.day.from_now, minimum_bid: 30, minimum_bid_difference: 50, created_by_id: user.id}})
    expect(response).to redirect_to(root_path)
    expect(Batch.count).to eq(0)
  end
  it 'e não está autenticado' do
    post(batches_path, params: {batch: {start_date: Date.today, end_date: 7.day.from_now, minimum_bid: 30, minimum_bid_difference: 50, created_by_id: 1}})
    expect(response).to redirect_to(new_user_session_path)
    expect(Batch.count).to eq(0)
  end
  it 'e falha ao tentar criar no nome de outra pessoa' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    login_as(user)
    post(batches_path, params: {batch: {start_date: Date.today, end_date: 7.day.from_now, minimum_bid: 30, minimum_bid_difference: 50, created_by_id: user2.id}})
    expect(Batch.count).to eq(0)
  end
end