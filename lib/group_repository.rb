class GroupRepository < Repository

  def create_membership email, role, group_key
    m = @api.members.insert
    p = { :groupKey => group_key }
    b = { :email => email, :role => role }

    handle_response(
      @client.execute(
        :api_method => m,
        :parameters => p,
        :body_object => b)
    )
  end

  def delete_membership group_key, member_key
    m = @api.members.delete
    p = {
      :groupKey => group_key,
      :memberKey => member_key }

    handle_response(
      @client.execute(
        :api_method => m,
        :parameters => p)
    )
  end

end