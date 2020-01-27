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

  describe 'root#' do
    include_context 'many nodes with parents'

    it 'should return root for 1 tree' do
      get(root_api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(node1.id)
    end

    it 'should return root for 2 tree' do
      get(root_api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree2))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(node2.id)
    end

    it 'should return root for tree of another instance' do
      get(root_api_instance_tree_nodes_path(instance_id: instance2, tree_id: tree3))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(node3.id)
    end
  end

  describe 'path_to_root#' do
    include_context 'many nodes with parents'

    it 'should return empty path' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([])
    end

    it 'should return one node' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node12))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(1)
    end

    it 'should return node1' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node12))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)[0]['id']).to eq(node1.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(path_to_root_api_instance_tree_node_path(instance_id: instance2, tree_id: tree1, id: node12)) }
    end

    it 'should return two node' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(2)
    end

    it 'should return node12, node1' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)[0]['id']).to eq(node12.id)
      expect(JSON.parse(response.body)[1]['id']).to eq(node1.id)
    end

  end
end