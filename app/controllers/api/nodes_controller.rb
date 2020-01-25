class Api::NodesController < Api::BaseController
  has_scope :instance_id
  has_scope :tree_id
  has_scope :parent_id
  has_scope :node_type_value, as: :node_type
  has_scope :node_subtype_value, as: :node_subtype

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

  def children
    find_resource
    render json: @resource.childrens
  end

  private

  def node_params
    params.require(:node).permit(:name, :description, :node_type, :node_subtype, :parent_id, :tree_id)
  end
end
