class BlockedCpf < ApplicationRecord
  validates :cpf, uniqueness: true
  validates :cpf, cpf: { message: 'inválido' }
  validates :cpf, presence: true
end