# frozen_string_literal: true

# This file defines the CTG::Response class, which serves as a wrapper around the response
# returned by the ClinicalTrials.gov API. The Response class provides a common interface for working
# with different response formats (JSON, CSV) and supports functionalities like pagination, querying
# by keys.
#
# The CTG::Response class delegates the format-specific behavior to its subclasses,
# CTG::Response::JSONResponse and CTG::Response::CSVResponse.
#
# Methods:
# - `parse`: Factory method that returns an appropriate response object (JSON or CSV).
# - `query`: Queries the response data by keys.
# - `next_page`: Next page (if page token exists)

class CTG
  class Response
    attr_reader :client

    # Factory method to create an appropriate response object based on format
    # @param [String] response_body - The raw response body from the API
    # @param [String] format - The format of the response ('json' or 'csv')
    # @param [CTG] client - The client instance to use for fetching subsequent pages
    # @return [CTG::Response] - An instance of either JSONResponse or CSVResponse
    def self.parse(response_body, format, client)
      case format
      when 'json'
        JSONResponse.new(response_body, client)
      when 'csv'
        CSVResponse.new(response_body, client)
      else
        raise "Unsupported format: #{format}"
      end
    end

    # Initializes the Response object
    # @param [CTG] client - The client instance that made the request
    def initialize(client)
      @client = client
    end

    # Queries the response data by keys (to be implemented in subclasses)
    # @param [Array<String>] keys - The sequence of keys to query the data
    # @return [Object] - The queried data
    def query(*keys)
      raise NotImplementedError, 'Subclasses must implement the `query` method'
    end

    # @return [CTG::Response, nil]
    #   - Returns a new Response object containing the next page of data.
    #   - Returns `nil` if no next page token is found, indicating there is no further data.
    def next_page
      next_page_token = @client.response.headers['x-next-page-token'] || @data['nextPageToken']
      return unless next_page_token

      request = @client.response.request
      format = request.options[:format] || 'json'

      request.options[:query].merge! CTG::Query.new
                                               .page_token(next_page_token)
                                               .params

      CTG::Response.parse(request.perform.body, format, @client)
    end

  end
end
