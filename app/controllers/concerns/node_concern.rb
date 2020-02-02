module NodeConcern
  extend ActiveSupport::Concern

  def get_children
    find_resource_by_params_mask(['controller', 'action', 'instance_id', 'tree_id', 'id'])
    params.delete('id')
    @collection = apply_scopes(@resource.children)
  end

  def get_all_children
    find_resource_by_params_mask(['controller', 'action', 'instance_id', 'tree_id', 'id'])
    result_ids = Node::AllChildrenService.new(@resource).call

    params.delete('id')
    @collection = apply_scopes(Node).by_ids(result_ids)
  end
end