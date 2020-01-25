class Api::TagsController < Api::BaseController
  has_scope :instance_id
  has_scope :tree_id
  has_scope :node_id
  has_scope :by_name, as: :name

  def show
    find_resource
    render json: @resource
  end

  def index
    get_collection
    render json: @collection
  end

  def create
    @resource = Tag.new(tag_params.merge(node_id: params.require(:node_id)))
    begin
      @resource.save!
    rescue ActiveRecord::RecordInvalid => e
      raise ActionController::BadRequest, @resource.errors.full_messages
    end
    render json: @resource, status: :created
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :value_type, :value_string, :value_it)
  end
end