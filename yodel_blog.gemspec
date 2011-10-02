# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yodel_blog"

Gem::Specification.new do |s|
  s.name        = 'yodel_blog'
  s.version     = YodelBlog::VERSION
  s.authors     = ['Will Cannings']
  s.email       = ['me@willcannings.com']
  s.homepage    = 'http://yodelcms.com'
  s.summary     = 'Yodel CMS Blog Extension'
  s.description = 'Yodel CMS Blog Extension'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
