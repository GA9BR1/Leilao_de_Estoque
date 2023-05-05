class BidsController < ApplicationController
  before_action :authenticate_user!
  def create
    @bid = Bid.new(bid_params)
    @bid.user_id = current_user.id
    if @bid.valid?
      if @bid.batch.approved_by.present? && @bid.batch.start_date <= Date.today && @bid.batch.end_date > Date.today
        if @bid.batch.bids.empty?
          if @bid.amount >= @bid.batch.minimum_bid 
            @bid.save!
            return redirect_to batch_path(@bid.batch_id), notice: 'Lance realizado com sucesso'
          else
            flash[:notice] = 'O valor do lance inicial deve ser igual ou superior o valor do lance mínimo'
            redirect_to batch_path(@bid.batch_id)
          end
        else
          if @bid.amount >= (@bid.batch.bids.maximum(:amount) + @bid.batch.minimum_bid_difference)
            @bid.save!
            return redirect_to batch_path(@bid.batch_id), notice: 'Lance realizado com sucesso'
          else
            flash[:notice] = 'O valor do lance deve ser maior que o valor do ultimo lance + a diferença mínima entre lances'
            return redirect_to batch_path(@bid.batch_id)
          end
        end
      end
    end
    return redirect_to batch_path(@bid.batch_id), notice: 'Não foi possível realizar o lance'
  end

  def new
    @bid = Bid.new
    @batch_id = params[:batch_id]
  end

  def bid_params
    params.require(:bid).permit(:amount, :batch_id)
  end
end