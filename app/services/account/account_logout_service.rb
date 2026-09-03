class Account::AccountLogoutService < ApplicationService
  def execute
    log_logout
  end

  def log_logout
    Rails.logger.info "Account #{Current.account.id} logged out"
    @result = { message: 'Logged out successfully.' }
  end
end