require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/many_nodes_with_parents'

RSpec.describe Node::PathToRootService do
  include_context 'many nodes with parents'

  it { expect(described_class.new(node1).call).to eq([]) } # от корня

  it { expect(described_class.new(node11).call).to eq([node1.id]) } # первый уровень от корня

  it { expect(described_class.new(node121).call).to eq([node12.id, node1.id]) } # второй уровень от корня
end