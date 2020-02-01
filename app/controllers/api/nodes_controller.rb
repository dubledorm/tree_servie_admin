class Api::NodesController < Api::BaseController
  has_scope :user_id
  has_scope :instance_id
  has_scope :tree_id
  has_scope :parent_id
  has_scope :node_type_value, as: :node_type
  has_scope :node_subtype_value, as: :node_subtype

  def create
    super do
      params[:node][:state] = 'active' unless params.require(:node)[:state].present?
      @resource = Node.new(node_params.merge(tree_id: params.require(:tree_id)))
      @resource.save!
    end
  end

  def update
    super do
      @resource.update!(node_params.merge(tree_id: params.require(:tree_id)))
    end
  end

  def children
    find_resource
    render json: @resource.children, status: 200
  end

  def root
    root_node = get_collection.roots.first
    # TODO здесь root_node может быть пустым. Например если пользователю не разрешена работа с этим узлом
    render json: root_node, status: 200
  end

  def path_to_root
    find_resource
    result_ids = Node::PathToRootService.new(@resource).call
    unsorted_result = apply_scopes(Node).by_ids(result_ids)
    result = Node::SortRootPathService.new(result_ids, unsorted_result).call
    render json: result, status: 200
  end

  def all_children
    find_resource
    result_ids = Node::AllChildrenService.new(@resource).call
    result = apply_scopes(Node).by_ids(result_ids)
    render json: result, status: 200
  end

  private

  def node_params
    params.require(:node).permit(:name, :description, :node_type, :node_subtype, :parent_id, :state)
  end
end
