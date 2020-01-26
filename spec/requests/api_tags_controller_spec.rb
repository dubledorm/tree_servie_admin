require 'rails_helper'
require 'support/shared/request_shared_examples'


RSpec.describe Api::TagsController, type: :request do

  describe 'show' do
    let!(:instance) { FactoryGirl.create(:instance) }
    let!(:tree) { FactoryGirl.create(:tree, instance: instance) }
    let!(:node) { FactoryGirl.create(:node, tree: tree) }
    let!(:tag) { FactoryGirl.create(:tag, node: node) }
    let!(:bad_instance) { FactoryGirl.create(:instance) }
    let!(:bad_tree) { FactoryGirl.create(:tree) }
    let!(:bad_node) { FactoryGirl.create(:node) }


    it 'should return record' do
      get(api_instance_tree_node_tag_path(instance_id: tag.instance.id, tree_id: tag.tree.id, node_id: tag.node_id, id: tag.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(tag.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_node_tag_path(instance_id: tag.instance.id, tree_id: tag.tree.id,
                                                    node_id: tag.node_id, id: tag.id + 1)) }
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_node_tag_path(instance_id: bad_instance.id, tree_id: tag.tree.id,
                                                    node_id: tag.node_id, id: tag.id)) }
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_node_tag_path(instance_id: tag.instance.id, tree_id: bad_tree.id,
                                                    node_id: tag.node_id, id: tag.id)) }
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_node_tag_path(instance_id: tag.instance.id, tree_id: tag.tree.id,
                                                    node_id: bad_node.id, id: tag.id)) }
    end

    it 'should find by name' do
      get(api_instance_tree_node_tag_path(instance_id: tag.instance.id, tree_id: tag.tree.id, node_id: tag.node_id, id: tag.name))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(tag.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_node_tag_path(instance_id: tag.instance.id, tree_id: tag.tree.id,
                                                    node_id: tag.node_id, id: tag.name + '123')) }
    end


    context 'when we have two nodess' do
      let!(:node1) { FactoryGirl.create(:node) }
      let!(:node2) { FactoryGirl.create(:node) }
      let!(:tag1) { FactoryGirl.create(:tag, node: node1, name: 'objects') }
      let!(:tag2) { FactoryGirl.create(:tag, node: node1, name: 'topology1') }
      let!(:tag3) { FactoryGirl.create(:tag, node: node2, name: 'objects') }

      it 'should find by name 1' do
        get(api_instance_tree_node_tag_path(instance_id: node1.instance.id, tree_id: node1.tree.id, node_id: node1.id, id: 'objects'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(tag1.id)
      end

      it 'should find by name 1' do
        get(api_instance_tree_node_tag_path(instance_id: node1.instance.id, tree_id: node1.tree.id, node_id: node1.id, id: 'topology1'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(tag2.id)
      end

      it 'should find by name 3' do
        get(api_instance_tree_node_tag_path(instance_id: node2.instance.id, tree_id: node2.tree.id, node_id: node2.id, id: 'objects'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(tag3.id)
      end

      it_should_behave_like 'get response 404' do
        subject { get(api_instance_tree_node_tag_path(instance_id: node2.instance.id, tree_id: node2.tree.id, node_id: node2.id, id: 'topology1')) }
      end
    end
  end


  describe 'index#' do
    let!(:node) { FactoryGirl.create(:node) }

    context 'when no records exist' do
      it 'should return empty array' do
        get(api_instance_tree_node_tags_path(instance_id: node.instance.id, tree_id: node.tree.id, node_id: node.id))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when records exist' do
      let!(:node1) { FactoryGirl.create(:node) }
      let!(:tag) { FactoryGirl.create(:tag, node: node) }
      let!(:tag1) { FactoryGirl.create(:tag, node: node) }
      let!(:tag2) { FactoryGirl.create(:tag, node: node1) }

      it 'if filter by node' do
        get(api_instance_tree_node_tags_path(instance_id: node.instance.id, tree_id: node.tree.id, node_id: node.id))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(2)
      end

      it 'if filter by node1' do
        get(api_instance_tree_node_tags_path(instance_id: node1.instance.id, tree_id: node1.tree.id, node_id: node1.id))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end

      it 'if filter by name' do
        get(api_instance_tree_node_tags_path(instance_id: node.instance.id, tree_id: node.tree.id, node_id: node.id,
                                             name: tag1.name))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        ap JSON.parse(response.body)
        expect(JSON.parse(response.body)[0]['id']).to eq(tag1.id)
      end
    end
  end

  describe 'create' do
    let!(:instance) { FactoryGirl.create(:instance) }
    let!(:tree) { FactoryGirl.create(:tree, instance_id: instance.id) }
    let!(:node) { FactoryGirl.create(:node, name: 'TestNode', tree_id: tree.id) }
    let(:tag) { FactoryGirl.build(:tag, name: 'TestTag', node_id: node.id) }


    context 'when parameters are good' do
      it 'should increase record counts' do
        expect{ post(api_instance_tree_node_tags_path( instance_id: instance, tree_id: tree.id, node_id: node.id),
                     params: { tag: tag.attributes } ) }.to change(Tag, :count).by(1)
      end

      it 'should return 200' do
        post(api_instance_tree_node_tags_path( instance_id: instance, tree_id: tree.id, node_id: node.id),
             params: { tag: tag.attributes } )
        expect(response).to have_http_status(201)
      end

      it 'should return object tree' do
        post(api_instance_tree_node_tags_path( instance_id: instance, tree_id: tree.id, node_id: node.id),
             params: { tag: tag.attributes } )
        expect(JSON.parse(response.body)['name']).to eq('TestTag')
      end
    end

    context 'when parameters are bad' do
      it_should_behave_like 'get response 400' do
        subject { post(api_instance_tree_node_tags_path( instance_id: instance, tree_id: tree.id, node_id: node.id)) }
      end

      it_should_behave_like 'get response 400' do
        subject { post(api_instance_tree_node_tags_path( instance_id: instance, tree_id: tree.id, node_id: node.id),
                       params: { } ) }
      end
    end

    context 'when double for name of tag' do
      let!(:another_tag) { FactoryGirl.create(:tag, node_id: node.id, name: 'test_12312') }

      it_should_behave_like 'get response 400' do

        subject { post(api_instance_tree_node_tags_path( instance_id: instance, tree_id: tree.id, node_id: node.id),
                       params: { tag: { name: 'test_12312' } } ) }
      end
    end
  end

  describe 'update#' do
    let!(:node) { FactoryGirl.create(:node) }
    let!(:tag) { FactoryGirl.create(:tag, node_id: node.id, name: 'test_12312') }
    let!(:tag1) { FactoryGirl.create(:tag, node_id: tag.node.id, name: 'the_name') }

    it 'should update record' do
      put(api_instance_tree_node_tag_path( instance_id: tag.instance, tree_id: tag.tree.id,
                                            node_id: tag.node.id, id: tag.id),
          params: { tag: { name: 'new_test_name' } } )
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['name']).to eq('new_test_name')
      tag.reload
      expect(tag.name).to eq('new_test_name')
    end

    it 'should not double name' do
      put(api_instance_tree_node_tag_path( instance_id: tag.instance, tree_id: tag.tree.id,
                                            node_id: tag.node.id, id: tag.id),
          params: { tag: { name: 'the_name' } } )
      expect(response).to have_http_status(400)
      ap JSON.parse(response.body)
      tag.reload
      expect(tag.name).to eq('test_12312')
    end
  end

  describe 'delete#' do
    let!(:tag) { FactoryGirl.create(:tag) }

    it 'should decrease record counts' do
      expect{ delete(api_instance_tree_node_tag_path( instance_id: tag.instance.id,
                                                      tree_id: tag.tree.id,
                                                      node_id: tag.node.id,
                                                      id: tag.id) ) }.to change(Tag, :count).by(-1)
    end

    it 'should return status 200' do
      delete(api_instance_tree_node_tag_path( instance_id: tag.instance.id,
                                              tree_id: tag.tree.id,
                                              node_id: tag.node.id,
                                              id: tag.id) )
      expect(response).to have_http_status(200)
    end
  end
end