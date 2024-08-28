# frozen_string_literal: true

# This file defines the CTG::Response::JSONResponse class, which is a subclass of CTGClient::Response.
# The JSONResponse class is responsible for handling responses in JSON format. It provides methods to query
# the JSON data by keys, as well as to find specific values or all occurrences of a key in the data.
#
# Methods:
# - `initialize`: Initializes the JSONResponse object by parsing the JSON data.
# - `query`: Queries the JSON data by keys.
# - `find`: Finds the first occurrence of a specified key in the JSON data.
# - `find_all`: Finds all occurrences of a specified key in the JSON data.


require 'json'

class CTG
  class Response
    class JSONResponse < Response
      attr_reader :data

      # Initializes the JSONResponse object by parsing the JSON data
      # @param [String] response_body - The raw JSON response body from the API
      # @param [CTG] client - The client instance to use for fetching subsequent pages
      def initialize(response_body, client)
        super(client)
        @data = JSON.parse(response_body)
      end

      # Queries the JSON data by keys
      # @param [Array<String>] keys - The sequence of keys to query the data
      # @return [Object] - The queried data
      def query(*keys)
        keys.reduce(@data) do |current_data, key|
          case current_data
          when Array
            case key
            when '*' # Handle wildcard for array access
              current_data.map { |element| element.is_a?(Hash) ? element : {} }
            when Integer
              current_data[key]
            else
              # If key is not an integer but the current data is an array, try to map over it
              current_data.map { |element| element[key] if element.is_a?(Hash) }.compact
            end
          when Hash
            current_data[key]
          end
        end
      end

      # Recursively find the first occurrence of a key in the JSON data
      # @param [String] key - The key to find in the JSON data
      # @param [Object] data - The current data to search within (used for recursion)
      # @return [Object] - The value associated with the key, or nil if not found
      def find(key, data = @data)
        case data
        when Hash
          return data[key] if data.key?(key)

          data.each_value do |value|
            result = find(key, value)
            return result if result
          end
        when Array
          data.each do |element|
            result = find(key, element)
            return result if result
          end
        end
        nil
      end

      def find_all(key)
        results = []
        stack = [@data]

        until stack.empty?
          current_data = stack.pop

          case current_data
          when Hash
            results << current_data[key] if current_data.key?(key)
            stack.concat(current_data.values)
          when Array
            stack.concat(current_data)
          end
        end

        results.compact
      end

    end
  end
end
