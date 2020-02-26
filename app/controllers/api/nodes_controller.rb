class Api::NodesController < Api::BaseController
  include NodeConcern

  has_scope :user_id
  has_scope :instance_id
  has_scope :tree_id
  has_scope :parent_id
  has_scope :node_type_value, as: :node_type
  has_scope :node_subtype_value, as: :node_subtype
  has_scope :by_name, as: :name
  has_scope :like_name
  has_scope :by_state, as: :state
  has_scope :has_tag
  has_scope :has_string_tag, using: %i[tag_name tag_value], type: :hash
  has_scope :has_int_tag, using: %i[tag_name tag_value], type: :hash


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

  def root
    root_node = get_collection.roots.first
    # TODO здесь root_node может быть пустым. Например если пользователю не разрешена работа с этим узлом
    render json: root_node, status: 200
  end

  def path_to_root
    find_resource_by_params_mask(['controller', 'action', 'instance_id', 'tree_id', 'id'])
    result_ids = Node::PathToRootService.new(@resource).call
    params.delete('id')
    unsorted_result = apply_scopes(Node).by_ids(result_ids)
    result = Node::SortRootPathService.new(result_ids, unsorted_result).call
    render json: result, status: 200
  end

  def children
    get_children
    render json: @collection, status: 200
  end

  def all_children
    get_all_children
    render json: @collection, status: 200
  end

  def count
    get_collection
    render json: @collection.count
  end

  def count_children
    get_children
    render json: @collection.count
  end

  def count_all_children
    get_all_children
    render json: @collection.count
  end

  private

  def node_params
    params.require(:node).permit(:name, :description, :node_type, :node_subtype, :parent_id, :state)
  end
end
