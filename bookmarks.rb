#!/usr/bin/env ruby
require "haml"
require "yaml"
# TODO: Create Web-Feed (RSS or Atom).

def expand_home_path (path)
  if path =~ /^~/
    return path.gsub(/^~/, Dir.home)
  end
end

# TODO: Let option file be specified via commandline parameter.
config = YAML.load_file(expand_home_path "~/.bookmarksrc")
# Provide fallbacks for all configuration variables.
# TODO: Configuration: template, rss?, rss file
date_format = "%F %H:%M"
directory = "~/.bookmarks"
output_file = "~/.bookmarks.html"
template_file = "~/.bookmarks/template.haml"

if config["date_format"]
  date_format = config["date_format"]
end

# TODO: Check whether the directory exists and is accessable.
if config["directory"]
  directory = config["directory"]
end
directory = expand_home_path directory

# TODO: Check whether the file exists and is accessable.
if config["output_file"]
  output_file = config["output_file"]
end
output_file = expand_home_path output_file

# TODO: Check whether the file exists and is accessable.
if config["template_file"]
  template_file = config["template_file"]
end
template_file = expand_home_path template_file

bookmarks = []
Dir.glob("#{directory}/*.yaml") do |bookmark_file|
  bookmark = YAML.load_file bookmark_file
  bookmark["pretty_date"] = bookmark["created_at"].strftime date_format
  bookmark["tag_list"] = bookmark["tags"].join ", "
  bookmarks << bookmark
end

# Sort bookmarks by date. Newer bookmarks at the top of the page.
bookmarks.sort! do |a,b|
  # XXX: I'm not completly sure why this works ...
  b["created_at"] <=> a["created_at"]
end

template = File.read template_file
haml_engine = Haml::Engine.new template
output = haml_engine.render Object.new, :bookmarks => bookmarks

File.open(output_file, "w") do |file|
  file.write output
end

