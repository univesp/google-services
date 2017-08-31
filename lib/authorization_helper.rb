module Sinatra
  module AuthorizationHelper

    def authorize_requester
      if env['HTTP_AUTHORIZATION'] && env['HTTP_AUTHORIZATION'].split(':').length == 2
        auth_header = env['HTTP_AUTHORIZATION'].split(':')
      else
        halt 401,
          { 'Content-Type' => 'application/json' },
          { code: 401, message: 'Empty HTTP Authorization' }.to_json
      end

      name = auth_header[0]
      client_token = auth_header[1]

      client = Requester.find_by(name: name)
      if client.nil?
        halt 403,
          { 'Content-Type' => 'application/json' },
          { code: 403, message: 'Requester not found' }.to_json
      end

      request_path = request.path_info.split('/')[1]

      computed_token = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha1'),
        client.token,
        request_path)

      if computed_token != client_token
        halt 403,
          { 'Content-Type' => 'application/json' },
          { code: 403, message: 'Invalid token' }.to_json
      end
    end

  end
end