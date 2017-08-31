require 'sinatra/base'
require 'mongoid'
require 'openssl'

class App < Sinatra::Base
  require_relative 'lib/authorization_helper'
  require_relative 'lib/log_helper'
  require_relative 'lib/repository'
  require_relative 'lib/user_repository'
  require_relative 'lib/group_repository'
  require_relative 'models/access'
  require_relative 'models/requester'

  helpers Sinatra::AuthorizationHelper
  helpers Sinatra::LogHelper

  configure do
    set :environment, :production

    Mongoid.load!('config/mongoid.yml')
  end

  before do
    # ensures that db was created
    # TODO: create method to handle this
    if Requester.count == 0
      # as the logger function creates a
      # new Access record in db, it can be
      # used to ensure the db creation
      logger ''
    end

    authorize_requester

    method_logger = method(:logger)
    @user_repository ||= UserRepository.new(method_logger)
    @group_repository ||= GroupRepository.new(method_logger)
  end

  # Users
  post '/create_user' do
    primary_email = params[:primary_email]
    password = params[:password]
    org_unit_path = params[:org_unit_path]
    given_name = params[:given_name]
    family_name = params[:family_name]

    res = @user_repository.create_user(primary_email,
      password, org_unit_path, given_name, family_name)
    res.to_json
  end

  get '/read_user' do
    user_key = params[:user_key]

    res = @user_repository.read_user(user_key)
    res.to_json
  end

  put '/update_user_suspension' do
    user_key = params[:user_key]
    suspended = params[:suspended]

    res = @user_repository.update_user_suspension(
      user_key, suspended)
    res.to_json
  end

  # Groups
  post '/create_membership' do
    email = params[:email]
    role = params[:role]
    group_key = params[:group_key]

    res = @group_repository.create_membership(
      email, role, group_key)
    res.to_json
  end

  delete '/delete_membership' do
    group_key = params[:group_key]
    member_key = params[:member_key]

    res = @group_repository.delete_membership(
      group_key, member_key)
    res.to_json
  end

end