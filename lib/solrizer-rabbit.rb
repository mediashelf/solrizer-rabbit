require "solrizer-rabbit/version"

require "solrizer-fedora"
require "solrizer-rabbit/queue_index_worker"
require "solrizer-rabbit/buffered_indexer"

module Solrizer
  module Rabbit
    def self.queue_name
      ENV['queue'] || 'index'
    end

    def self.enqueue
      q = Carrot.queue(queue_name)
      
      connections.each do |conn|
        conn.search(nil) do |object|
          q.publish(object.pid)
        end
      end 

      Carrot.stop
    end

    def self.work
      worker_count = (ENV['workers'] || 4).to_i

      workers = []
      threads = []
      worker_count.times do |n|
        worker = Solrizer::Rabbit::QueueIndexWorker.new
        workers << worker
        threads << Thread.new { worker.run }
      end

      Signal.trap("INT") { workers.each {|w| w.stop} }

      threads.each do |thread|
        thread.join
      end 
    end


    private 

    def self.connections
      if ActiveFedora.config.sharded?
        return ActiveFedora.config.credentials.map { |cred| ActiveFedora::RubydoraConnection.new(cred).connection}
      else
        return [ActiveFedora::RubydoraConnection.new(ActiveFedora.config.credentials).connection]
      end
    end
  end
end

load File.join(File.dirname(__FILE__),"tasks/solrizer-rabbit.rake") if defined?(Rake)

