require 'rails_helper'

RSpec.describe Batch, type: :model do
  describe 'gera um código aleatório com 3 letras e 6 números' do
    it 'ao criar um novo item' do
      user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
      login_as(user)
      batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)

      expect(batch.code).not_to be_empty
      expect(batch.code).to match(/\A[A-Z]{3}-\d{6}\z/)
    end

    it 'e o código é único' do
      user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
      login_as(user)
      batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
      batch2 = Batch.create!(start_date: Date.today, end_date: 8.day.from_now, minimum_bid_difference: 10, created_by_id: user.id, minimum_bid: 35)

      expect(batch.code).not_to eq(batch2.code)
    end

    it 'e não deve ser modificado' do
      user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
      login_as(user)
      batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
      original_code = batch.code
      batch.update!(minimum_bid: 50)

      expect(original_code).to eq(batch.code)
    end
  end
end
