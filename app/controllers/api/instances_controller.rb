class Api::InstancesController < Api::BaseController

  def show
    find_resource
    render json: @resource
  end
end
