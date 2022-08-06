require_relative './helpers'

post '/api/employees' do
  authenticated_api_user

  param :name,            String, required: true, message: 'name is required'
  param :salary,          Float, required: true
  param :currency,        String, default: "USD"
  param :department,      String, required: true, message: 'department is required'
  param :sub_department,  String, required: true, message: 'sub_department is required'

  employee = Employee.create!(
    name: params[:name],
    salary: params[:salary],
    currency: params[:currency],
    department: params[:department],
    sub_department: params[:sub_department],
  )
  json(employee)
end

get '/api/employees/:id' do
  authenticated_api_user
  employee = Employee.find(params[:id])
  if employee
    json(employee)
  else
    halt 404, {error: :not_found, message: 'Employee not found'}.to_json
  end
end

delete '/api/employees/:id' do
  authenticated_api_user
  employee = Employee.find(params[:id])
  if employee
    employee.destroy
    json(employee)
  else
    halt 404, {error: :not_found, message: 'Employee not found'}.to_json
  end
end

get '/api/ss/employees' do
  ss = Employee.summary_statistics
  json(ss)
end

get '/api/ss/on_contract/employees' do
  ss = Employee.summary_statistics_on_contract
  json(ss)
end

get '/api/ss/employees/:department' do
  ss = Employee.summary_statistics_department(params[:department])
  json(ss)
end

get '/api/ss/employees/:department/:sub_department' do
  ss = Employee.summary_statistics_department_and_sub_department(params[:department], params[:sub_department])
  json(ss)
end
