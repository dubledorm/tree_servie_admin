require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/many_nodes_with_parents'

RSpec.describe Node::SortRootPathService do
  include_context 'many nodes with parents'

  it { expect(described_class.new([],[]).call).to eq([]) }

  it { expect(described_class.new([node1.id],[node1]).call).to eq([node1]) }

  it { expect(described_class.new([node121.id, node3.id, node2.id, node1.id],
                                  [node1, node2, node3, node121]).call).to eq([node121, node3, node2, node1]) }

  it { expect(described_class.new([node121.id, node3.id, node2.id, node1.id],
                                  [node1, node3, node121]).call).to eq([node121, node3, node1]) }


end