class Api::UserNodesController < Api::BaseController

  def create
    super do
      @resource = UserNode.new({ user_id: user_node_params.require(:user_id),
                                          node_id: user_node_params.require(:node_id) })
      @resource.save!
    end
  end


  private

  def user_node_params
    params.require(:user_node).permit(:user_id, :node_id)
  end
end
