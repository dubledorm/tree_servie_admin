require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/some_trees_with_nodes.rb'
require 'support/shared/many_nodes_with_parents.rb'
require 'support/shared/full_data_example.rb'


RSpec.describe Api::NodesController, type: :request do

  describe 'show#' do
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

    context 'when we have two instances' do
      include_context 'some trees with nodes'

      it 'should find record' do
        get(api_instance_tree_node_path(instance_id: instance2, tree_id: tree3, id: node3.id))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(node3.id)
      end

      it_should_behave_like 'get response 404' do
        subject { get(api_instance_tree_node_path(instance_id: instance1, tree_id: tree3, id: node3.id)) }
      end

      it_should_behave_like 'get response 404' do
        subject { get(api_instance_tree_node_path(instance_id: instance2, tree_id: tree1, id: node3.id)) }
      end

      it_should_behave_like 'get response 404' do
        subject { get(api_instance_tree_node_path(instance_id: instance2, tree_id: tree2, id: node1.id)) }
      end
    end
  end


  describe 'index#' do
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


    context 'when we have two instances' do
      include_context 'some trees with nodes'
      let!(:instance_new) { FactoryGirl.create(:instance) }

      it 'if filter by tree' do
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree2))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node2.id)
      end

      it 'if filter by instance' do
        get(api_instance_tree_nodes_path(instance_id: instance_new, tree_id: tree2))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end
    end
  end

  describe 'count#' do
    let!(:instance) { FactoryGirl.create(:instance) }
    let!(:tree) { FactoryGirl.create(:tree, instance: instance) }


    context 'when no records exist' do
      it 'should return empty array' do
        get(count_api_instance_tree_nodes_path(instance_id: tree.instance, tree_id: tree.id))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(0)
      end
    end

    context 'when we have two instances' do
      include_context 'some trees with nodes'
      let!(:instance_new) { FactoryGirl.create(:instance) }

      it 'if filter by tree' do
        get(count_api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree2))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(1)
      end

      it 'if filter by instance' do
        get(count_api_instance_tree_nodes_path(instance_id: instance_new, tree_id: tree2))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(0)
      end
    end
  end

  describe 'create#' do
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
                     params: { node: { name: 'Name of node' } } ) }.to change(Node, :count).by(1)
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

    context 'when parameter state presents and his value is deleted' do
      it 'should return object tree' do
        post(api_instance_tree_nodes_path( instance_id: instance, tree_id: tree ),
             params: { node: { name: 'Name of node',
                               state: 'deleted' } } )
        expect(JSON.parse(response.body)['state']).to eq('deleted')
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


      it_should_behave_like 'get response 400' do
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

  describe 'update#' do
    include_context 'many nodes with parents'

    it 'should update record' do
      put(api_instance_tree_node_path( instance_id: node11.instance.id, tree_id: node11.tree.id, id: node11.id ),
           params: { node: { name: 'New name of node'} } )
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['name']).to eq('New name of node')
      node11.reload
      expect(node11.name).to eq('New name of node')
    end

    it 'should change parent node' do
      put(api_instance_tree_node_path( instance_id: node11.instance.id, tree_id: node11.tree.id, id: node11.id ),
          params: { node: { parent_id: node121.id} } )
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['parent_id']).to eq(node121.id)
      node11.reload
      expect(node11.parent_id).to eq(node121.id)
    end

    it 'should not to change tree' do
      put(api_instance_tree_node_path( instance_id: node11.instance.id, tree_id: node11.tree.id, id: node11.id ),
          params: { node: { parent_id: node2.id} } )
      expect(response).to have_http_status(400)
      node11.reload
      expect(node11.parent_id).to eq(node1.id)
    end
  end


  describe 'delete#' do
    let!(:node) { FactoryGirl.create(:node) }

    it 'should decrease records count' do
      expect{ delete(api_instance_tree_node_path( instance_id: node.instance.id,
                                                  tree_id: node.tree.id,
                                                  id: node.id )) }.to change(Node, :count).by(-1)
    end

    it 'should return status 200' do
      delete(api_instance_tree_node_path( instance_id: node.instance.id,
                                          tree_id: node.tree.id,
                                          id: node.id ))
      expect(response).to have_http_status(200)
    end


    context 'when exist some tags' do
      let!(:tag1) { FactoryGirl.create(:tag, node: node) }
      let!(:tag2) { FactoryGirl.create(:tag, node: node) }

      it { expect(node.tags.count).to eq(2) }

      it 'should decrease records count' do
        expect{ delete(api_instance_tree_node_path( instance_id: node.instance.id,
                                                    tree_id: node.tree.id,
                                                    id: node.id )) }.to change(Node, :count).by(-1)
      end

      it 'should decrease tag records count' do
        expect{ delete(api_instance_tree_node_path( instance_id: node.instance.id,
                                                    tree_id: node.tree.id,
                                                    id: node.id )) }.to change(Tag, :count).by(-2)
      end
    end

    context 'when exist children' do
      include_context 'full data example'

      it { expect(node1.children.count).to eq(3) }

      it 'should decrease records count' do
        expect{ delete(api_instance_tree_node_path( instance_id: node1.instance.id,
                                                    tree_id: node1.tree.id,
                                                    id: node1.id )) }.to change(Node, :count).by(-6)
      end

      it 'should decrease tag records count' do
        expect{ delete(api_instance_tree_node_path( instance_id: node1.instance.id,
                                                    tree_id: node1.tree.id,
                                                    id: node1.id )) }.to change(Tag, :count).by(-4)
      end
    end
  end
end