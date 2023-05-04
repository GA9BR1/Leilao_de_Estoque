require 'rails_helper'

describe 'Usuário tenta criar uma lote' do 
  it 'com sucesso' do
    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    post(batches_path, params: {batch: {start_date: Date.today, end_date: 7.day.from_now, minimum_bid: 30, minimum_bid_difference: 50}})
    expect(response).to redirect_to(batch_path(1))
    expect(Batch.count).to eq(1)
  end
  it 'e não tem autorização' do
    user = User.create!(email: 'gustavo@gmail.com', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    login_as(user)
    post(batches_path, params: {batch: {start_date: Date.today, end_date: 7.day.from_now, minimum_bid: 30, minimum_bid_difference: 50}})
    expect(response).to redirect_to(root_path)
    expect(Batch.count).to eq(0)
  end
  it 'e não está autenticado' do
    post(batches_path, params: {batch: {start_date: Date.today, end_date: 7.day.from_now, minimum_bid: 30, minimum_bid_difference: 50}})
    expect(response).to redirect_to(new_user_session_path)
    expect(Batch.count).to eq(0)
  end
end