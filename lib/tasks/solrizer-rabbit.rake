namespace :solrizer
  namespace :rabbit
    desc "Enqueue all pids"
    tasks :enqueue do
      SolrizerRabbit.enqueue
    end

    desc "Run the index worker"
    tasks :index do
      SolrizerRabbit.work
    end
  end
end

