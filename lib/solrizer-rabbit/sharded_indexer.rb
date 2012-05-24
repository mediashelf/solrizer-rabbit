module Solrizer::Rabbit
  class ShardedIndexer
    attr_accessor :shards
    def initialize
      self.shards = YAML.load_file(Rails.root + 'config/shards.yml')[Rails.env]
      @buffers = []
      shards.each do |conf|
        @buffers << DTU::BufferedIndexer.new(RSolr.connect(:url=>conf))
      end
    end

    def add(doc)
      buffer(doc['id']).add(doc)
    end

    def delete(doc)
      buffer(doc['id']).delete_by_id(doc['id'])
    end

    def flush(commit = false)
      @buffers.each {|b| b.flush(commit)}
    end

    def buffer(id)
      raise "No id" unless id
      n = Digest::MD5.hexdigest(id.to_s).hex % @buffers.count
      @buffers[n]
    end

  end
end


