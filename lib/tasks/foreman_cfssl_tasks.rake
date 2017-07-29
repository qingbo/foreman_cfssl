require 'rake/testtask'

# Tasks
namespace :foreman_cfssl do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanCfssl'
  Rake::TestTask.new(:foreman_cfssl) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_cfssl do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_cfssl) do |task|
        task.patterns = ["#{ForemanCfssl::Engine.root}/app/**/*.rb",
                         "#{ForemanCfssl::Engine.root}/lib/**/*.rb",
                         "#{ForemanCfssl::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_cfssl'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_cfssl']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_cfssl', 'foreman_cfssl:rubocop']
end
