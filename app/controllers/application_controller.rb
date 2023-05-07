class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :cpf])
  end

  def after_sign_in_path_for(resource)
    stored_location = stored_location_for(resource)
    if stored_location
      stored_location
    else
      root_path
    end
  end
end
