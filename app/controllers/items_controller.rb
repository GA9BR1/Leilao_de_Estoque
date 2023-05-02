class ItemsController < ApplicationController
  require 'mini_magick'
  before_action :authenticate_admin!
  
  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.valid?
      resize_image(@item)
      @item.save
      return redirect_to items_path, notice: 'Item cadastrado com sucesso!'
    end
    flash.now[:notice] = 'Não foi possível cadastrar o item'
    render :new
  end

  def destroy
    item = Item.find(params[:id])
    return redirect_to items_path, notice: 'Item removido com sucesso!' if item.destroy

    render :index
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if !item_params.key?(:image) && @item.update(item_params)
      return redirect_to items_path, notice: 'Item atualizado com sucesso'
    else
      @item.assign_attributes(item_params)
      if @item.valid?
        @item.save
        resize_image(@item)
        return redirect_to items_path, notice: 'Item atualizado com sucesso'
      end
    end
    flash.now[:notice] = 'Não foi possível atualizar o item'
    render :edit
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :image, :width, :weight, :width, :height, :depth, :item_category_id)
  end

  def resize_image(_item)
    img = params[:item][:image]
    mini_image = MiniMagick::Image.open(img.tempfile.path).resize('300x250!')
    @item.image.attach(io: StringIO.new(mini_image.to_blob), filename: img.original_filename)
  end

  def authenticate_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: 'Você não tem permissão para acessar essa página.'
    end
  end
end
