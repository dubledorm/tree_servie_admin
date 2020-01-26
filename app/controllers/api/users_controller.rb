class Api::UsersController < Api::BaseController
  has_scope :instance_id
  has_scope :tree_id
  has_scope :by_name, as: :name

  def create
    super do
      @resource = User.new(user_params.merge(tree_id: params.require(:tree_id)))
      @resource.save!
    end
  end

  def update
    super do
      @resource.update!(user_params.merge(tree_id: params.require(:tree_id)))
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :ability)
  end
end
