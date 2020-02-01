class Node
  class PathToRootService
    def initialize(node)
      @node = node
    end

    def call
      result = []
      current_node = @node
      until current_node.parent.nil? do
        result << current_node.parent_id
        current_node = current_node.parent
      end
      result
    end

    private
    attr_accessor :node

  end
end
