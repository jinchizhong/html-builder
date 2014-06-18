require 'find'
libs = Find.find('lib').to_a.grep /\.rb$/

Gem::Specification.new do |s|
  s.name = 'html-builder'
  s.version = '0.0.2'
  s.summary = 'Html builder'
  s.description = 'A powerful html builder'
  s.author = "Chizhong Jin"
  s.email = "jinchizhong@kingsoft.com"
  s.files = libs
  s.homepage = 'http://github.com/jinchizhong/html-builder'
  s.license = 'BSD'
end
