class BatchItemsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_if_batch_valid
  before_action :check_if_items_not_being_used, only: [:create]

  def create
    batch_id = params[:batch_item][:batch_id]
    item_ids = params[:batch_item][:item_ids]

    objects = []
    item_ids.delete_at(0)

    if item_ids.empty? || batch_id.nil?
      return redirect_to show_admin_batch_path(batch_id), notice: 'Não foi possível adicionar o item'
    end

    item_ids.each do |itd|
      objects << BatchItem.new(batch_id: batch_id, item_id: itd)
    end

    if objects.all?(&:valid?)
      objects.each(&:save)
      if objects.count > 1
        flash.notice = 'Itens adicionados com sucesso'
      else
        flash.notice = 'Item adicionado com sucesso'
      end
      return redirect_to show_admin_batch_path(batch_id)
    end
    redirect_to show_admin_batch_path(batch_id), notice: 'Não foi possível adicionar o item'
  end

  def delete_many
    batch_id = params[:batch_item][:batch_id]
    item_ids = params[:batch_item][:ids]
    item_ids.delete_at(0)
    if item_ids.empty?
      return redirect_to show_admin_batch_path(batch_id), notice: 'Não foi possível remover o item'
    end

    if BatchItem.where(id: item_ids).destroy_all
      if item_ids.length > 1
        flash.notice = 'Itens removidos com sucesso'
      else
        flash.notice = 'Item removido com sucesso'
      end
      return redirect_to show_admin_batch_path(batch_id)
    end

    redirect_to show_admin_batch_path(batch_id), notice: 'Não foi possivel remover o item'
  end

  private

  def check_if_items_not_being_used
    item_ids = params[:batch_item][:item_ids].map(&:to_i)
    item_ids.delete_at(0)
    
    available_item_ids = Item.where.not(id: BatchItem.select(:item_id))
                             .or(Item.where(id: BatchItem.joins(:batch)
                             .where(batches: { end_status: :canceled })
                             .where.not(item_id: BatchItem.joins(:batch)
                             .where.not(batches: { end_status: :canceled })
                             .select(:item_id))))
                             .pluck(:id)

    if item_ids.any? { |item_id| !available_item_ids.include?(item_id) }
      return redirect_to show_admin_batch_path(params[:batch_item][:batch_id]), notice: 'Um ou mais itens que você tentou adicionar não estão disponíveis'
    end
  end
  
  def batch_items_params
    params.require(:batch_item).permit(:batch_id, item_ids: [], ids: [])
  end

  def check_if_batch_valid
    batch_id = params[:batch_item][:batch_id]
    if batch_id.empty?
      return redirect_to show_admin_batch_path(batch_id), notice: 'Id do lote ausente'
    end
    if Batch.find(batch_id).approved_by.present?
      return redirect_to show_admin_batch_path(batch_id), notice: 'Não é possível mais adicionar ou remover itens, pois o lote já foi aprovado'
    end
  end

  def authenticate_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: 'Você não tem permissão para acessar essa página.'
    end
  end
end