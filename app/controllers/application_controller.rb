class ApplicationController < ActionController::API
  before_action :authenticate_request!

  def authenticate_request!
    token = request.headers['Authorization']&.split(' ')&.last
    payload = JsonWebToken.decode(token)
    account = Account.find_by(id: payload['account_id']) if payload

    if account
      Current.account = account
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def respond_using_service(service_class, **params)
    service = service_class.new(params, self)
    service.run!
    return respond_with(service.result) if service.success?

    respond_with(service.errors, status: 400, success: false)
  end

  def respond_with(data, status: 200, success: true)
    render json: {
      success: success,
      response: data,
      status: status
    }, status: status
  end
end
