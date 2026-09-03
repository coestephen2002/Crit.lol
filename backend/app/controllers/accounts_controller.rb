class AccountsController < ApplicationController
  skip_before_action :authenticate_request!, only: [:login, :create]

  def create
    respond_using_service(Account::AccountSignupService)
  end

  def login
    respond_using_service(Account::AccountLoginService)
  end

  def logout
    respond_using_service(Account::AccountLogoutService)
  end

  def show
    respond_using_service(Account::AccountShowService)
  end
end
