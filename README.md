# Solrizer::Rabbit

Solrizer-rabbit is a gem for indexing ActiveFedora objects into solr by using RabbitMQ.

## Installation

Add this line to your application's Gemfile:

    gem 'solrizer-rabbit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install solrizer-rabbit

## Usage

<code>
# search fedora for a list of pids, write them into the queue
rake solrizer:rabbit:enqueue

# read the pids from fedora and index them. threads defaults to 1
rake solrizer:rabbit:index threads=7
</code>


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
