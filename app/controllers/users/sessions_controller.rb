# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200,
        message: 'Logged in successfully'
      },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }
  end
end
