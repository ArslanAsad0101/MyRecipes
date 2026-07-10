class ApplicationController < ActionController::Base
  class AccessDenied < StandardError; end

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_chef, :chef_signed_in?

  rescue_from AccessDenied, with: :render_forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def current_chef
    @current_chef ||= begin
      if session[:chef_id]
        Chef.find_by(id: session[:chef_id])
      # elsif cookies.signed[:chef_id]
      #   Chef.find_by(id: cookies.signed[:chef_id])
      end
    end
  end

  def chef_signed_in?
    current_chef.present?
  end

  def require_chef!
    return if chef_signed_in?

    redirect_to chef_signup_path, alert: "Please sign up as a chef to manage recipes."
  end

  def render_forbidden(_exception = nil)
    respond_to do |format|
      format.html { render "errors/forbidden", status: :forbidden, layout: "application" }
      format.json { render json: { error: "You are not allowed to access this resource." }, status: :forbidden }
    end
  end

  def render_not_found(_exception = nil)
    respond_to do |format|
      format.html { render "errors/not_found", status: :not_found, layout: "application" }
      format.json { render json: { error: "The requested resource was not found." }, status: :not_found }
    end
  end
end
