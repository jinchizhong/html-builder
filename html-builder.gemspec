VERSION = "0.1"
GIT_BASE = "1d74ef9cc16abbc4056e75313c9c92919b5d952a"


require 'find'
libs = Find.find('lib').to_a.grep /\.rb$/

logs = `git log #{GIT_BASE}..HEAD --pretty=oneline`.lines.to_a.length
version = VERSION + "." + logs.to_s

Gem::Specification.new do |s|
  s.name = 'html-builder'
  s.version = version
  s.summary = 'Html builder'
  s.description = 'A powerful html builder'
  s.author = "Chizhong Jin"
  s.email = "jinchizhong@kingsoft.com"
  s.files = libs
  s.homepage = 'http://github.com/jinchizhong/html-builder'
  s.license = 'BSD'
end
