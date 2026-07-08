class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_chef, :chef_signed_in?

  private

  def current_chef
    @current_chef ||= Chef.find_by(id: session[:chef_id]) if session[:chef_id]
  end

  def chef_signed_in?
    current_chef.present?
  end

  def require_chef!
    return if chef_signed_in?

    redirect_to chef_signup_path, alert: "Please sign up as a chef to manage recipes."
  end
end
