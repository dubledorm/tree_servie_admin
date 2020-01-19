RSpec.shared_examples 'get response 404' do
  it 'response' do
    subject
    expect(response).to have_http_status(404)
    ap JSON.parse(response.body)['message']
  end
end

RSpec.shared_examples 'get response 400' do
  it 'response' do
    subject
    expect(response).to have_http_status(400)
    ap JSON.parse(response.body)['message']
  end
end

RSpec.shared_examples 'get response 500' do
  it 'response' do
    subject
    expect(response).to have_http_status(500)
    ap JSON.parse(response.body)['message']
  end
end