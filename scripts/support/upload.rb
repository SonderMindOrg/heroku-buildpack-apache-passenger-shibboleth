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

s3 = AWS::S3.new
bucket = s3.buckets[bucket_name]
obj = bucket.objects[key_name]

puts "Writing #{file_name} to #{bucket_name}/#{key_name}..."
obj.write(path, acl: :public_read)
puts "...done"
