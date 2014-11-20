require 'fog/wunderlist'

module WunderList

  class TaskManager
    attr_reader :tasks, :task_index

    def initialize(username, password)
      @wunderlist = Fog::Tasks.new( provider: "Wunderlist",
                                wunderlist_username: username,
                                wunderlist_password: password)
      @tasks = @wunderlist.tasks.map{|t| Task.new(t)}
      @task_index = index_tasks
      @lists = get_list_ids
    end

    def index_tasks
      @tasks.each_with_object({}) do |task, task_index|
        task_index[task.title] = task
      end
    end

    def get_list_ids
      @wunderlist.lists.each_with_object({}) do |list, id_lookup|
        id_lookup[list.title] = list.id
      end
    end

    def create_task(issue)
      @wunderlist.tasks.create(
        title: issue.title,
        list_id: @lists['Work'],
        due_date: issue.due_date,
        note: issue.description
      )
    end

    def complete_task(task, date)
      task.completed_at = date
      task.save
    end

    def update_task(task, issue)
      if issue.inactive?
        return task.destroy
      end
      task.due_date = issue.due_date
      task.note = issue.description
      task.starred = true
      task.save
    end

  end

  class Task < SimpleDelegator

    def completed?
      !completed_at.nil?
    end

    def change_date
      DateTime.parse updated_at.to_s
    end

  end

end
