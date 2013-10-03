require "checkgateway/version"
require "checkgateway/client"

module Checkgateway
  FAKE_ROUTING_NUMBER = 999999992
  FAKE_ACCOUNTS = [100, 200, 300, 400, 500, 900, 910, 990] # triggers failure responses
end
