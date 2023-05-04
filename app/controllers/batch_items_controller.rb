class BatchItemsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_if_batch_valid

  def create
    batch_id = params[:batch_item][:batch_id]
    item_ids = params[:batch_item][:item_ids]

    objects = []
    item_ids.delete_at(0)

    if item_ids.empty? || batch_id.nil?
      return redirect_to batch_path(batch_id), notice: 'Não foi possível adicionar o item'
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
      return redirect_to batch_path(batch_id)
    end
    redirect_to batch_path(batch_id), notice: 'Não foi possível adicionar o item'
  end

  def delete_many
    batch_id = params[:batch_item][:batch_id]
    batch_ids = params[:batch_item][:ids]
    batch_ids.delete_at(0)
    if batch_ids.empty?
      return redirect_to batch_path(batch_id), notice: 'Não foi possível remover o item'
    end

    if BatchItem.where(id: batch_ids).destroy_all
      if batch_ids.length > 1
        flash.notice = 'Itens removidos com sucesso'
      else
        flash.notice = 'Item removido com sucesso'
      end
      return redirect_to batch_path(batch_id)
    end

    redirect_to batch_path(batch_id), notice: 'Não foi possivel remover o item'
  end

  private

  def batch_items_params
    params.require(:batch_item).permit(:batch_id, item_ids: [], ids: [])
  end

  def check_if_batch_valid
    batch_id = params[:batch_item][:batch_id]
    if Batch.find(batch_id).approved_by.present?
      return redirect_to batch_path(batch_id), notice: 'Não é possível mais adicionar ou remover itens, pois o lote já foi aprovado'
    end
  end

  def authenticate_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: 'Você não tem permissão para acessar essa página.'
    end
  end
end