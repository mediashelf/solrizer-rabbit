namespace :solrizer do
  namespace :rabbit do
    desc "Enqueue all pids"
    task :enqueue => :environment do
      Solrizer::Rabbit.enqueue
    end

    desc "Run the index worker"
    task :index => :environment do
      Solrizer::Rabbit.work
    end
  end
end

