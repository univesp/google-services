module Sinatra
  module LogHelper

    def logger response
      # ATTENTION: this method must be called only after
      # authorize_requester method, because that filters
      # empty authorization headers

      # getting the requester
      name = env['HTTP_AUTHORIZATION'].split(':')[0]
      requester = Requester.find_by(name: name)

      # saving to db
      access = Access.new(
        user_agent: env['HTTP_USER_AGENT'],
        ip: env['REMOTE_ADDR'],
        action: "#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}",
        date: Time.now.in_time_zone('Brasilia').strftime('%d/%m/%Y %T'),
        response: response)
      access.requester = requester
      access.save!
    end

  end
end