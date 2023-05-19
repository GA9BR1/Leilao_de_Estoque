class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_with_blocked_cpf!, only: [:create]
  
  def create
    @bid = Bid.new(bid_params)

    if current_user.id != @bid.user_id
      respond_to do |format|
        format.turbo_stream
        format.html { render :error_page, status: :unprocessable_entity }
      end
      return
    end

    if @bid.valid?
      if @bid.batch.approved_by.present? && @bid.batch.start_date <= Date.today && @bid.batch.end_date > Date.today
        if @bid.batch.bids.empty?
          if @bid.amount >= @bid.batch.minimum_bid
            @bid.save!
            respond_to do |format|
              format.turbo_stream
              format.html { redirect_to @bid.batch }
            end
            return
          else
            respond_to do |format|
              format.turbo_stream do
                render turbo_stream: turbo_stream.replace('message-bid', partial: 'shared/message_bid',
                                    locals: { message: 'O valor do lance inicial deve ser igual ou superior o valor do lance mínimo' })
              end
              format.html { render :new, status: :unprocessable_entity }
            end
            return
          end
        else
          if @bid.amount >= (@bid.batch.bids.maximum(:amount) + @bid.batch.minimum_bid_difference)
            @bid.save!
            respond_to do |format|
              format.turbo_stream do
                render turbo_stream: turbo_stream.replace('message-bid',
                       partial:'shared/message_bid',
                       locals: { message: 'Lance realizado com sucesso' })

              end
              format.html { redirect_to @bid.batch }
            end
            return
          else
            respond_to do |format|
              format.turbo_stream do
                render turbo_stream: turbo_stream.replace('message-bid', partial: 'shared/message_bid',
                                    locals: { message: 'O valor do lance deve ser maior que o valor do ultimo lance + a diferença mínima entre lances' })
              end
              format.html { render :new, status: :unprocessable_entity }
            end
            return
          end
        end
      end
    end
    respond_to do |format|
      format.turbo_stream
      format.html { render :error_page, status: :unprocessable_entity }
    end
    return
  end

  def new
    @batch = Batch.find(params[:batch_id])
    @bid = @batch.bids.new
  end

  def bid_params
    params.require(:bid).permit(:amount, :batch_id, :user_id)
  end

  def authenticate_user_with_blocked_cpf!
    authenticate_user!

    if current_user.blocked_cpf_id.present?
      redirect_to root_path, alert: 'Sua conta está suspensa'
    end
  end
end