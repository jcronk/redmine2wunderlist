require 'rest_client'
require 'json'
require 'set'

module Redmine

  class IssueList
    attr_reader :issues, :issues_index

    def initialize(key, uri)
      @access_key = key
      @redmine_url = uri
      @issues = create_issues_list
      @issues_index = create_issues_index
    end

    def create_issues_index
      @issues.each_with_object({}) do |issue, index|
        index[issue.title] = issue
      end
    end
    def create_issues_list
      get_all_issues.map do |issue|
        create_issue(issue)
      end
    end

    def create_issue(issue_data)
      Issue.new do |i|
        i.title = "[#{issue_data['id']}] #{issue_data['subject']}"
        i.description = issue_data['description']
        i.due_date = issue_data.include?('due_date') ? DateTime.parse(issue_data['due_date']) : nil
        i.change_date = DateTime.parse(issue_data['updated_on'])
      end
    end
    # NOTE: This isn't great and should probably be replaced by a fetch by
    # date range.  But Redmine's max limit is 100, and it ignores anything higher
    # so in order to get 1000 issues, you need 10 separate calls, which is slow as hell.
    def get_all_issues
      issues = []
      begin
        next_issues = get_issues_data(offset: issues.count)
        issues << next_issues
      end until issues.flatten.count >= 1000
      issues.flatten
    end

    def get_issues_data(opts={offset: 0})
      response = RestClient.get "#{@redmine_url}/issues.json",
        params: { key: @access_key, assigned_to_id: '8', limit: '100', status_id: '*' }.merge(opts)
      resp_data = JSON.parse response
      resp_data['issues']
    end

    def update_issue

    end

  end

  class Issue
    attr_accessor :title, :description, :due_date, :change_date, :status, :status_id

    ACTIVE_STATUSES = ["New", "In Progress", "Reopened"].to_set

    def initialize
      yield self
    end

    def active?
      ACTIVE_STATUSES.include? status
    end

    def inactive?
      !active?
    end

  end
end
