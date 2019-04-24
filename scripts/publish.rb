require 'json'
require 'open3'

manifest_file = File.read(File.expand_path('../../app.json', __FILE__))
app = JSON.parse(manifest_file)
gemspec_file_name = Dir.glob("./*.gemspec")[0].split('/')[-1]

upload_gem = `gem build #{gemspec_file_name} && curl -F package=@#{app['name']}-#{app['version']}.gem https://#{ENV['GEMFURY_TOKEN']}@push.fury.io/#{ENV['GEMFURY_PACKAGE']}/`
raise "Gem push failed!" if upload_gem.include? "exists"
