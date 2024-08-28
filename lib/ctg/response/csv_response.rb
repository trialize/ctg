# frozen_string_literal: true

# This file defines the CTG::Response::CSVResponse class, which is a subclass of CTG::Response.
# The CSVResponse class is responsible for handling responses in CSV format. It provides methods to query
# the CSV data by column name.
#
# Methods:
# - `initialize`: Initializes the CSVResponse object by parsing the CSV data.
# - `query`: Queries the CSV data by column name.

require 'csv'

class CTG
  class Response
    class CSVResponse < Response
      attr_reader :data

      # Initializes the CSVResponse object by parsing the CSV data
      # @param [String] response_body - The raw CSV response body from the API
      # @param [CTG] client - The client instance to use for fetching subsequent pages
      def initialize(response_body, client)
        super(client)
        @data = CSV.parse(response_body, headers: true)
      end

      # Queries the CSV data by column name
      # @param [String] column_name - The name of the column to query
      # @return [Array<String>] - An array of values from the specified column
      def query(column_name)
        @data.map { |row| row[column_name] }.compact
      end

    end
  end
end
