require 'rails_helper'
require 'support/shared/request_shared_examples'


RSpec.describe Api::NodesController, type: :request do

  context 'show' do
    let!(:tree) { FactoryGirl.create(:tree) }
    let!(:node) { FactoryGirl.create(:node, tree: tree) }

    it 'should return record' do
      get(api_instance_tree_node_path(instance_id: tree.instance, tree_id: tree.id, id: node.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(node.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_node_path(instance_id: tree.instance, tree_id: tree.id, id: node.id + 1)) }
    end
  end


  context 'index' do
    let!(:instance) { FactoryGirl.create(:instance) }
    let!(:tree) { FactoryGirl.create(:tree, instance: instance) }


    context 'when no records exist' do
      it 'should return empty array' do
        get(api_instance_tree_nodes_path(instance_id: tree.instance, tree_id: tree.id))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when records exist' do
      let!(:tree) { FactoryGirl.create(:tree, instance: instance) }
      let!(:tree1) { FactoryGirl.create(:tree, instance: instance) }
      let!(:node11) { FactoryGirl.create(:node, tree: tree,
                                         node_type: 'first_nt',
                                         node_subtype: 'first_nst1') }
      let!(:node21) { FactoryGirl.create(:node, tree: tree, parent: node11,
                                         node_type: 'first_nt',
                                         node_subtype: 'first_nst2') }
      let!(:node12) { FactoryGirl.create(:node, tree: tree1,
                                         node_type: 'first_nt',
                                         node_subtype: 'first_nst3') }



      it 'if filter by instance' do
        get(api_instance_tree_nodes_path(instance_id: instance, tree_id: tree))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(2)
      end

      it 'if filter by instance1' do
        get(api_instance_tree_nodes_path(instance_id: instance, tree_id: tree1))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end

      it 'if filter by parent' do
        get(api_instance_tree_nodes_path(instance_id: instance, tree_id: tree, parent_id: node11))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        ap JSON.parse(response.body)
        expect(JSON.parse(response.body)[0]['id']).to eq(node21.id)
      end

      it 'if filter by parent not found' do
        get(api_instance_tree_nodes_path(instance_id: instance, tree_id: tree, parent_id: node21))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
        ap JSON.parse(response.body)
        expect(JSON.parse(response.body)).to eq([])
      end


      it 'if filter by node_type and tree' do
        get(api_instance_tree_nodes_path(instance_id: instance, tree_id: tree, node_type: 'first_nt'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(2)
        ap JSON.parse(response.body)
      end

      it 'if filter by node_type and tree1' do
        get(api_instance_tree_nodes_path(instance_id: instance, tree_id: tree1, node_type: 'first_nt'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        ap JSON.parse(response.body)
      end

      it 'if filter by node_type and tree and node_subtype' do
        get(api_instance_tree_nodes_path(instance_id: instance, tree_id: tree, node_type: 'first_nt',
                                         node_subtype: 'first_nst1'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        ap JSON.parse(response.body)
        expect(JSON.parse(response.body)[0]['id']).to eq(node11.id)
      end
    end
  end

  context 'create' do
    let!(:instance) { FactoryGirl.create(:instance) }
    let!(:tree) { FactoryGirl.create(:tree, instance: instance) }
    let(:node) { FactoryGirl.build(:node, name: 'TestNode') }

    context 'when parameters are good' do
      it 'should increase record counts' do
        expect{ post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ),
                     params: { node: node.attributes } ) }.to change(Node, :count).by(1)
      end

      it 'should get only part of record' do
        expect{ post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ),
                     params: { node: { name: 'Name of node'} } ) }.to change(Node, :count).by(1)
      end

      it 'should return 201' do
        post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ), params: { node: node.attributes } )
        expect(response).to have_http_status(201)
      end

      it 'should return object tree' do
        post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ), params: { node: node.attributes } )
        expect(JSON.parse(response.body)['name']).to eq('TestNode')
      end

    end

    context 'when parameters are bad' do
      it_should_behave_like 'get response 400' do
        subject {  post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ) ) }
      end

      it_should_behave_like 'get response 400' do
        subject {  post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ), params: { node: { } } ) }
      end
    end

    context 'when bad parent_id' do
      let!(:tree1) { FactoryGirl.create(:tree, instance: instance) }
      let!(:node11) { FactoryGirl.create(:node, tree: tree) }
      let!(:node21) { FactoryGirl.create(:node, tree: tree, parent: node11) }
      let!(:node12) { FactoryGirl.create(:node, tree: tree1) }


      it_should_behave_like 'get response 500' do
        subject { post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ),
                       params: { node: { name: 'Name of node',
                                         parent_id: node12.id} } ) }
      end

      it 'should increase record count' do
        expect{ post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ),
                     params: { node: { name: 'Name of node',
                                       parent_id: node11.id} } ) }.to change(Node, :count).by(1)
      end
    end
  end
end