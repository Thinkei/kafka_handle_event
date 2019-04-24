# coding: utf-8
require 'json'

app_path = File.expand_path('../app.json', __FILE__)
app = JSON.parse(File.read(app_path))

Gem::Specification.new do |spec|
  spec.name          = app['name']
  spec.version       = app['version']
  spec.authors       = ['Tuan Mai']
  spec.email         = ['tuan.mai@employmenthero.com']

  spec.summary       = 'Handle kafka event'
  spec.description   = 'Helper to handle kafka event easier'
  spec.homepage      = 'https://employmenthero.com/'
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rspec", "~> 3.0"
end
