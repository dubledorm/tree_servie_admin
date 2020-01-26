require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/some_trees_with_nodes'


RSpec.describe Api::UsersController, type: :request do

  describe 'show#' do
    let!(:tree) { FactoryGirl.create(:tree) }
    let!(:user) { FactoryGirl.create(:user, tree: tree) }

    it 'should return record' do
      get(api_instance_tree_user_path(instance_id: user.instance, tree_id: tree.id, id: user.id))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(user.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_user_path(instance_id: user.instance, tree_id: tree.id, id: user.id + 1)) }
    end

    it 'should find by name' do
      get(api_instance_tree_user_path(instance_id: user.instance, tree_id: tree.id, id: user.name))
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['id']).to eq(user.id)
    end

    it_should_behave_like 'get response 404' do
      subject { get(api_instance_tree_user_path(instance_id: user.instance, tree_id: tree.id, id: user.name + '123')) }
    end


    context 'when we have two trees' do
      include_context 'some trees with nodes'

      it 'should find record' do
        get(api_instance_tree_user_path(instance_id: user1.instance, tree_id: tree1.id, id: user1.id))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(user1.id)
      end

      it_should_behave_like 'get response 404' do
        subject { get(api_instance_tree_user_path(instance_id: instance2, tree_id: tree1.id, id: user1.id)) }
      end

      it_should_behave_like 'get response 404' do
        subject { get(api_instance_tree_user_path(instance_id: instance1, tree_id: tree2.id, id: user1.id)) }
      end

      it_should_behave_like 'get response 404' do
        subject { get(api_instance_tree_user_path(instance_id: instance1, tree_id: tree1.id, id: user2.id)) }
      end
    end
  end


  describe 'create#' do
    let!(:instance) { FactoryGirl.create(:instance) }
    let!(:tree) { FactoryGirl.create(:tree, instance: instance) }
    let(:user) { FactoryGirl.build(:user, name: 'TestUser') }

    context 'when parameters are good' do
      it 'should increase record counts' do
        expect{ post(api_instance_tree_users_path( instance_id: instance, tree_id: tree ),
                     params: { user: user.attributes } ) }.to change(User, :count).by(1)
      end

      it 'should return 201' do
        post(api_instance_tree_users_path( instance_id: instance, tree_id: tree ), params: { user: user.attributes } )
        expect(response).to have_http_status(201)
      end

      it 'should return object user' do
        post(api_instance_tree_users_path( instance_id: instance, tree_id: tree ), params: { user: user.attributes } )
        expect(JSON.parse(response.body)['name']).to eq('TestUser')
      end

    end

    context 'when parameters are bad' do
      it_should_behave_like 'get response 400' do
        subject {  post(api_instance_tree_users_path( instance_id: instance, tree_id: tree ) ) }
      end

      it_should_behave_like 'get response 400' do
        subject {  post(api_instance_tree_users_path( instance_id: instance, tree_id: tree ), params: { user: { } } ) }
      end

      it_should_behave_like 'get response 400' do
        subject {  post(api_instance_tree_users_path( instance_id: instance, tree_id: tree ),
                        params: { user: { name: 'user_name',
                                          ability: 'abrakadabra' } } ) }
      end
    end
  end

  describe 'update#' do
    let!(:user) { FactoryGirl.create(:user, name: 'TestUser') }

    it 'should update record' do
      put(api_instance_tree_user_path( instance_id: user.instance.id, tree_id: user.tree.id, id: user.id ),
          params: { user: { name: 'New_name',
                            ability: 'read' } } )

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['name']).to eq('New_name')
      expect(JSON.parse(response.body)['ability']).to eq('read')
      user.reload
      expect(user.name).to eq('New_name')
      expect(user.ability).to eq('read')
    end
  end


  describe 'delete#' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'should decrease records count' do
      expect{ delete(api_instance_tree_user_path( instance_id: user.instance.id,
                                                  tree_id: user.tree.id,
                                                  id: user.id )) }.to change(User, :count).by(-1)
    end

    it 'should return status 200' do
      delete(api_instance_tree_user_path( instance_id: user.instance.id,
                                          tree_id: user.tree.id,
                                          id: user.id ))
      expect(response).to have_http_status(200)
    end


    context 'when exist some user_nodes' do
      let!(:user_node1) { FactoryGirl.create(:user_node, user: user) }
      let!(:user_node2) { FactoryGirl.create(:user_node, user: user) }

      it { expect(user.user_nodes.count).to eq(2) }

      it 'should decrease records count' do
        expect{ delete(api_instance_tree_user_path( instance_id: user.instance.id,
                                                    tree_id: user.tree.id,
                                                    id: user.id )) }.to change(User, :count).by(-1)
      end

      it 'should decrease tag records count' do
        expect{ delete(api_instance_tree_user_path( instance_id: user.instance.id,
                                                    tree_id: user.tree.id,
                                                    id: user.id )) }.to change(UserNode, :count).by(-2)
      end
    end
  end
end