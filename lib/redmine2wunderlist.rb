require "redmine2wunderlist/version"
require "redmine2wunderlist/redmine"
require "redmine2wunderlist/wunderlist"

module Redmine2wunderlist

  class TaskSynchronizer

    def initialize(config)
      @wl = WunderList::TaskManager.new(config.fetch(:wl_user), config.fetch(:wl_password))
      @rm = Redmine::IssueList.new(config.fetch(:redmine_api_key), config.fetch(:redmine_uri))
    end

    def add_new_issues
      new_issues.each do |issue|
        @wl.create_task(issue)
      end
    end

    def update_issues
      match_issues.each do |(issue, task)|
        next unless issue.change_date > task.change_date
        @wl.update_task(task, issue)
      end
    end

    def new_issues
      active = @rm.issues.select(&:active?)
      new = active.reject{|issue| @wl.task_index.include?(issue.title)}
    end

    def match_issues
      @wl.tasks.each_with_object([]) do |task, matched|
        matched << [ @rm.issues_index[task.title], task ] if @rm.issues_index.include?(task.title)
      end
    end

    def synchronize
      add_new_issues
      update_issues
    end

  end
end
