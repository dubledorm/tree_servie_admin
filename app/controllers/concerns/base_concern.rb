module BaseConcern
  extend ActiveSupport::Concern

  def find_resource
    resource_class = controller_name.classify
    @resource = resource_class.constantize.find(params[:id])
  end

  def get_collection
    @collection = apply_scopes(controller_name.classify.constantize).all
  end
end