class Api::TreesController < Api::BaseController
  has_scope :by_name, as: :name
  has_scope :instance_id

  def show
    find_resource
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
