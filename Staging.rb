#!/usr/bin/env ruby

require "digest"
require "zlib"
require "fileutils"

RGIT_DIRECTORY = ".rgit".freeze
OBJECTS_DIRECTORY = "#{RGIT_DIRECTORY}/objects".freeze
INDEX_PATH = "#{RGIT_DIRECTORY}/index"

if !Dir.exists? RGIT_DIRECTORY
  $stderr.puts "Not an RGit project"
  exit 1
end

path = ARGV.first

if path.nil?
  $stderr.puts "No path specified"
  exit 1
end

file_contents = File.read(path)
sha = Digest::SHA1.hexdigest file_contents
blob = Zlib::Deflate.deflate file_contents
object_directory = "#{OBJECTS_DIRECTORY}/#{sha[0..1]}"
FileUtils.mkdir_p object_directory
blob_path = "#{object_directory}/#{sha[2..-1]}"

File.open(blob_path, "w") do |file|
  file.print blob
end

File.open(INDEX_PATH, "a") do |file|
  file.puts "#{sha} #{path}"
end