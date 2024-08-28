# frozen_string_literal: true

# The `CTG::Query` class provides a way to build queries for the ClinicalTrials.gov API.
# It allows chaining methods to specify various search parameters, including conditions,
# terms, locations, sponsors, and more. The class also supports pagination, sorting, and
# filtering of results. The built query can be used to fetch data in either JSON or CSV format.
#
# Example usage:
#   query = CTG::Query.new
#             .condition('diabetes')
#             .location('New York')
#             .status('RECRUITING', 'COMPLETED')
#             .page_size(50)
#             .sort_by('startDate', 'desc')
#
#   client.studies(query.params)
#
# Methods:
# - `condition`: Adds a condition or disease to the query.
# - `term`: Adds a term to the query.
# - `location`: Adds a location filter to the query.
# - `title`: Adds a title or acronym to the query.
# - `intervention`: Adds an intervention or treatment to the query.
# - `outcome`: Adds an outcome measure to the query.
# - `sponsor`: Adds a sponsor or collaborator to the query.
# - `lead_sponsor`: Adds a lead sponsor to the query.
# - `study_id`: Adds a study ID filter to the query.
# - `patient`: Adds a patient-related search to the query.
# - `status`: Adds an overall status filter to the query.
# - `geo_filter`: Adds a geographical filter based on distance.
# - `nct_ids`: Adds a filter for specific NCT IDs.
# - `advanced_filter`: Adds an advanced filter using the Essie expression syntax.
# - `format`: Sets the response format (json or csv).
# - `page_size`: Sets the number of results per page.
# - `sort_by`: Sets the sorting order for the results.
# - `total`: Counts the total number of results.
# - `page_token`: Sets the token to get the next page of results.

class CTG
  class Query
    attr_reader :params

    def initialize
      @params = {}
    end

    # Add a condition or disease to the query
    # @param [String] condition - The condition or disease to filter studies by
    # @return [CTG::Query] - The current instance for method chaining
    def condition(condition)
      @params['query.cond'] = condition
      self
    end

    # Add a term to the query
    # @param [String] term - Additional term to filter studies by
    # @return [CTG::Query] - The current instance for method chaining
    def term(term)
      @params['query.term'] = term
      self
    end

    # Add a location filter to the query
    # @param [String] location - The location term to filter studies by
    # @return [CTG::Query] - The current instance for method chaining
    def location(location)
      @params['query.locn'] = location
      self
    end

    # Add a title or acronym to the query
    # @param [String] title - The title or acronym to filter studies by
    # @return [CTG::Query] - The current instance for method chaining
    def title(title)
      @params['query.titles'] = title
      self
    end

    # Add an intervention or treatment to the query
    # @param [String] intervention - The intervention or treatment to filter studies by
    # @return [CTG::Query] - The current instance for method chaining
    def intervention(intervention)
      @params['query.intr'] = intervention
      self
    end

    # Add an outcome measure to the query
    # @param [String] outcome - The outcome measure to filter studies by
    # @return [CTG::Query] - The current instance for method chaining
    def outcome(outcome)
      @params['query.outc'] = outcome
      self
    end

    # Add a sponsor or collaborator to the query
    # @param [String] sponsor - The sponsor or collaborator to filter studies by
    # @return [CTG::Query] - The current instance for method chaining
    def sponsor(sponsor)
      @params['query.spons'] = sponsor
      self
    end

    # Add a lead sponsor to the query
    # @param [String] lead_sponsor - The lead sponsor to filter studies by
    # @return [CTG::Query] - The current instance for method chaining
    def lead_sponsor(lead_sponsor)
      @params['query.lead'] = lead_sponsor
      self
    end

    # Adds a study ID filter to the query
    # @param [String] study_id - The study ID or IDs to search for (comma- or space-separated)
    # @return [CTG::Query] - The updated query object
    def study_id(study_id)
      @params['query.id'] = study_id
      self
    end

    # Add a patient-related search to the query
    # @param [String] patient - The patient-related search term
    # @return [CTG::Query] - The current instance for method chaining
    def patient(patient)
      @params['query.patient'] = patient
      self
    end

    # Adds an overall status filter to the query
    # @param [Array<String>] statuses - The list of statuses to filter by (e.g., ['RECRUITING', 'COMPLETED'])
    # @return [CTG::Query] - The updated query object
    def status(*statuses)
      @params['filter.overallStatus'] = statuses.join(',')
      self
    end

    # Add a geographical filter based on distance
    # @param [String] geo - The geo-function filter (e.g., "distance(39.0035707,-77.1013313,50mi)")
    # @return [CTG::Query] - The current instance for method chaining
    def geo_filter(geo)
      @params['filter.geo'] = geo
      self
    end

    # Add a filter for specific NCT IDs
    # @param [Array<String>] ids - List of NCT IDs to filter by
    # @return [CTG::Query] - The current instance for method chaining
    def nct_ids(*ids)
      @params['filter.ids'] = ids.join('|')
      self
    end

    # Add an advanced filter using the Essie expression syntax
    # @param [String] expression - The advanced filter expression
    # @return [CTG::Query] - The current instance for method chaining
    def advanced_filter(expression)
      @params['filter.advanced'] = expression
      self
    end

    # Set the response format (json or csv)
    # @param [String] format - The format for the response, either 'json' or 'csv'
    # @return [CTG::Query] - The current instance for method chaining
    def format(format = 'json')
      @params['format'] = format
      self
    end

    # Set the number of results per page.
    # If not specified or set to 0, the default value will be used. It will be coerced down to 1,000, if greater than that.
    # @param [Integer] page_size - The number of results to return per page
    # @return [CTG::Query] - The current instance for method chaining
    def page_size(page_size = 1000)
      @params['pageSize'] = page_size
      self
    end

    # Set the sorting order for the results
    # @param [String] sort_by - The field to sort by
    # @param [String] direction - The direction to sort (asc or desc)
    # @return [CTG::Query] - The current instance for method chaining
    def sort_by(sort_by, direction = 'asc')
      @params['sort'] = "#{sort_by}:#{direction}"
      self
    end

    # Count total number of studies. The parameter is ignored for the subsequent pages.
    # @return [CTG::Query] - The current instance for method chaining
    def total
      @params['countTotal'] = true
      self
    end

    # Token to get next page. Set it to a nextPageToken value returned with the
    # previous page in JSON format. For CSV, it can be found in x-next-page-token response header.
    # Do not specify it for first page.
    # @return [CTG::Query] - The current instance for method chaining
    def page_token(token)
      @params['pageToken'] = token
      self
    end

  end
end
