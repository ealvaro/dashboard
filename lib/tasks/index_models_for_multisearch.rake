namespace :index do

  namespace :add do

    desc "Index Job model"
    task :job => :environment do
      PgSearch::Multisearch.rebuild(Job)
    end

    desc "Index Run model"
    task :run => :environment do
      PgSearch::Multisearch.rebuild(Run)
    end

    desc "Index Client model"
    task :client => :environment do
      PgSearch::Multisearch.rebuild(Client)
    end

    desc "Index Well model"
    task :well => :environment do
      PgSearch::Multisearch.rebuild(Well)
    end

    desc "Index Formation model"
    task :formation => :environment do
      PgSearch::Multisearch.rebuild(Formation)
    end

    desc "Index Tool model"
    task :tool => :environment do
      PgSearch::Multisearch.rebuild(Tool)
    end

    desc "Index ToolType model"
    task :tool_type => :environment do
      PgSearch::Multisearch.rebuild(ToolType)
    end

    desc "Index Event model"
    task :event => :environment do
      PgSearch::Multisearch.rebuild(Event)
    end

    desc "Index Rig model"
    task :rig => :environment do
      PgSearch::Multisearch.rebuild(Rig)
    end

    desc "Index Survey model"
    task :survey => :environment do
      PgSearch::Multisearch.rebuild(Survey)
    end

    desc "Index all models"
    task :all => [:job, :run, :client, :well, :formation, :survey, :rig, :tool_type]
  end

  namespace :delete do

    desc "Clear index for Job model"
    task :job => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Job")
    end

    desc "Clear index for Run model"
    task :run => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Run")
    end

    desc "Clear index for Client model"
    task :client => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Client")
    end

    desc "Clear index for Well model"
    task :well => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Well")
    end

    desc "Clear index for Formation model"
    task :formation => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Formation")
    end

    desc "Clear index for Tool model"
    task :tool => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Tool")
    end

    desc "Clear index for Event model"
    task :event => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Event")
    end

    desc "Clear index for Rig model"
    task :rig => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Rig")
    end

    desc "Clear index for Survey model"
    task :survey => :environment do
      PgSearch::Document.delete_all(:searchable_type => "Survey")
    end

    desc "Clear index for all models"
    task :all => [:job, :run, :client, :well, :formation, :tool, :survey, :rig, :event]
  end
end
