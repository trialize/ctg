# frozen_string_literal: true

# This file defines the main CTG class, which serves as the interface to interact
# with the ClinicalTrials.gov API. It includes methods to fetch data for studies, metadata,
# areas, and statistics. Each method returns a Response object that encapsulates the data
# along with pagination capabilities.
#
# Methods:
# - `studies`: Fetches a list of studies based on query parameters with support for pagination.
# - `number`: Fetches data for a single study by its NCT number.
# - `metadata`: Fetches metadata information about the study fields.
# - `areas`: Fetches the list of search areas.

require 'active_support/core_ext/hash'
require 'httparty'

require_relative 'query'
require_relative 'response/json_response'
require_relative 'response/csv_response'
require_relative 'response'

class CTG
  include HTTParty
  base_uri 'https://clinicaltrials.gov/api/v2'
  attr_reader :response

  def initialize
    @headers = { 'Content-Type' => 'application/json' }
    @response = nil
  end

  # Fetch a list of studies based on query parameters with support for pagination
  # @param [CTG::Query, Hash] query - Query parameters for filtering studies
  # @return [CTG::Response] - Response object wrapping the API response
  def studies(query)
    params = if query.is_a?(CTG::Query)
               query.params
             else
               query.stringify_keys
             end

    get('/studies', params)

    CTG::Response.parse(@response.body, params['format'] || 'json', self)
  end

  # Fetch data for a single study by its NCT number
  # @param [String] nct_id - The NCT ID of the study
  # @param [Hash] params - Additional query parameters
  # @option params [String] :format ('json') - The format of the response ('json', 'csv', etc.)
  # @option params [Array<String>] :fields - A list of fields to include in the response
  # @option params [String] :markupFormat - Format for fields that include markup ('markdown', 'legacy')
  # @return [CTG::Response] - Response object wrapping the API response
  def number(nct_id, params = {})
    get("/studies/#{nct_id}", params)
    CTG::Response.parse(@response.body, params.stringify_keys['format'] || 'json', self)
  end

  # Fetch metadata information about the study fields
  # @param [Hash] params - Additional query parameters
  # @option params [Boolean] :includeIndexedOnly (false) - If true, includes fields that are indexed only
  # @option params [Boolean] :includeHistoricOnly (false) - If true, includes fields available only in historic data
  # @return [CTG::Response] - Response object wrapping the API response
  def metadata(params = {})
    get('/studies/metadata', params)
    CTG::Response.parse(@response.body, 'json', self)
  end

  # Fetch the list of search areas
  # This method doesn't require any specific query parameters.
  # @return [CTG::Response] - Response object wrapping the API response
  def areas
    get('/studies/search-areas')
    CTG::Response.parse(@response.body, 'json', self)
  end

  # Fetch statistics of study JSON sizes
  # @return [CTG::Response] - Response object wrapping the API response
  def study_sizes
    get('/stats/size')
    CTG::Response.parse(@response.body, 'json', self)
  end

  # Fetch value statistics of study leaf fields
  # @param [Hash] params - Query parameters for filtering field values
  # @option params [Array<String>] :types - Filter by field types (e.g., 'ENUM', 'BOOLEAN', 'STRING')
  # @option params [Array<String>] :fields - Filter by specific fields or field paths of leaf fields
  # @return [CTG::Response] - Response object wrapping the API response
  def field_values(params = {})
    get('/stats/field/values', params)
    CTG::Response.parse(@response.body, 'json', self)
  end

  # Fetch sizes of list/array fields
  # @param [Hash] params - Query parameters for filtering field sizes
  # @option params [Array<String>] :fields - Filter by specific list/array fields or field paths
  # @return [CTG::Response] - Response object wrapping the API response
  def field_sizes(params = {})
    get('/stats/field/sizes', params)
    CTG::Response.parse(@response.body, 'json', self)
  end


  private

  # @param [String] path - The API endpoint path to send the request to.
  # @param [Hash] params - Query parameters to include in the request.
  # @option params [Hash<String, String>] :headers - Optional headers to include in the request.
  # @return [HTTParty::Response] - The raw response object from the HTTP request.
  def get(path, params = {})
    options = { headers: @headers, query: params }
    @response = self.class.get(path, options)
  end

end
