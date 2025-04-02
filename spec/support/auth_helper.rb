module AuthHelper
  def auth_headers(user)
    sign_in(user)
    { 'Authorization' => "Bearer #{user.jti}" }
  end
end
