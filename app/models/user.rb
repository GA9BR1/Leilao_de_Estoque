class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_save :verificar_email_admin
  validates :name, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, cpf: { message: 'inválido' }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_favorite_batches
  has_many :batches, through: :user_favorite_batches
  has_many :bids
  has_many :doubts
  belongs_to :blocked_cpf, optional: true
  validate :cpf_not_blocked, on: :create

  def blocked_cpf?
    blocked_cpf_id.present?
  end

  private

  def verificar_email_admin
    self.admin = true if self.email.include?('@leilaodogalpao.com.br')
  end
  
  def cpf_not_blocked
    if BlockedCpf.exists?(cpf: cpf)
      errors.add(:cpf, "está bloqueado. Entre em contato com o suporte.")
    end
  end
end