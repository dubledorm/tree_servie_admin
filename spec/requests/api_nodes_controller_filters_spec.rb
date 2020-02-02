require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/some_trees_with_nodes.rb'
require 'support/shared/many_nodes_with_parents.rb'
require 'support/shared/full_data_example.rb'


RSpec.describe Api::NodesController, type: :request do

  describe 'by_name' do
    include_context 'full data example'

    context 'when all nodes have same name' do
      before :each do
        Node.all.each do |node|
          node.name = 'Имя'
          node.save
        end
      end

      context 'when use index' do
        it 'should return 0 records' do
          get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, name: 'abrakadabra'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(0)
        end

        it 'should return records for tree1' do
          get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, name: 'Имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(5)
        end

        it 'should return records for tree2' do
          get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree2, name: 'Имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(1)
        end

        it 'should return records for tree3' do
          get(api_instance_tree_nodes_path(instance_id: instance2, tree_id: tree3, name: 'Имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(1)
        end

        it 'should return 0 records' do
          get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree3, name: 'Имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(0)
        end
      end

      context 'when use children' do

        it 'should return 0 records' do
          get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, name: 'abrakadabra'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(0)
        end

        it 'should return children for root tree1' do
          get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, name: 'Имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(3)
        end

        it 'should return only one child' do
          node13.name = 'Новое имя'
          node13.save
          get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, name: 'Новое имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(1)
          expect(JSON.parse(response.body)[0]['id']).to eq(node13.id)
        end
      end

      context 'when use all_children' do
        it 'should return 0 records' do
          get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, name: 'abrakadabra'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(0)
        end

        it 'should return children for root tree1' do
          get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, name: 'Имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(4)
        end

        it 'should return only one child' do
          node121.name = 'Новое имя'
          node121.save
          get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, name: 'Новое имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(1)
          expect(JSON.parse(response.body)[0]['id']).to eq(node121.id)
        end

        it 'should return children for node12' do
          get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node12.id, name: 'Имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(1)
          expect(JSON.parse(response.body)[0]['id']).to eq(node121.id)
        end
      end

      context 'when use path_to_root' do
        it 'should return empty path' do
          get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq([])
        end

        it 'should return two node' do
          get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121, name: 'Имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(2)
        end

        it 'should return one node' do
          node12.name = 'Новое имя'
          node12.save
          get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121, name: 'Новое имя'))
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).count).to eq(1)
          expect(JSON.parse(response.body)[0]['id']).to eq(node12.id)
        end
      end
    end
  end


  describe 'like_name' do
    include_context 'full data example'
    before :each do
      Node.all.each do |node|
        node.name = 'Имя этого узла'
        node.save
      end
    end

    context 'when use index' do
      it 'should return 0 records' do
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, like_name: 'abrakadabra'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'should return records for tree1' do
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, like_name: 'это'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(5)
      end

      it 'should return records for tree2' do
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree2, like_name: 'это'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end
    end

    context 'when use children' do
      it 'should return 0 records' do
        get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, like_name: 'abrakadabra'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'should return children for root tree1' do
        get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, like_name: 'узла'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(3)
      end

      it 'should return only one child' do
        node13.name = 'Новое имя'
        node13.save
        get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, like_name: 'Новое'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node13.id)
      end
    end

    context 'when use all_children' do
      it 'should return 0 records' do
        get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, like_name: 'abrakadabra'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'should return children for root tree1' do
        get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, like_name: 'Имя'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(4)
      end

      it 'should return only one child' do
        node121.name = 'Новое %имя'
        node121.save
        get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, like_name: '%имя'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node121.id)
      end

      it 'should return children for node12' do
        get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node12.id, like_name: 'Имя'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node121.id)
      end
    end

    context 'when use path_to_root' do
      it 'should return two node' do
        get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121, like_name: 'Имя'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(2)
      end

      it 'should return one node' do
        node12.name = 'Новое имя'
        node12.save
        get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121, like_name: 'имя'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node12.id)
      end
    end
  end

  describe 'by_state' do
    include_context 'full data example'

    context 'when use index' do
      it 'should return 0 records' do
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, state: 'deleted'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'should return records for tree1' do
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, state: 'active'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(5)
      end

      it 'should return records for tree2' do
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree2, state: 'active'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end

      it 'should return one record for tree1' do
        node12.state = 'deleted'
        node12.save
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, state: 'deleted'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node12.id)
      end
    end

    context 'when use children' do
      it 'should return 0 records' do
        get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, state: 'deleted'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'should return children for root tree1' do
        get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, state: 'active'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(3)
      end

      it 'should return only one child' do
        node13.state = 'deleted'
        node13.save
        get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, state: 'deleted'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node13.id)
      end
    end

    context 'when use all_children' do
      it 'should return 0 records' do
        get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, state: 'deleted'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'should return children for root tree1' do
        get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, state: 'active'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(4)
      end

      it 'should return only one child' do
        node121.state = 'deleted'
        node121.save
        get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, state: 'deleted'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node121.id)
      end
    end

    context 'when use path_to_root' do
      it 'should return two node' do
        get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121, state: 'active'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(2)
      end

      it 'should return one node' do
        node12.state = 'deleted'
        node12.save
        get(path_to_root_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node121, state: 'deleted'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(node12.id)
      end
    end
  end

  describe 'node_type, node_subtype' do
    include_context 'full data example'

    context 'when use index' do
      it 'should return one record for tree1' do
        node12.node_type = 'тип1'
        node12.node_subtype = 'подтип'
        node12.save

        node1.node_type = 'тип1'
        node1.save

        node121.node_type = 'тип2'
        node121.node_subtype = 'подтип'
        node121.save

        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, node_type: 'тип1', node_subtype: 'подтип'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end
    end

    context 'when use children' do
      it 'should return children for root tree1' do
        node12.node_type = 'тип1'
        node12.node_subtype = 'подтип'
        node12.save

        get(children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, node_type: 'тип1', node_subtype: 'подтип'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end
    end

    context 'when use all_children' do
      it 'should return children for root tree1' do
        node12.node_type = 'тип1'
        node12.node_subtype = 'подтип'
        node12.save

        node1.node_type = 'тип1'
        node1.save

        node121.node_type = 'тип2'
        node121.node_subtype = 'подтип'
        node121.save

        get(all_children_api_instance_tree_node_path(instance_id: instance1, tree_id: tree1, id: node1.id, node_type: 'тип1', node_subtype: 'подтип'))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end
    end
  end

  describe 'parent_id' do
    include_context 'full data example'

    context 'when use index' do
      it 'should return records for tree1' do
        get(api_instance_tree_nodes_path(instance_id: instance1, tree_id: tree1, parent_id: node12.id))
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
      end
    end
  end
end