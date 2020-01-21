class Api::BaseController < ActionController::API
  include BaseConcern

  rescue_from Exception, :with => :render_500
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from ActionController::ParameterMissing, :with => :render_400
#  rescue_from ActiveRecord::RecordInvalid, :with => :render_500


  # страница не найдена
  def render_404(e)
    Rails.logger.error(e.message)
    render json: { message: e.message }.to_json, status: :not_found
  end

  # ошибка в параметрах запроса
  def render_400(e)
    Rails.logger.error(e.message)
    render json: { message: e.message }.to_json, status: :bad_request
  end

  # внутрення ошибка сервера. не обработанная ошибка
  def render_500(e)
    Rails.logger.error(e.message)
    render json: { message: e.message }.to_json, status: :internal_server_error
  end
end