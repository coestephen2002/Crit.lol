class Account::AccountShowService < ApplicationService
  def execute
    account_info
  end

  def account_info
    account = Account.find(@params[:account_id])
    @result = { account: account.slice(:id, :username, :status, :created_at) }
  end
end
