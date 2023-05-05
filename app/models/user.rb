class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_save :verificar_email_admin
  validates :name, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, cpf: { message: 'inválido' }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bids
  private

  def verificar_email_admin
    self.admin = true if self.email.include?('@leilaodogalpao.com.br')
  end

end