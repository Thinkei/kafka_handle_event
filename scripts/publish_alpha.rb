require 'json'

manifest_file_path = File.expand_path('../../app.json', __FILE__)
manifest_file = File.read(manifest_file_path)
app = JSON.parse(manifest_file)
gemspec_file_name = Dir.glob("./*.gemspec")[0].split('/')[-1]

commit = ARGV[0]
version = "#{app['version']}.pre.#{commit[0..7]}"

# Update back manifest file
app['version'] = version
File.open(manifest_file_path, "w") do |f|
  f.write(JSON.pretty_generate(app))
end

exec("gem build #{gemspec_file_name} && curl -F \"package=@#{app['name']}-#{app['version']}.gem\" \"https://#{ENV['GEMFURY_TOKEN']}@push.fury.io/#{ENV['GEMFURY_PACKAGE']}/\"")
