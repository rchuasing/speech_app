# frozen_string_literal: true

module AuthenticationHelpers
  def login
    current_user.create_new_auth_token
  end

  def do_login
    post user_session_path, params: { email: current_user.email, password: 'password4johndoe' }.to_json,
                            headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']
    authorization = response.headers['Authorization']

    {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token-type' => token_type,
      'Authorization' => authorization
    }
  end
end
