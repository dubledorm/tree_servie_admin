require 'rails_helper'
require 'support/shared/request_shared_examples'
require 'support/shared/many_nodes_with_parents'

RSpec.describe Node::AllChildrenService do
  include_context 'many nodes with parents'

  it { expect(described_class.new(node1).call.count).to eq(4) } # от корня

  it { expect(described_class.new(node12).call).to eq([node121.id]) } # первый уровень от конца

  it { expect(described_class.new(node121).call).to eq([]) } # лист

end