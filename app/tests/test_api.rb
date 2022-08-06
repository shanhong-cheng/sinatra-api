require_relative './_helpers'

get '/api/user' do
  user = authenticated_api_user

  json(user)
end

class APITest < Minitest::Test
  def setup
    User.destroy_all
    @user = User.create!(
      username: 'john.doe',
      password: 'password'
    )
  end

  def test_get_user
    basic_authorize @user.username, 'password'

    get '/api/user'

    assert last_response.ok?
    resp = JSON.parse(last_response.body)
    assert_equal resp['username'], @user.username
  end
end
