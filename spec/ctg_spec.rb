# spec/ctg_client_spec.rb
require 'spec_helper'
require_relative '../lib/ctg/ctg'

RSpec.describe CTG do
  let(:client) { CTG.new }

  describe '#studies' do
    it 'fetches a list of studies based on query parameters' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/studies")
        .with(query: { 'query.cond' => 'diabetes' })
        .to_return(status: 200, body: '{"studies":[]}')

      query = CTG::Query.new.condition('diabetes')
      response = client.studies(query)
      expect(response).to be_a(CTG::Response)
    end

    it 'fetches a list of studies with plain hash parameters' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/studies")
        .with(query: { 'query.cond' => 'diabetes' })
        .to_return(status: 200, body: '{"studies":[]}')

      response = client.studies({ 'query.cond' => 'diabetes' })
      expect(response).to be_a(CTG::Response)
    end
  end

  describe '#number' do
    it 'fetches data for a single study by its NCT number' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/studies/NCT12345678")
        .to_return(status: 200, body: '{"nctId":"NCT12345678"}')

      response = client.number('NCT12345678')
      expect(response).to be_a(CTG::Response)
      expect(response.query('nctId')).to eq('NCT12345678')
    end
  end

  describe '#metadata' do
    it 'fetches metadata information about the study fields' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/studies/metadata")
        .to_return(status: 200, body: '{"fields":[]}')

      response = client.metadata
      expect(response).to be_a(CTG::Response)
      expect(response.query('fields')).to eq([])
    end
  end

  describe '#areas' do
    it 'fetches the list of search areas' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/studies/search-areas")
        .to_return(status: 200, body: '{"areas":[]}')

      response = client.areas
      expect(response).to be_a(CTG::Response)
      expect(response.query('areas')).to eq([])
    end
  end

  describe '#study_sizes' do
    it 'fetches statistics of study JSON sizes' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/stats/size")
        .to_return(status: 200, body: '{"totalStudies":1000}')

      response = client.study_sizes
      expect(response).to be_a(CTG::Response)
      expect(response.query('totalStudies')).to eq(1000)
    end
  end

  describe '#field_values' do
    it 'fetches value statistics of study leaf fields' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/stats/field/values")
        .to_return(status: 200, body: '{"fieldValues":[]}')

      response = client.field_values
      expect(response).to be_a(CTG::Response)
      expect(response.query('fieldValues')).to eq([])
    end
  end

  describe '#field_sizes' do
    it 'fetches sizes of list/array fields' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/stats/field/sizes")
        .to_return(status: 200, body: '{"listSizes":[]}')

      response = client.field_sizes
      expect(response).to be_a(CTG::Response)
      expect(response.query('listSizes')).to eq([])
    end
  end

  describe '#get' do
    it 'sends a GET request to the specified path with the given parameters' do
      stub_request(:get, "https://clinicaltrials.gov/api/v2/some-path")
        .with(query: { 'param1' => 'value1' })
        .to_return(status: 200, body: '{"data":"value"}')

      client.send(:get, '/some-path', { 'param1' => 'value1' })
      expect(client.response).to be_a(HTTParty::Response)
      expect(JSON.parse(client.response.body)).to eq('data' => 'value')
    end
  end
end

