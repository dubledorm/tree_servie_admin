require 'rails_helper'
require 'support/shared/request_shared_examples'


RSpec.describe Api::InstancesController, type: :request do
  let!(:instance) { FactoryGirl.create(:instance) }

  it 'should return record' do
    get(api_instance_path(id: instance.id))
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)['id']).to eq(instance.id)
  end

  it_should_behave_like 'get response 404' do
    subject { get(api_instance_path(id: instance.id + 1)) }
  end
end