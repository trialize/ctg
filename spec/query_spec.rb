# spec/query_spec.rb
require 'spec_helper'
require_relative '../lib/ctg/query'

RSpec.describe CTG::Query do
  let(:query) { CTG::Query.new }

  describe '#initialize' do
    it 'initializes with an empty params hash' do
      expect(query.params).to eq({})
    end
  end

  describe '#condition' do
    it 'adds a condition to the query' do
      query.condition('diabetes')
      expect(query.params['query.cond']).to eq('diabetes')
    end
  end

  describe '#term' do
    it 'adds a term to the query' do
      query.term('lung cancer')
      expect(query.params['query.term']).to eq('lung cancer')
    end
  end

  describe '#location' do
    it 'adds a location to the query' do
      query.location('New York')
      expect(query.params['query.locn']).to eq('New York')
    end
  end

  describe '#title' do
    it 'adds a title to the query' do
      query.title('Heart Disease Study')
      expect(query.params['query.titles']).to eq('Heart Disease Study')
    end
  end

  describe '#intervention' do
    it 'adds an intervention to the query' do
      query.intervention('Aspirin')
      expect(query.params['query.intr']).to eq('Aspirin')
    end
  end

  describe '#outcome' do
    it 'adds an outcome measure to the query' do
      query.outcome('Mortality Rate')
      expect(query.params['query.outc']).to eq('Mortality Rate')
    end
  end

  describe '#sponsor' do
    it 'adds a sponsor to the query' do
      query.sponsor('Pfizer')
      expect(query.params['query.spons']).to eq('Pfizer')
    end
  end

  describe '#lead_sponsor' do
    it 'adds a lead sponsor to the query' do
      query.lead_sponsor('NIH')
      expect(query.params['query.lead']).to eq('NIH')
    end
  end

  describe '#study_id' do
    it 'adds a study ID filter to the query' do
      query.study_id('NCT12345678')
      expect(query.params['query.id']).to eq('NCT12345678')
    end
  end

  describe '#patient' do
    it 'adds a patient-related search term to the query' do
      query.patient('adult')
      expect(query.params['query.patient']).to eq('adult')
    end
  end

  describe '#status' do
    it 'adds a status filter to the query' do
      query.status('RECRUITING', 'COMPLETED')
      expect(query.params['filter.overallStatus']).to eq('RECRUITING,COMPLETED')
    end
  end

  describe '#geo_filter' do
    it 'adds a geographical filter based on distance to the query' do
      query.geo_filter('distance(39.0035707,-77.1013313,50mi)')
      expect(query.params['filter.geo']).to eq('distance(39.0035707,-77.1013313,50mi)')
    end
  end

  describe '#nct_ids' do
    it 'adds a filter for specific NCT IDs to the query' do
      query.nct_ids('NCT12345678', 'NCT87654321')
      expect(query.params['filter.ids']).to eq('NCT12345678|NCT87654321')
    end
  end

  describe '#advanced_filter' do
    it 'adds an advanced filter expression to the query' do
      query.advanced_filter('expression')
      expect(query.params['filter.advanced']).to eq('expression')
    end
  end

  describe '#format' do
    it 'sets the response format to json by default' do
      query.format
      expect(query.params['format']).to eq('json')
    end

    it 'sets the response format to csv when specified' do
      query.format('csv')
      expect(query.params['format']).to eq('csv')
    end
  end

  describe '#page_size' do
    it 'sets the number of results per page' do
      query.page_size(500)
      expect(query.params['pageSize']).to eq(500)
    end

    it 'defaults to 1000 results per page' do
      query.page_size
      expect(query.params['pageSize']).to eq(1000)
    end
  end

  describe '#sort_by' do
    it 'sets the sorting order for the results' do
      query.sort_by('startDate', 'desc')
      expect(query.params['sort']).to eq('startDate:desc')
    end

    it 'defaults to ascending sort order' do
      query.sort_by('startDate')
      expect(query.params['sort']).to eq('startDate:asc')
    end
  end

  describe '#total' do
    it 'sets the count total flag in the query' do
      query.total
      expect(query.params['countTotal']).to eq(true)
    end
  end

  describe '#page_token' do
    it 'sets the token to get the next page of results' do
      query.page_token('token123')
      expect(query.params['pageToken']).to eq('token123')
    end
  end

  describe '#params' do
    it 'returns the complete query parameters' do
      query.condition('diabetes').term('lung cancer')
      expect(query.params).to eq({ 'query.cond' => 'diabetes', 'query.term' => 'lung cancer' })
    end
  end
end
