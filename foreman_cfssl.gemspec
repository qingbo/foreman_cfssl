require File.expand_path('../lib/foreman_cfssl/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'foreman_cfssl'
  s.version     = ForemanCfssl::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['TODO: Your name']
  s.email       = ['TODO: Your email']
  s.homepage    = 'TODO'
  s.summary     = 'TODO: Summary of ForemanCfssl.'
  # also update locale/gemspec.rb
  s.description = 'TODO: Description of ForemanCfssl.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
