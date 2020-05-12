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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.65.0"
  spec.add_dependency "activesupport"
end
