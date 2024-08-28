# CTG

`CTG` is a Ruby client library for interacting with the ClinicalTrials.gov API. It allows you to fetch and query clinical study data, including study metadata, search areas, study sizes, field values, and more. The library supports both JSON and CSV response formats, with built-in support for pagination and advanced querying.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ctg'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install ctg
```

## Usage

### Initializing the Client

To start using the `CTG`, first create a new client instance:

```ruby
require 'ctg'

client = CTG.new
```

### Fetching Studies

You can fetch studies using the `studies` method. This will return a `CTG::Response` object that you can query.

```ruby
response = client.studies('query.term' => 'cancer')
studies = response.query('studies')
puts studies
```

### Fetching a Single Study by NCT Number

You can fetch a single study by its NCT number:

```ruby
response = client.number('NCT04050163')
study = response.query('nctId')
puts study  
```

### Fetching Study Metadata

To fetch metadata information about study fields:

```ruby
response = client.metadata
metadata = response.data
puts metadata
```

### Handling Pagination

If your query returns multiple pages of results, you can fetch the next page using the `next_page` method:

```ruby
response = client.studies('query.term' => 'cancer', 'pageSize' => 5)
puts response.query('studies')

next_page_response = response.next_page
puts next_page_response.query('studies') if next_page_response
```

### Querying the Response

You can query JSON responses using keys or XPath expressions:

```ruby
response = client.number('NCT04050163')
nct_id = response.query('nctId')
puts nct_id  # Outputs 'NCT04050163'
```

For CSV responses, query by column name:

```ruby
response = client.number('NCT04050163', format: 'csv')
nct_ids = response.query('NCT Number')
puts nct_ids
```

### Finding a Specific Key in JSON Data

You can find the first occurrence of a specific key within the JSON data using the `find` method:

```ruby
response = client.number('NCT04050163')
nct_id = response.find('nctId')
puts nct_id  # Outputs 'NCT04050163'
```

## CTG::Query Object

The `CTG::Query` class is designed to help you build complex queries for searching clinical studies on ClinicalTrials.gov. It provides a convenient way to add different query parameters and filters, allowing for advanced search capabilities.

### Creating a Query

To start building a query, you first need to create an instance of the `CTG::Query` class:

```ruby
query = CTG::Query.new
```

### Adding Query Parameters

The `CTG::Query` object allows you to add various search parameters using method chaining. Below are the available methods:

#### `condition(condition)`
Adds a condition or disease to the query.

- **Parameter**: `condition` (String) - The condition or disease to search for.
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.condition('diabetes')
```

#### `term(term)`
Adds additional search terms to the query.

- **Parameter**: `term` (String) - Additional search terms.
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.term('lung cancer')
```

#### `location(location)`
Adds a location filter to the query.

- **Parameter**: `location` (String) - The location term to filter results by.
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.location('New York')
```

#### `title(title)`
Adds a title or acronym to the query.

- **Parameter**: `title` (String) - The title or acronym to search for.
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.title('COVID-19 Vaccine')
```

#### `intervention(intervention)`
Adds an intervention or treatment to the query.

- **Parameter**: `intervention` (String) - The intervention or treatment to search for.
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.intervention('remdesivir')
```

#### `outcome(outcome)`
Adds an outcome measure to the query.

- **Parameter**: `outcome` (String) - The outcome measure to search for.
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.outcome('survival rate')
```

#### `collaborator(collaborator)`
Adds a sponsor or collaborator to the query.

- **Parameter**: `collaborator` (String) - The sponsor or collaborator to search for.
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.collaborator('IQVIA')
```

#### `sponsor(lead_sponsor)`
Adds a lead sponsor to the query.

- **Parameter**: `sponsor` (String) - The lead sponsor to search for.
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.sponsor('National Institutes of Health')
```

#### `study_id(study_id)`
Adds a study ID filter to the query.

- **Parameter**: `study_id` (String) - The study ID or IDs to search for (comma- or space-separated).
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.study_id('NCT01234567')
```

#### `status(*statuses)`
Adds an overall status filter to the query.

- **Parameter**: `statuses` (Array<String>) - The list of statuses to filter by (e.g., `['RECRUITING', 'COMPLETED']`).
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.status('RECRUITING', 'COMPLETED')
```

#### `page_size(size)`
Specifies the number of results per page.

- **Parameter**: `size` (Integer) - The number of results to return per page (max 1000).
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.page_size(50)
```

#### `format(format)`
Specifies the format of the response.

- **Parameter**: `format` (String) - The format of the response (`'json'` or `'csv'`).
- **Returns**: The updated `CTG::Query` object.

```ruby
query = CTG::Query.new.format('json')
```

### Retrieving Query Parameters

Once you’ve built your query, you can retrieve the complete set of query parameters as a hash:

```ruby
query_params = query.params
```

This `params` method returns a hash of all the query parameters that have been set.

### Example: Building a Complex Query

Here’s an example of how you might build a more complex query using method chaining:

```ruby
query = CTG::Query.new
  .condition('diabetes')
  .term('insulin')
  .location('California')
  .status('RECRUITING')
  .page_size(10)
  .format('json')

# Use the query in a client request
response = client.studies(query)
puts response.query('studies', 'protocolSection', 'outcomesModule', 'secondaryOutcomes' )
```

In this example, the query is set to search for recruiting studies related to diabetes and insulin in California, returning results in JSON format with a page size of 10.

### Finding All Occurrences of a Key in JSON Data

If you need to find all occurrences of a specific key within the JSON data, use the `find_all` method:

```ruby
references = response.find_all('references')
puts references 
```


## Running Tests

To run the tests, use RSpec:

```bash
rspec
```

This will run all the tests located in the `spec/` directory and report on their success.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trialize/ctg.

## License

This library is available as open source under the terms of the MIT License.
Copyright 2024 Leonid Stoianov. Copyright 2024 Trialize.
