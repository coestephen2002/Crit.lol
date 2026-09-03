class Account::AccountSignupService < ApplicationService
  require 'json_web_token'
  def execute
    create_account
  end

  def create_account
    account = Account.create!(
      username: @params[:username],
      password: @params[:password],
      status: 'active'
    )

    token = JsonWebToken.encode(account_id: account.id)
    @result = { token: token, account: account }
  end
end
