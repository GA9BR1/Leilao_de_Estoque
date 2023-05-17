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
            respond_to do |format|
              format.turbo_stream
              format.html { redirect_to @bid.batch }
            end
            return
          else
            flash[:notice] = 'O valor do lance inicial deve ser igual ou superior o valor do lance mínimo'
            if current_user.admin
              return redirect_to show_admin_batch_path(@bid.batch_id)
            else
              return redirect_to batch_path(@bid.batch_id)
            end
          end
        else
          if @bid.amount >= (@bid.batch.bids.maximum(:amount) + @bid.batch.minimum_bid_difference)
            @bid.save!
            flash.now[:alert] = 'Lance realizado com sucesso'
            respond_to do |format|
              format.turbo_stream
              if current_user.admin
                format.html { redirect_to @bid.batch }
                format.html { redirect_to show_admin_batch_path(@bid.batch_id) }
              else
                format.html { redirect_to @bid.batch }
              end
            end
            return
          else
            flash[:notice] = 'O valor do lance deve ser maior que o valor do ultimo lance + a diferença mínima entre lances'
            if current_user.admin
              return redirect_to show_admin_batch_path(@bid.batch_id)
            else
              return redirect_to batch_path(@bid.batch_id)
            end
          end
        end
      end
    end
    if current_user.admin
      redirect_to show_admin_batch_path(@bid.batch_id)
    else
      redirect_to batch_path(@bid.batch_id), notice: 'Não foi possível realizar o lance'
    end
  end

  def new
    @batch = Batch.find(params[:batch_id])
    @bid = @batch.bids.new
  end

  def bid_params
    params.require(:bid).permit(:amount, :batch_id)
  end
end