class UserRepository < Repository

  def create_user(primary_email, password,
    org_unit_path, given_name, family_name)
    m = @api.users.insert
    b = {
      :primaryEmail => primary_email,
      :password => password,
      :orgUnitPath => org_unit_path,
      :name => {
        :givenName => given_name,
        :familyName => family_name } }

    handle_response(
      @client.execute(
        :api_method => m,
        :body_object => b)
    )
  end

  def read_user user_key
    m = @api.users.get
    p = { :userKey => user_key }

    handle_response(
      @client.execute(
        :api_method => m,
        :parameters => p)
    )
  end

  def update_user_suspension user_key, suspended
    m = @api.users.update
    p = { :userKey => user_key }
    b = { :suspended => suspended }

    handle_response(
      @client.execute(
        :api_method => m,
        :parameters => p,
        :body_object => b)
    )
  end

end