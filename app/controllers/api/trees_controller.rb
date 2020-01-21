class Api::TreesController < Api::BaseController
  has_scope :name_of_tree, as: :name
  has_scope :instance_id

  def show
    find_resource
    raise ActiveRecord::RecordNotFound,
          "Could not find instance with id = #{params[:instance_id]}" unless @resource.instance_id.to_s == params['instance_id']
    render json: @resource
  end

  def index
    get_collection
    render json: @collection
  end

  def create
    ActiveRecord::Base.transaction do
      @resource = Tree.new(tree_params.merge(instance_id: params.require(:instance_id)))
      @resource.save!
      user = User.new(name: 'admin',
                      tree_id: @resource.id,
                      ability: :all)
      user.save!
    end
    render json: @resource, status: :created
  end

  private

  def tree_params
    params.require(:tree).permit(:name, :description)
  end

end
