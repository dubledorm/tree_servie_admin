require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/full_data_example'


RSpec.describe Api::UserNodesController, type: :request do

  describe 'create#' do
    include_context 'full data example'

    context 'when parameters are good' do
      it 'should increase record counts' do
        expect{ post(api_instance_tree_user_nodes_path( instance_id: instance1, tree_id: tree1 ),
                     params: { user_node: { user_id: user1.id,
                                            node_id: node1.id} }) }.to change(UserNode, :count).by(1)
      end

      it 'should return 201' do
        post(api_instance_tree_user_nodes_path( instance_id: instance1, tree_id: tree1 ),
             params: { user_node: { user_id: user1.id,
                                    node_id: node1.id} })
        expect(response).to have_http_status(201)
      end
    end

    context 'when parameters are bad' do
      it 'should return 400 if user and node have difference tree' do
        post(api_instance_tree_user_nodes_path( instance_id: instance1, tree_id: tree1 ),
             params: { user_node: { user_id: user2.id,
                                    node_id: node1.id} })
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'delete#' do
    include_context 'full data example'

    it 'should decrease records count' do
      expect{ delete(api_instance_tree_user_node_path( instance_id: instance1.id,
                                                  tree_id: tree1.id,
                                                  id: user_node1.id )) }.to change(UserNode, :count).by(-1)
    end

    it 'should return 400' do
      delete(api_instance_tree_user_node_path( instance_id: instance1.id, tree_id: tree1.id,
                                               id: user_node1.id + 10))
      expect(response).to have_http_status(404)
    end
  end
end