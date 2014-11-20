#!/usr/bin/env ruby
require 'redmine2wunderlist'
require 'yaml'


def conf_from_file
  config_filename = File.join(Dir.home, '.r2wl_conf')
  if File.exist? config_filename
    YAML.load_file config_filename
  end
end

@conf = conf_from_file.merge({ wl_user: ENV['WL_USER'], wl_password: ENV['WL_PASSWORD']})

Redmine2wunderlist::TaskSynchronizer.new(@conf).synchronize

