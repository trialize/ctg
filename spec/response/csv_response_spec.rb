# spec/response/csv_response_spec.rb
require 'spec_helper'
require_relative '../../lib/ctg/response/csv_response'

RSpec.describe CTG::Response::CSVResponse do
  let(:client) { instance_double("CTG") }
  let(:csv_data) { "header1,header2\nvalue1,value2\nvalue3,value4" }
  let(:response) { described_class.new(csv_data, client) }

  describe '#initialize' do
    it 'parses the CSV data and stores it in @data' do
      expect(response.data.headers).to include('header1', 'header2')
      expect(response.data.count).to eq(2)
    end
  end

  describe '#query' do
    it 'returns the values for a specific column' do
      expect(response.query('header1')).to eq(['value1', 'value3'])
    end

    it 'returns an empty array if the column does not exist' do
      expect(response.query('nonexistent')).to eq([])
    end
  end
end
