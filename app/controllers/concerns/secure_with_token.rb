module SecureWithToken
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # Just to illustrate token utilization. In real applications it would be stored hashed into Users table
  TOKENS = ['test', 'secret']

  private
    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        # In a real application it would be something like Users.find_by(:api_key, hash_function(SALT + token))
        TOKENS.include?(token)
      end
    end

end