class Api::BaseController < ActionController::API
  include BaseConcern

  rescue_from Exception, :with => :render_500
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from ActionController::ParameterMissing, :with => :render_400
  rescue_from ActionController::BadRequest, :with => :render_400

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

  def show
    find_resource
    render json: @resource
  end

  def index
    get_collection
    render json: @collection
  end

  def create
    begin
      yield
    rescue ActiveRecord::RecordInvalid => e
      raise ActionController::BadRequest, @resource.errors.full_messages
    end
    render json: @resource, status: :created
  end

  def update
    find_resource
    begin
      yield
    rescue ActiveRecord::RecordInvalid => e
      raise ActionController::BadRequest, @resource.errors.full_messages
    end
    render json: @resource, status: 200
  end
end