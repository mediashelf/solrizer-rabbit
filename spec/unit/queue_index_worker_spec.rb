require 'spec_helper'
describe Solrizer::Rabbit::QueueIndexWorker do

  before do
    @mock_buffer = mock()
    Solrizer::Rabbit::BufferedIndexer.should_receive(:new).with(kind_of RSolr::Client).and_return(@mock_buffer)
    @stub_queue = stub('queue')
    @stub_queue.should_receive(:pop).and_return('foo:123', 'foo:231', nil)
    Carrot.should_receive(:queue).and_return(@stub_queue)
  end
  it "should run" do
    @mock_buffer.should_receive(:flush)
    @mock_buffer.should_receive(:add).with("document 1")
    @mock_buffer.should_receive(:add).with("document 2")

    obj1 = stub('obj1', :pid=>'foo:123')
    obj2 = stub('obj2', :pid=>'foo:231')
    @mock_indexer = mock("indexer")
    @mock_indexer.should_receive(:create_document).with(obj1).and_return("document 1") 
    @mock_indexer.should_receive(:create_document).with(obj2).and_return("document 2")
    Solrizer::Fedora::Indexer.should_receive(:new).and_return(@mock_indexer)
    Solrizer::Fedora::Repository.should_receive(:get_object).with('foo:123').and_return(obj1)
    Solrizer::Fedora::Repository.should_receive(:get_object).with('foo:231').and_return(obj2)
    
    subject.run
  end

end
