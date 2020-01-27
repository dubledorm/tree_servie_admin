require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/full_data_example.rb'


RSpec.describe Api::NodesController, type: :request do
  include_context 'full data example'

  describe 'show#' do
    it 'should return record' do
      get(api_instance_tree_node_path(instance_id: instance1.id, tree_id: tree1.id, id: node11.id,
                                      user_id: user_mc_1.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(node11.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_node_path(instance_id: instance1.id, tree_id: tree1.id, id: node1.id,
                                                user_id: user_mc_2.id)) }
    end
  end
end