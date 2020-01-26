class Api::TagsController < Api::BaseController
  has_scope :instance_id
  has_scope :tree_id
  has_scope :node_id
  has_scope :by_name, as: :name

  def create
    super do
      @resource = Tag.new(tag_params.merge(node_id: params.require(:node_id)))
      @resource.save!
    end
  end

  def update
    super do
      @resource.update!(tag_params.merge(node_id: params.require(:node_id)))
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :value_type, :value_string, :value_int)
  end
end