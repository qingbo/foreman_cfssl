require File.expand_path('../lib/foreman_cfssl/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'foreman_cfssl'
  s.version     = ForemanCfssl::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['Qingbo Zhou']
#  s.email       = ['TODO: Your email']
  s.homepage    = 'http://thinlight.org/'
  s.summary     = 'Foreman CFSSL plugin'
  # also update locale/gemspec.rb
  s.description = 'A Foreman plugin that uses CFSSL to generate certificates'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
