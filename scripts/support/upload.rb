#!/usr/bin/env ruby

require 'aws-sdk'

def die(mess); $stderr.puts(mess); exit; end

bucket, file, key = ARGV.take(3)
die('usage: upload.rb bucket filename keyname') if bucket.nil? || file.nil? || key.nil?

path = Pathname.new(file)
die("No file found at '#{file}'") if !path.exist?

s3 = Aws::S3::Client.new(region: 'us-east-1')
print "Writing #{file} to #{bucket}/#{key}..."
s3.put_object(
  acl: 'public-read',
  bucket: bucket,
  key: key,
  body: File.open(path)
)
puts "done"
