class Repository
  require 'google/api_client'
  require 'dotenv/load'

  def initialize logger
    @logger = logger

    authorize
  end

  def authorize
    key = Google::APIClient::PKCS12.load_key(ENV['PKC12_FILE_PATH'], ENV['PKC12_SECRET'])
    scopes = ENV['SCOPES'].split ','
    asserter = Google::APIClient::JWTAsserter.new(ENV['ACCOUNT_EMAIL'], scopes, key)

    @client = Google::APIClient.new(:application_name => ENV['APP_NAME'])
    @client.authorization = asserter.authorize(ENV['BEHALF_EMAIL'])
    @client.authorization.fetch_access_token!

    @api = @client.discovered_api('admin', 'directory_v1')
  end

  def handle_response request
    if request.error?
      response = { :status => :error, :msg => request.error_message }
    else
      response = { :status => :ok, :obj => request.response.body }
    end

    @logger.call(response)
    response
  end

end