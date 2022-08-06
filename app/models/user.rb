class User
  include Mongoid::Document
  field :email, type: String
  field :username, type: String
  field :password_hash, type: String

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end
end