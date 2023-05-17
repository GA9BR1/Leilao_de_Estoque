class DoubtsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:not_answered, :set_answered, :set_visibility]

  def new
    @batch = Batch.find(params[:batch_id])
    @doubt = @batch.doubts.new
  end

  def create
    @doubt = Doubt.new(doubt_params)
    @doubt.user = current_user
    
    if @doubt.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @doubt.batch }
      end
      return
    end
    if current_user.admin
      redirect_to show_admin_batch_path(@doubt.batch.id), notice: 'A dúvida deve ter um conteúdo'
    else
      redirect_to batch_path(@doubt.batch.id), notice: 'A dúvida deve ter um conteúdo'
    end
  end

  def not_answered
    @doubts = Doubt.all.where(answered: false)
  end

  def set_answered
    doubt = Doubt.find(params[:id])
    if doubt.answered == true
      doubt.answered = false
    else
      doubt.answered = true
    end
    doubt.save!
  end

  def set_visiblity
    doubt = Doubt.find(params[:id])
    if doubt.visible == true
      doubt.visible = false
    else
      doubt.visible = true
    end
    doubt.save!
  end

  def name_ocult
    @doubt = Doubt.find(params[:id])
  end

  def name_not_ocult
    @doubt = Doubt.find(params[:id])
  end
  
  def answered_checked
    @id = params[:id]
  end

  def answered_unchecked
    @id = params[:id]
  end

  def visible
    @id = params[:id]
  end

  def not_visible
    @id = params[:id]
  end
  

  def doubt_params
    params.require(:doubt).permit(:content, :batch_id)
  end

  def authenticate_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: 'Você não tem permissão para acessar essa página.'
    end
  end
end