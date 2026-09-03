class Account::AccountLoginService < ApplicationService
  require 'json_web_token'
  def execute
    login
  end

  def login
    account = Account.find_by(username: @params[:username])
    unless account&.authenticate(@params[:password])
      fail!("Login Failed: Invalid username or password.")
    end

    token = JsonWebToken.encode(account_id: account.id)
    @result = { token: token, account: account }
  end
end