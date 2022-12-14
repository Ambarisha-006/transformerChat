# frozen_string_literal: true

if ENV['datadog-api-key-metrics']
  require 'date'
  require 'dogapi'
  dog = Dogapi::Client.new(ENV['datadog-api-key-metrics'])
  puts 'sending datadog metric'

  require 'aws-sdk-s3'

  client = Aws::S3::Client.new(
    access_key_id: ENV['s3_access_key_id'],
    secret_access_key: ENV['s3_secret_access_key'],
    region: ENV['aws_region']
  )
  objects = client.list_objects(bucket: ENV['s3_bucket_deployments'], prefix: "#{ENV['cf_app']}/#{ENV['cf_space']}").contents
  last_object = objects.last
  build_number = last_object.key.match(/\d+.txt/).to_s[0..-5]
  version = last_object.key.match(/_\d.\d+.\d+_/).to_s[1..-2]

  if version
    number_of_digits = version.gsub('.', '').size
    if version[1] == '.'
      version = version.gsub('.', '').to_f / (10**(number_of_digits - 1))
    elsif version[2] == '.'
      version = version.gsub('.', '').to_f / (10**(number_of_digits - 2))
    end
  end

  puts "Build number: #{build_number}"
  puts "Version: #{version}"
  puts "Deployments counter value: #{objects.size}"
  begin
    dog.emit_point(ENV['datadog-deployments-metric-name'], objects.size, tags: ["environment:#{ENV['environment']}", "app:#{ENV['cf_app']}", "cf_space:#{ENV['cf_space']}"], host: ENV['concourse-host'])
  rescue Net::OpenTimeout
    dog.emit_point(ENV['datadog-metric-name'], objects.size, tags: ["environment:#{ENV['environment']}", "app:#{ENV['cf_app']}", "cf_space:#{ENV['cf_space']}"], host: ENV['concourse-host'])
  end
  begin
    dog.emit_point(ENV['datadog-build-metric-name'], build_number, tags: ["environment:#{ENV['environment']}", "app:#{ENV['cf_app']}", "cf_space:#{ENV['cf_space']}"], host: ENV['concourse-host'])
    dog.emit_point(ENV['datadog-version-metric-name'], version, tags: ["environment:#{ENV['environment']}", "app:#{ENV['cf_app']}", "cf_space:#{ENV['cf_space']}"], host: ENV['concourse-host']) if version
  rescue Net::OpenTimeout
    dog.emit_point(ENV['datadog-build-metric-name'], build_number, tags: ["environment:#{ENV['environment']}", "app:#{ENV['cf_app']}", "cf_space:#{ENV['cf_space']}"], host: ENV['concourse-host'])
    dog.emit_point(ENV['datadog-version-metric-name'], version, tags: ["environment:#{ENV['environment']}", "app:#{ENV['cf_app']}", "cf_space:#{ENV['cf_space']}"], host: ENV['concourse-host']) if version
  end
end
