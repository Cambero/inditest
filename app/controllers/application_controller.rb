class ApplicationController < ActionController::API
  include Pundit::Authorization

  respond_to :json

  before_action :authenticate_user!

  def authenticate_user!
    super

    User.current_user = current_user if current_user
  end
end
