#!/usr/bin/env ruby

require 'aws-sdk'

file_name = ARGV[0]
if file_name.nil?
  $stderr.puts 'usage: upload.rb file [prefix] [bucket]'
  exit
end

prefix = ARGV[1] || 'packages/cedar'
bucket_name = ARGV[2] || 'uvize-buildpack'
key_name = "#{prefix}/#{file_name}"
path = Pathname.new(file_name)

if !path.exist?
  $stderr.puts "No file found at '#{file_name}'"
  exit
end

s3 = Aws::S3::Client.new(region: 'us-east-1')
puts "Writing #{file_name} to #{bucket_name}/#{key_name}..."
s3.put_object(
  bucket: bucket_name,
  acl: 'public-read',
  key: key_name,
  body: File.open(path)
)
puts "...done"
