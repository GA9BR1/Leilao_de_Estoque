class BatchesController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :approve, :index]
  def index
    @batches = Batch.all
  end

  def show
    unless current_user
      store_location_for(:user, batch_path(params[:id]))
    end

    @batch_item = BatchItem.new
    @batch = Batch.find(params[:id])
    @batch_items = BatchItem.where(batch_id: @batch.id)
    @items_without_batch = Item.where.not(id: BatchItem.select(:item_id))
  end

  def new
    @batch = Batch.new
  end

  def create
    @batch = Batch.new(batch_params)
    @batch.created_by = current_user
    if @batch.save
      return redirect_to batch_path(@batch.id), notice: 'Lote cadastrado com sucesso.'
    end
    flash.now[:notice] = 'Não foi possível cadastrar o lote'
    render :new
  end

  def approve
    id = params[:id]
    batch = Batch.find(id)
    if current_user != batch.created_by
      if batch.batch_items.count.zero?
        return redirect_to batch_path(batch.id), notice: 'Você não pode aprovar um lote sem itens'
      end
      batch.approved_by = current_user
      batch.save
      return redirect_to batch_path(batch.id), notice: 'Lote aprovado com sucesso'
    end
    redirect_to batch_path(batch.id), notice: 'Você mesmo não pode aprovar o lote'
  end

  def in_progress
    @batches = Batch.where('start_date <= ? AND end_date > ? AND approved_by_id IS NOT NULL', Date.today, Date.today)
    render partial: 'batches/in_progress', locals: { batches: @batches }
  end

  def future
    @batches = Batch.where('start_date > ? AND approved_by_id IS NOT NULL', Date.today)
    render partial: 'batches/future', locals: { batches: @batches }
  end

  private 

  def batch_params
    params.require(:batch).permit(:start_date, :end_date, :minimum_bid_difference, :minimum_bid)
  end

  def authenticate_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: 'Você não tem permissão para acessar essa página.'
    end
  end
end