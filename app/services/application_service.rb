class ApplicationService < ApplicationController
  attr_reader :result, :errors, :params, :controller

  def initialize(params, controller)
    @params = params
    @controller = controller
  end

  def run!
    setup
    catch(:failed) { execute }
  end

  def run_and_return_result
    run!
    result
  end

  def success?
    @errors.blank?
  end

  def failure?
    !success?
  end

  protected

  def setup
    @params = controller.params.merge(params)
  end

  def fail!(message = nil, errors = {})
    @errors = { error: message }.merge(errors)
    throw :failed
  end
end