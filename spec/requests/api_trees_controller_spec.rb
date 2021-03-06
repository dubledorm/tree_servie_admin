require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/full_data_example.rb'


RSpec.describe Api::TreesController, type: :request do

  describe 'show#' do
    let!(:tree) { FactoryGirl.create(:tree) }
    let!(:bad_instance) { FactoryGirl.create(:instance) }

    it 'should return record' do
      get(api_instance_tree_path(instance_id: tree.instance, id: tree.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(tree.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_path(instance_id: tree.instance, id: tree.id + 1)) }
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_path(instance_id: bad_instance, id: tree.id)) }
    end

    it 'should find by name' do
      get(api_instance_tree_path(instance_id: tree.instance, id: tree.name))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(tree.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_path(instance_id: tree.instance, id: tree.name + '123')) }
    end


    context 'when we have two instances' do
      let!(:instance1) { FactoryGirl.create(:instance) }
      let!(:instance2) { FactoryGirl.create(:instance) }
      let!(:tree1) { FactoryGirl.create(:tree, instance: instance1, name: 'objects') }
      let!(:tree2) { FactoryGirl.create(:tree,  instance: instance1, name: 'topology1') }
      let!(:tree3) { FactoryGirl.create(:tree, instance: instance2, name: 'objects') }

      it 'should find by name 1' do
        get(api_instance_tree_path(instance_id: instance1, id: 'objects'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(tree1.id)
      end

      it 'should find by name 1' do
        get(api_instance_tree_path(instance_id: instance1, id: 'topology1'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(tree2.id)
      end

      it 'should find by name 3' do
        get(api_instance_tree_path(instance_id: instance2, id: 'objects'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(tree3.id)
      end

      it_should_behave_like 'get response 404' do
        subject { get(api_instance_tree_path(instance_id: instance2, id: 'topology1')) }
      end
    end
  end


  describe 'index#' do
    let!(:instance) { FactoryGirl.create(:instance) }

    context 'when no records exist' do
      it 'should return empty array' do
        get(api_instance_trees_path(instance_id: instance))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when records exist' do
      let!(:instance1) { FactoryGirl.create(:instance) }
      let!(:tree) { FactoryGirl.create(:tree, instance: instance) }
      let!(:tree1) { FactoryGirl.create(:tree, instance: instance) }
      let!(:tree2) { FactoryGirl.create(:tree, instance: instance1) }

      it 'if filter by instance' do
        get(api_instance_trees_path(instance_id: instance))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(2)
      end

      it 'if filter by instance1' do
        get(api_instance_trees_path(instance_id: instance1))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end

      it 'if filter by name' do
        get(api_instance_trees_path(instance_id: instance, name: tree1.name))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        ap JSON.parse(response.body)
        expect(JSON.parse(response.body)[0]['id']).to eq(tree1.id)
      end
    end
  end

  describe 'create#' do
    let!(:instance) { FactoryGirl.create(:instance) }
    let(:tree) { FactoryGirl.build(:tree, name: 'TestTree', instance_id: instance) }

    context 'when parameters are good' do
      it 'should increase record counts' do
        expect{ post(api_instance_trees_path( instance_id: instance ), params: { tree: tree.attributes } ) }.to change(Tree, :count).by(1)
      end

      it 'should return 200' do
        post(api_instance_trees_path( instance_id: instance ), params: { tree: tree.attributes } )
        expect(response).to have_http_status(201)
      end

      it 'should return object tree' do
        post(api_instance_trees_path( instance_id: instance ), params: { tree: tree.attributes } )
        expect(JSON.parse(response.body)['name']).to eq('TestTree')
      end

      it 'should create user admin for this tree' do
        expect{ post(api_instance_trees_path( instance_id: instance ), params: { tree: tree.attributes } ) }.to change(User, :count).by(1)
      end
    end

    context 'when parameters are bad' do
      it_should_behave_like 'get response 400' do
        subject { post(api_instance_trees_path( instance_id: instance )) }
      end

      it_should_behave_like 'get response 400' do
        subject { post(api_instance_trees_path( instance_id: instance ), params: { tree: { } }) }
      end
    end

    context 'when double for name of tree' do
      let!(:another_tree) { FactoryGirl.create(:tree, instance: instance, name: 'test_12312') }

      it_should_behave_like 'get response 400' do
        subject { post(api_instance_trees_path( instance_id: instance ), params: { tree: { name: 'test_12312' } } ) }
      end
    end
  end

  describe 'update#' do
    let!(:tree) { FactoryGirl.create(:tree, name: 'test_12312') }
    let!(:tree1) { FactoryGirl.create(:tree, instance_id: tree.instance_id, name: 'the_name') }

    it 'should update record' do
      put(api_instance_tree_path( instance_id: tree.instance_id, id: tree.id ),
          params: { tree: { name: 'new_test_name' } } )
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['name']).to eq('new_test_name')
      tree.reload
      expect(tree.name).to eq('new_test_name')
    end

    it 'should not double name' do
      put(api_instance_tree_path( instance_id: tree.instance_id, id: tree.id ),
          params: { tree: { name: 'the_name' } } )
      expect(response).to have_http_status(400)
      ap JSON.parse(response.body)
      tree.reload
      expect(tree.name).to eq('test_12312')
    end
  end

  describe 'delete#' do
    let!(:tree) { FactoryGirl.create(:tree) }

    it 'should decrease records count' do
      expect{ delete(api_instance_tree_path( instance_id: tree.instance_id,
                                             id: tree.id )) }.to change(Tree, :count).by(-1)
    end

    it 'should return status 200' do
      delete(api_instance_tree_path( instance_id: tree.instance_id,
                                     id: tree.id ))
      expect(response).to have_http_status(200)
    end


    context 'when exist some nodes' do
      include_context 'full data example'

      it { expect(tree3.nodes.count).to eq(1) }

      it 'should decrease records count' do
        expect{ delete(api_instance_tree_path( instance_id: tree3.instance_id,
                                               id: tree3.id )) }.to change(Tree, :count).by(-1)
      end

      it 'should decrease nodes records count' do
        expect{ delete(api_instance_tree_path( instance_id: tree3.instance_id,
                                               id: tree3.id )) }.to change(Node, :count).by(-1)
      end
    end

    context 'when exist nodes and tags' do
      include_context 'full data example'

      it 'should decrease records count' do
        expect{ delete(api_instance_tree_path( instance_id: tree1.instance_id,
                                               id: tree1.id )) }.to change(Tree, :count).by(-1)
      end

      it 'should decrease nodes records count' do
        expect{ delete(api_instance_tree_path( instance_id: tree1.instance_id,
                                               id: tree1.id )) }.to change(Node, :count).by(-6)
      end

      it 'should decrease tag records count' do
        expect{ delete(api_instance_tree_path( instance_id: tree1.instance_id,
                                               id: tree1.id )) }.to change(Tag, :count).by(-4)
      end
    end
  end
end