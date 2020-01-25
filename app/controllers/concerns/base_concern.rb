module BaseConcern
  extend ActiveSupport::Concern

  def find_resource
    resource_class = controller_name.classify
    if params[:id].match(CommonConcern::REGEXP_FOR_NAME)
      @resource = apply_scopes(resource_class.constantize).all.by_name(params[:id]).first
    else
      @resource = apply_scopes(resource_class.constantize).all.where(id: params[:id]).first
    end
    raise ActiveRecord::RecordNotFound, "Could not find #{resource_class} with: #{params}" if @resource.nil?
  end

  def get_collection
    @collection = apply_scopes(controller_name.classify.constantize).all
  end
end