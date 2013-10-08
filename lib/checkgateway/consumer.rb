require 'builder'
require 'active_support'
require 'active_support/core_ext/hash'

module CheckGateway
  module Consumer
    # add consumer
    def add_consumer(params={})
      response = request_consumer(:build, params)
      response["Consumer"]
    end

    # update specific consumer
    def update_consumer(consumer_id, params={})
      response = request_consumer(:build, params.merge(:consumer_id => consumer_id))
      response["Consumer"]
    end

    # find by :consumer_id or :reference_identifier
    # pass nothing to find all
    def list_consumer(options={})
      response = request_consumer(:get, options)
      response["ListConsumer"]
    end

    private
    def request_consumer(action, params)
      request = Net::HTTP::Post.new(consumer_path)
      request.body = case action
                     when :build
                       build_consumer(params)
                     when :get
                       get_consumer(params)
                     end

      puts "REQUEST======", request.body if debug

      response = http.request(request)

      puts "RESPONSE=====", response.body if debug

      if response.code == "200"
        Hash.from_xml(response.body)["RecurringResponse"]
      else
        # unable to connect, should probably raise here.
        # TODO: handle timeouts
        response
      end
    end

    def build_consumer(options={})
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.RecurringRequest do
        xml.Credential do
          xml.UserID login
          xml.Password password
          xml.Version version
        end

        xml.Consumer do
          xml.Id                options[:consumer_id]             if options[:consumer_id]
          xml.RequestIdentifier options[:request_identifier]      if options[:request_identifier]
          xml.Name              options[:name]                    if options[:name]
          xml.BankRoutingNumber options[:routing_number]          if options[:routing_number]
          xml.BankAccountNo     options[:account_number]          if options[:account_number]
          xml.IsSavingsAccount  options[:savings].to_s.capitalize if options[:savings]
          xml.Address1          options[:address1]                if options[:address1]
          xml.Address2          options[:address2]                if options[:address2]
          xml.City              options[:city]                    if options[:city]
          xml.State             options[:state]                   if options[:state]
          xml.Zip               options[:zip]                     if options[:zip]
          xml.Country           options[:country]                 if options[:country]
          xml.Phone             options[:phone]                   if options[:phone]
          xml.Email             options[:email]                   if options[:email]
          xml.Birthday          options[:birthday]                if options[:birthday] # "M/D/YYYY"
          xml.SSN               options[:ssn]                     if options[:ssn] # Format can be "123456789" or "123-45-6789" or "6789".
          xml.SECCode           options[:sec_code]                if options[:sec_code]
          xml.CoNo              options[:company_number]
          xml.Notes             options[:notes]                   if options[:notes]
        end
      end
    end

    def get_consumer(options={})
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.RecurringRequest do
        xml.Credential do
          xml.UserID login
          xml.Password password
          xml.Version version
        end
        xml.ListConsumer do
          xml.ConsumerId options[:consumer_id] if options[:consumer_id]
          xml.RequestIdentifier options[:request_identifier] if options[:request_identifier]
        end
      end
    end
  end
end
