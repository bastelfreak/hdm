class ApplicationController < ActionController::Base
  rescue_from Hdm::Error, with: :display_error_page
  rescue_from CanCan::AccessDenied, with: :access_denied

  helper_method :current_user

  private

  def current_user
    if User.none?
      session[:user_id] = nil
    end

    if session[:user_id]
      Current.user ||= User.find(session[:user_id])
    end
  end

  def load_environments
    @environments = Environment.all
    @environment = Environment.find(params[:environment_id])
  end

  def display_error_page(error)
    @error = error
    render template: "page/error", status: :internal_server_error
  end

  def access_denied
    head :forbidden
  end
end
