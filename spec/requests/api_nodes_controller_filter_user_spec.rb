require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/some_trees_with_nodes.rb'
require 'support/shared/many_nodes_with_parents.rb'
require 'support/shared/full_data_example.rb'


RSpec.describe Api::NodesController, type: :request do
  include_context 'full data example'

  describe 'index#' do
    it 'should return 0 records' do
      get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, user_id: user_mc_3.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end

    it 'should return 5 records' do
      get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, user_id: user_admin.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(5)
    end

    it 'should return 2 records' do
      get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, user_id: user_mc_1.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(2)
    end

    it 'should return 0 records' do
      get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree2, user_id: user_mc_1.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end

    it 'should return 0 records' do
      get(api_instance_tree_nodes_path(instance_id: instance2, tree_id: tree1, user_id: user_mc_1.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end
  end

  context 'when use count' do
    it 'should return 0 records' do
      get(count_api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, user_id: user_mc_3.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(0)
    end

    it 'should return records for tree1' do
      get(count_api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, user_id: user_admin.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(5)
    end
  end

  describe 'children#' do
    it 'should return 0 records' do
      get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, user_id: user_mc_3.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end

    it 'should return children for root tree1' do
      get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, user_id: user_admin.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(3)
    end

    it 'should return children for root tree1' do
      get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, user_id: user_mc_2.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(1)
    end

    it 'should return children for root tree1' do
      get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, user_id: user_mc_1.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(2)
    end
  end

  describe 'all_children#' do
    it 'should return 0 records' do
      get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, user_id: user_mc_3.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end

    it 'should return children for root tree1' do
      get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, user_id: user_admin.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(4)
    end

    it 'should return children for root tree1' do
      get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, user_id: user_mc_2.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(2)
    end

    it 'should return children for root tree1' do
      get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, user_id: user_mc_1.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(2)
    end
  end

  context 'when use path_to_root' do
    it 'should return empty path' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1, user_id: user_mc_3.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([])
    end

    it 'should return two node' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121, user_id: user_admin.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(2)
    end

    it 'should return one node' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1211, user_id: user_mc_2.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(1)
      expect(JSON.parse(response.body)[0]['id']).to eq(node121.id)
    end

    it 'should return one node' do
      get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1211, user_id: user_mc_1.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(1)
      expect(JSON.parse(response.body)[0]['id']).to eq(node12.id)
    end
  end
end