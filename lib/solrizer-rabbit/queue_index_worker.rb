require 'carrot'
module Solrizer
  module Rabbit
    class QueueIndexWorker
      def initialize
        Thread.current[:carrot] = Carrot.new()#:host=>'mediashelf.eu')
        @q = Carrot.queue(Solrizer::Rabbit.queue_name)

        @buff = BufferedIndexer.new(ActiveFedora::SolrService.instance.conn)
        @stopped = false
      end

      def stop
        puts "finishing writes"
        @stopped=true
      end

      def run
        indexer = Solrizer::Fedora::Indexer.new
        while !@stopped && msg = @q.pop
          begin
            obj = Solrizer::Fedora::Repository.get_object(msg)
            solr_doc = indexer.create_document( obj )
            @buff.add(solr_doc)
          rescue RSolr::Error::Http, Errno::ECONNREFUSED => exception
            puts "Fatal #{exception.class}, exception see log"
            logger.fatal( "\n\n#{exception.class} (#{exception.message})\n\n")
            logger.flush if logger.respond_to? :flush #Rails logger is flushable, mediashelf-loggable isn't
            exit!
          rescue StandardError => exception
            puts "Caught #{exception.class}, while procesing `#{msg}` see log"
            logger.fatal( "\n\n#{exception.class} (#{exception.message}) while procesing `#{msg}`:\n    " + exception.backtrace.join("\n    ") + "\n\n")
            logger.flush if logger.respond_to? :flush #Rails logger is flushable, mediashelf-loggable isn't
          end
        end
        puts "flushing buffers"
        @buff.flush(true)
        Carrot.stop
        puts "done"
      end
    end
  end
end
