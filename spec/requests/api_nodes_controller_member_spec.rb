require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/many_nodes_with_parents'


RSpec.describe Api::NodesController, type: :request do
  describe 'children' do
    include_context 'many nodes with parents'

    it 'should return 3 children' do
      get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(3)
    end

    it 'should return 1 child' do
      get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node12.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(1)
    end

    it 'should return 0 children' do
      get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end

    it_should_behave_like 'get response 404' do
      subject { get(children_api_instance_tree_node_path(instance_id: instance2, tree_id: tree1, id: node121.id)) }
    end
  end
end