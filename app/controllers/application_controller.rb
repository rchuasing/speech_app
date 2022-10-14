# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  respond_to :json

  rescue_from ActiveRecord::RecordInvalid, with: :render_validation_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def render_validation_error(exception)
    render json: { error: exception.message, status: false }, status: 422
  end

  def render_record_not_found(exception)
    render json: { error: exception.message, status: false }, status: 404
  end
end
