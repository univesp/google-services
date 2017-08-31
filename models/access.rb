class Access
  include Mongoid::Document

  field :user_agent
  field :ip
  field :action
  field :date
  field :response

  embeds_one :requester
end