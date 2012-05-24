namespace :solrizer do
  namespace :rabbit do
    desc "Enqueue all pids"
    tasks :enqueue do
      Solrizer::Rabbit.enqueue
    end

    desc "Run the index worker"
    tasks :index do
      Solrizer::Rabbit.work
    end
  end
end

