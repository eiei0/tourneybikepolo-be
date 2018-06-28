module ApiHelpers
  def json_response
    JSON.parse(response.body)
  end

  def json_response_struct
    JSON.parse(response.body, object_class: OpenStruct)
  end

  def authenticated_header(user=nil)
    user = create(:user) unless user
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { "Authorization": "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include ApiHelpers
end
