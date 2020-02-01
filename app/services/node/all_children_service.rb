class Node
  class AllChildrenService
    def initialize(node)
      @node = node
    end

    def call
      sql = "(WITH RECURSIVE object AS (select id FROM nodes WHERE parent_id=#{node.id} " +
          'UNION select c.id FROM nodes c JOIN object ON c.parent_id=object.id) ' +
          'SELECT object.id FROM object);'
      ActiveRecord::Base.connection.execute(sql).map{ |child_id| child_id['id']}
    end

    private
    attr_accessor :node

  end
end
