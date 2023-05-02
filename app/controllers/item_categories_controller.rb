class ItemCategoriesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @item_category = ItemCategory.new
    @item_categories = ItemCategory.all
  end

  def create
    params_item_category = params.require(:item_category).permit(:name)
    @item_category = ItemCategory.new(params_item_category)
    if @item_category.valid?
      @item_category.save!
      return redirect_to new_item_category_path, notice: 'Categoria cadastrada com sucesso'
    end
    @item_categories = ItemCategory.all
    flash.now[:notice] = 'Não foi possível cadastrar a categoria'
    render :new
  end

  def edit
    @item_category = ItemCategory.find(params[:id])
  end

  def update
    @item_category = ItemCategory.find(params[:id])

    return redirect_to new_item_category_path, notice: 'Categoria editada com sucesso' if @item_category.update(params.require(:item_category).permit(:name))

    flash.now[:notice] = 'Não foi possível editar a categoria'
    render :edit
  end

  def authenticate_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: 'Você não tem permissão para acessar essa página.'
    end
  end
  
end
