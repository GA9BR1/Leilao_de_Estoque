class UserFavoriteBatchesController < ApplicationController
  def index
    @user_favorite_batches = current_user.user_favorite_batches
  end

  def create
    favorited = UserFavoriteBatch.new(user_id: params[:user_id], batch_id: params[:batch_id])
    if current_user.id == favorited.user_id
      favorited.save!
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("toggle_favorite_button_#{favorited.batch_id}",
                partial: 'shared/unfavorite_button',
                locals: {id: favorited.id, batch_id: favorited.batch_id})
        end
        format.html { redirect_back(fallback_location: root_path) }
      end
    end 
  end

  def delete_favorited
    favorited = UserFavoriteBatch.find(params[:id])
    if current_user.id == favorited.user_id
      favorited.destroy!
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("toggle_favorite_button_#{favorited.batch_id}",
                partial: 'shared/favorite_button',
                locals: {id: favorited.id, user_id: current_user.id, batch_id: favorited.batch_id})
        end
        format.html { redirect_back(fallback_location: root_path) }
      end
    end
  end

end