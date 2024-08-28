# frozen_string_literal: true
# spec/response/json_response_spec.rb
require 'spec_helper'
require_relative '../../lib/ctg/response/json_response'

RSpec.describe CTG::Response::JSONResponse do
  let(:client) { instance_double('CTG') }
  let(:json_data) do
    {
      'protocolSection' => {
        'identificationModule' => {
          'nctId' => 'NCT04050163',
          'briefTitle' => 'MiSaver® Stem Cell Treatment for Heart Attack'
        },
        'statusModule' => {
          'overallStatus' => 'COMPLETED'
        },
        'arrayModule' => [
          { 'name' => 'John', 'age' => 30 },
          { 'name' => 'Jane', 'age' => 25 }
        ]
      }
    }.to_json
  end

  let(:json_array_data) do
    [
      { 'name' => 'John', 'age' => 30, 'city' => 'New York' },
      { 'name' => 'Jane', 'age' => 25, 'city' => 'Los Angeles' }
    ].to_json
  end

  let(:response) { described_class.new(json_data, client) }
  let(:array_response) { described_class.new(json_array_data, client) }

  describe '#initialize' do
    it 'parses the JSON data and stores it in @data' do
      expect(response.data).to be_a(Hash)
      expect(response.data['protocolSection']['identificationModule']['nctId']).to eq('NCT04050163')
    end

    it 'parses the JSON array data and stores it in @data' do
      expect(array_response.data).to be_an(Array)
      expect(array_response.data[0]['name']).to eq('John')
    end
  end

  describe '#query' do
    context 'with hash-based JSON data' do
      it 'returns the value for a specific sequence of keys' do
        expect(response.query('protocolSection', 'identificationModule', 'nctId')).to eq('NCT04050163')
      end

      it 'returns nil if a key does not exist' do
        expect(response.query('nonExistentKey')).to be_nil
      end

      it 'returns an array of values when querying an array with wildcard' do
        expect(response.query('protocolSection', 'arrayModule', '*', 'name')).to eq(%w[John Jane])
      end

      it 'returns nil for non-existent key in an array' do
        expect(response.query('protocolSection', 'arrayModule', '*', 'nonExistentKey')).to eq([])
      end

      it 'returns a single value when only one match exists in an array' do
        expect(response.query('protocolSection', 'arrayModule', '*', 'age')).to eq([30, 25])
      end

      it 'handles nested queries correctly' do
        expect(response.query('protocolSection', 'arrayModule', 0, 'name')).to eq('John')
      end

      it 'returns nil when querying a non-existent array index' do
        expect(response.query('protocolSection', 'arrayModule', 10, 'name')).to be_nil
      end
    end

    context 'with array-based JSON data' do
      it 'returns an array of values when querying top-level array with wildcard' do
        expect(array_response.query('*', 'name')).to eq(%w[John Jane])
      end

      it 'returns a specific value when querying an array index' do
        expect(array_response.query(1, 'city')).to eq('Los Angeles')
      end

      it 'returns nil when querying a non-existent array index' do
        expect(array_response.query(10, 'name')).to be_nil
      end

      it 'returns nil for non-existent key within array elements' do
        expect(array_response.query('*', 'nonExistentKey')).to eq([])
      end
    end
  end

  describe '#find' do
    context 'with hash-based JSON data' do
      it 'finds the value for a key that exists at the top level' do
        expect(response.find('nctId')).to eq('NCT04050163')
      end

      it 'finds the value for a key that exists deeply nested' do
        expect(response.find('briefTitle')).to eq('MiSaver® Stem Cell Treatment for Heart Attack')
      end

      it 'returns nil for a key that does not exist' do
        expect(response.find('nonExistentKey')).to be_nil
      end
    end

    context 'with array-based JSON data' do
      it 'finds the value for a key within an array of hashes' do
        expect(array_response.find('city')).to eq('New York')
      end

      it 'returns nil if the key is not found in any array element' do
        expect(array_response.find('nonExistentKey')).to be_nil
      end
    end
  end

  describe '#find_all' do
    context 'with hash-based JSON data' do
      it 'finds all occurrences of a key in nested structures' do
        expect(response.find_all('nctId')).to eq(['NCT04050163'])
      end

      it 'finds all occurrences of a key in an array of hashes' do
        expect(response.find_all('name').sort).to eq(%w[John Jane].sort)
      end

      it 'returns an empty array if the key does not exist' do
        expect(response.find_all('nonExistentKey')).to eq([])
      end
    end

    context 'with array-based JSON data' do
      it 'finds all occurrences of a key across array elements' do
        expect(array_response.find_all('city').sort).to eq(['New York', 'Los Angeles'].sort)
      end

      it 'returns an empty array if the key does not exist within the array elements' do
        expect(array_response.find_all('nonExistentKey')).to eq([])
      end
    end
  end

end
