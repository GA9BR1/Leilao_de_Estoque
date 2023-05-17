class DoubtsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:not_answered, :set_answered, :set_visibility]

  def new
    @batch = Batch.find(params[:batch_id])
    @doubt = @batch.doubts.new
  end

  def create
    @doubt = Doubt.new(doubt_params)

    if current_user.id != @doubt.user_id
      respond_to do |format|
        format.turbo_stream
        format.html { render :error_page, status: :unprocessable_entity }
      end
      return
    end

    approved_by = @doubt.batch.approved_by
    start_date = @doubt.batch.start_date
    end_date = @doubt.batch.end_date
    bids_present = @doubt.batch.bids.present?
    maximum_bid_amount = @doubt.batch.bids.maximum(:amount)

    if (approved_by && Date.today < end_date && Date.today >= start_date) ||
       (approved_by && Date.today >= end_date && bids_present && @doubt.batch.bids.find_by(amount: maximum_bid_amount).user_id == current_user.id)
      if @doubt.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @doubt.batch }
        end
        return
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.append("error-messages-doubt", partial: "shared/error_messages", locals: { resource: @doubt }) }
          format.html { render :new, status: :unprocessable_entity }
        end
        return
      end
    end
    respond_to do |format|
      format.turbo_stream
      format.html { render :error_page, status: :unprocessable_entity }
    end
  end

  def not_answered
    @doubts = Doubt.all.where(answered: false)
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
    params.require(:doubt).permit(:content, :batch_id, :user_id)
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

  private 
  
  def authenticate_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: 'Você não tem permissão para acessar essa página.'
    end
  end
end