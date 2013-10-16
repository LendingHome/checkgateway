require 'active_support'
require 'active_support/core_ext/hash'

module CheckGateway
  # real-time ACH API
  module ACH
    def authorize(options={})
      params = {
        "ReferenceNumber" => options[:reference_number],
        "Amount" => options[:amount]
      }
      params.merge!(consumer_credentials(options))
      response = request(:authorize, params)
    end

    def debit(options={})
      params = {
        "ReferenceNumber" => options[:reference_number],
        "Amount" => options[:amount]
      }
      params.merge!(consumer_credentials(options))
      response = request(:debit, params)
    end

    def credit(options={})
      params = {
        "ReferenceNumber" => options[:reference_number],
        "Amount" => options[:amount]
      }
      params.merge!(consumer_credentials(options))
      response = request(:credit, params)
    end

    def cancel(options={})
      params = {
        "ReferenceNumber" => options[:reference_number],
        "TransactionID" => options[:transaction_id],
        "Notes" => options[:notes]
      }
      response = request(:cancel, params)
    end

    def refund(options={})
      params = {
        "ReferenceNumber" => options[:reference_number],
        "Amount" => options[:amount],
        "TransactionID" => options[:transaction_id],
        "Notes" => options[:notes]
      }
      response = request(:cancel, params)
    end

    def status(options={})
      params = {}
      params.merge!("ReferenceNumber" => options[:reference_number]) if options[:reference_number]
      params.merge!("TransactionID" => options[:transaction_id]) if options[:transaction_id]
      response = request(:status, params)
    end

    private
    def request(action, params={})
      params.merge!({ "Method" => action.to_s.capitalize,
                      "Version" => version,
                      "ResponseXML" => "True",
                      "Test" => test_mode.to_s.capitalize,
                      "Login" => login,
                      "Password" => password
                    })

      query_string = params.map{|k,v| "#{k}=#{URI.escape(v.to_s)}"}.join('&')
      puts "REQUEST======", "#{base_url}/#{ach_path}?#{query_string}" if debug

      request = Net::HTTP::Get.new("/#{ach_path}?#{query_string}")
      response = http.request(request)

      puts "RESPONSE=====", response.body if debug

      if response.code == "200"
        Hash.from_xml(response.body)["Response"]
      else
        # unable to connect, should probably raise here.
        # TODO: handle timeouts
        response
      end
    end

    def consumer_credentials(options)
      if options[:consumer_id]
        { "ConsumerId" => options[:consumer_id] }
      else
        { "RoutingNumber" => options[:routing_number],
          "AccountNumber" => options[:account_number],
          "Savings" => options[:savings].to_s.capitalize,

          # some required or not depending on operation.  not needed if using consumer id
          "Name" => options[:name], # first and last name, no commas
          "Address1" => options[:address1],
          "Address2" => options[:address2],
          "City" => options[:city],
          "State" => options[:state],
          "Zip" => options[:zip],
          "Phone" => options[:phone],
          "Birthday" => options[:birthday], # "M/D/YYYY"
          "SSN" => options[:ssn] || 0 # Format can be "123456789" or "123-45-6789" or "6789".
        }
      end
    end
  end
end
