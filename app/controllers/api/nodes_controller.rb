class Api::NodesController < Api::BaseController
  has_scope :tree_id
  has_scope :parent_id

  def show
    find_resource
    render json: @resource
  end

  def index
    get_collection
    render json: @collection
  end

  def create
      @resource = Node.new(node_params.merge(tree_id: params.require(:tree_id)))
      @resource.save!
    render json: @resource, status: :created
  end

  private

  def node_params
    params.require(:node).permit(:name, :description, :node_type, :node_subtype, :parent_id, :tree_id)
  end
end
