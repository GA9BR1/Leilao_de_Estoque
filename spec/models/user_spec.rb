require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Verifica o CPF' do
    it 'falso se CPF inválido #1' do
      user = User.new(name: 'Gustavo Alberto', email: 'gustavoalberttodev@gmail.com', password: 'password', cpf: '00000000000')
      user.valid?
      expect(user.errors.count).to eq(1)
      expect(user.errors.full_messages[0]).to eq('CPF inválido')
    end
    it 'falso se CPF inválido #2' do
      user = User.new(name: 'Gustavo Alberto', email: 'gustavoalberttodev@gmail.com', password: 'password', cpf: '11111111111')
      user.valid?
      expect(user.errors.count).to eq(1)
      expect(user.errors.full_messages[0]).to eq('CPF inválido')
    end
    it 'falso se CPF inválido #3' do
      user = User.new(name: 'Gustavo Alberto', email: 'gustavoalberttodev@gmail.com', password: 'password', cpf: '32850562075')
      user.valid?
      expect(user.errors.count).to eq(1)
      expect(user.errors.full_messages[0]).to eq('CPF inválido')
    end
    it 'verdadeiro se CPF válido #1' do
      user = User.new(name: 'Gustavo Alberto', email: 'gustavoalberttodev@gmail.com', password: 'password', cpf: '32850562076')
      expect(user.valid?).to eq(true)
    end
    it 'verdadeiro se CPF válido #2' do
      user = User.new(name: 'Gustavo Alberto', email: 'gustavoalberttodev@gmail.com', password: 'password', cpf: '45144394019')
      expect(user.valid?).to eq(true)
    end
  end
end
