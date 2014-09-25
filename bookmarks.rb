require "haml"
require "yaml"
# TODO: Create Web-Feed (RSS or Atom).

# TODO: Let option file be specified via commandline parameter.
config = YAML.load_file "config.yaml"
# Provide fallbacks for all configuration variables.
# TODO: Configuration: template, html output file
date_format = "%F %H:%M"
directory = "~/.bookmarks" # TODO: This is not tested yet.

if config["date_format"]
  date_format = config["date_format"]
end

# TODO: Check whether the directory exists and is accessable.
if config["bookmarks_directory"]
  directory = config["bookmarks_directory"]
end

bookmarks = []
Dir.glob("#{directory}/*.yaml") do |bookmark_file|
  bookmark = YAML.load_file bookmark_file
  bookmark["pretty_date"] = bookmark["created_at"].strftime date_format
  bookmark["tag_list"] = bookmark["tags"].join ", "
  bookmarks << bookmark
end
# TODO: Sort bookmarks by date.

template = File.read "bookmarks.haml"
haml_engine = Haml::Engine.new template
output = haml_engine.render Object.new, :bookmarks => bookmarks
# TODO: Write to output file.
puts output

