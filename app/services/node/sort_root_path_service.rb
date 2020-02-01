class Node
  class SortRootPathService
    def initialize(ids, unsorted_nodes)
      @ids = ids
      @unsorted_nodes = unsorted_nodes
    end

    def call
      # отсортировать unsorted_nodes по id, в соответствии с ids. Удалить пустые элементы
      ids.map{ |id| unsorted_nodes.find_all{ |node| node.id == id }.first}.compact
    end

    private
    attr_accessor :ids, :unsorted_nodes

  end
end
