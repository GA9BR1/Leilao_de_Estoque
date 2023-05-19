class UsersController < ApplicationController
  before_action :authenticate_admin!

  def profile
    @user = User.find(params[:id])
  end

  def block_and_unblock
    user = User.find(params[:id])

      if user.blocked_cpf_id.present?
    
        blocked_cpf = user.blocked_cpf
        user.blocked_cpf_id = nil
        user.save!
        blocked_cpf.destroy!

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("toggle-cpf-block",
                  partial: 'users/block_cpf_button',
                  locals: { id: user.id })
          end
          format.html { redirect_back(fallback_location: root_path) }
        end

      else
        blocked_cpf = BlockedCpf.create!(cpf: user.cpf)
        user.blocked_cpf_id = blocked_cpf.id
        user.save

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("toggle-cpf-block",
                  partial: 'users/unblock_cpf_button',
                  locals: { id: user.id })
          end
          format.html { redirect_back(fallback_location: root_path) }
        end
      end
  end

  def block_and_unblock_cpf_in_page
    user = User.find_by(cpf: params[:cpf])

    if user
      if user.blocked_cpf_id.present?
        blocked_cpf = user.blocked_cpf
        user.blocked_cpf_id = nil
        user.save
        blocked_cpf.destroy

        flash[:notice] = 'CPF desbloqueado com sucesso'
      else
        blocked_cpf = BlockedCpf.create!(cpf: user.cpf)
        user.blocked_cpf_id = blocked_cpf.id
        user.save

        flash[:notice] = 'CPF bloqueado com sucesso'
      end
    else
      if params[:cpf]
        if BlockedCpf.exists?(cpf: params[:cpf])
          blocked_cpf = BlockedCpf.find_by(cpf: params[:cpf])
          blocked_cpf.destroy
          flash[:notice] = 'CPF desbloqueado com sucesso'
        else
          blocked_cpf = BlockedCpf.new(cpf: params[:cpf])
          if blocked_cpf.valid?
            blocked_cpf.save
            flash[:notice] = 'CPF bloqueado com sucesso'
          else
            return redirect_to block_and_unblock_cpf_page_path, notice: 'CPF inválido'
          end
        end
      end
    end
    redirect_to block_and_unblock_cpf_page_path
  end 

  def block_and_unblock_page

  end

  private

  def authenticate_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: 'Você não tem permissão para acessar essa página.'
    end
  end
end