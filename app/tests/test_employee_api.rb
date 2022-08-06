require_relative './_helpers'

class APITest < Minitest::Test
  def setup
    User.destroy_all
    Employee.destroy_all
    @user = User.create!(
      username: 'john.doe',
      password: 'password'
    )
    @employee = Employee.create!(
      name: 'sample',
      salary: 100,
      department: 'Sales',
      sub_department: 'sales',
      currency: 'USD'
    )
  end

  def test_create_employee
    basic_authorize @user.username, 'password'

    post '/api/employees', {
      name: 'test',
      salary: 100,
      department: 'Sales',
      sub_department: 'sales',
      currency: 'USD'
    }

    assert last_response.ok?
    employee = JSON.parse(last_response.body)
    assert_equal employee['name'], 'test'
  end

  def test_create_employee_invalid
    basic_authorize @user.username, 'password'

    post '/api/employees', {
      name: 'test',
      salary: "100s",
      department: 'Sales',
      sub_department: 'sales',
      currency: 'USD'
    }

    refute last_response.ok?
    employee = JSON.parse(last_response.body)
    assert_equal employee['error'], 'salary is invalid'
    assert_equal employee['message'], "'100s' is not a valid Float"
  end

  def test_get_employee
    basic_authorize @user.username, 'password'

    get "/api/employees/#{@employee._id}"

    assert last_response.ok?
    employee = JSON.parse(last_response.body)
    assert_equal employee['name'], 'sample'
  end

  def test_delete_employee
    basic_authorize @user.username, 'password'

    delete "/api/employees/#{@employee._id}"

    assert last_response.ok?
    employee = JSON.parse(last_response.body)
    assert_equal employee['name'], 'sample'
  end

  def test_get_ss
    basic_authorize @user.username, 'password'

    get '/api/ss/employees'

    assert last_response.ok?
    hash = JSON.parse(last_response.body)
    assert_equal hash['max'], 100
    assert_equal hash['min'], 100
    assert_equal hash['mean'], 100
  end

  def test_get_ss_on_contract
    basic_authorize @user.username, 'password'

    get '/api/ss/on_contract/employees'

    assert last_response.ok?
    hash = JSON.parse(last_response.body)
    assert_equal hash['max'], 0
    assert_equal hash['min'], 0
    assert_equal hash['mean'], 0

    @employee.on_contract = true
    @employee.save!


    get '/api/ss/on_contract/employees'

    assert last_response.ok?
    hash = JSON.parse(last_response.body)
    assert_equal hash['max'], 100
    assert_equal hash['min'], 100
    assert_equal hash['mean'], 100
  end

  def test_get_ss_department
    basic_authorize @user.username, 'password'

    get '/api/ss/employees/Sales'

    assert last_response.ok?
    hash = JSON.parse(last_response.body)
    assert_equal hash['max'], 100
    assert_equal hash['min'], 100
    assert_equal hash['mean'], 100
  end

  def test_get_ss_department_and_sub_department
    basic_authorize @user.username, 'password'

    get '/api/ss/employees/Sales/sales'

    assert last_response.ok?
    hash = JSON.parse(last_response.body)
    assert_equal hash['max'], 100
    assert_equal hash['min'], 100
    assert_equal hash['mean'], 100
  end
end
