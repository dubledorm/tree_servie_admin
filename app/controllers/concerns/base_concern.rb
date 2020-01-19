module BaseConcern
  extend ActiveSupport::Concern

  def find_resource
    resource_class = controller_name.classify
    @resource = resource_class.constantize.find(params[:id])
  end
end