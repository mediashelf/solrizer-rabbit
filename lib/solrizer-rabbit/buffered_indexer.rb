module Solrizer::Rabbit
  class BufferedIndexer 
    include ActiveSupport::Benchmarkable
    BUFFER_SIZE = 1000
    COMMIT_EVERY = 0


    def initialize(conn)
      @count = 0
      @batch_count = 0
      @add_buffer = []
      @delete_buffer = []
      @solr = conn
    end

    def flush(commit = false)
      try_to_add unless @add_buffer.empty?
      @add_buffer = []
      try_to_delete unless @delete_buffer.empty?
      @delete_buffer = []
      @count = 0
      maybe_commit()
    end

    def try_to_add
      tries = 0
      begin 
        benchmark "#{$$} -- #{Rails.env} solr add" do
          solr.add @add_buffer
        end
      rescue TimeoutError 
        ## The timeout is set in this parameter.  It is 60 seconds by default.
        # rsolr.connection.connection.read_timeout = 60
        tries += 1 
        puts "Timeout #{tries}" 
        sleep(10 * tries) # wait a little longer each time through
        retry if tries < 5 
        raise "Adding docs timed out #{tries} times. Qutting." 
      end
    end

    def try_to_delete
      tries = 0
      begin 
        benchmark "#{$$} -- #{Rails.env} solr delete" do
          solr.delete_by_id @delete_buffer
        end
      rescue TimeoutError 
        ## The timeout is set in this parameter.  It is 60 seconds by default.
        # rsolr.connection.connection.read_timeout = 60
        tries += 1 
        puts "Timeout #{tries}" 
        sleep(10 * tries) # wait a little longer each time through
        retry if tries < 5 
        raise "Adding docs timed out #{tries} times. Qutting." 
      end
    end

    def maybe_commit(force=false)
      return if COMMIT_EVERY == 0 && !force
      @batch_count += 1
      if force || @batch_count > COMMIT_EVERY
        solr.commit
        @batch_count =0
      end
    end

    def add(doc)
      @add_buffer << doc
      increment
    end
    def delete_by_id(doc)
      @delete_buffer << doc
      increment
    end

    private

    def increment
      @count += 1
      flush if @count >= BUFFER_SIZE
    end

    def solr
      @solr
    end
  end
end

