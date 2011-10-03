Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end

Rake.application.remove_task("db:test:prepare")

task "db:test:prepare" do
  p "Stubbed out db:test:prepare"
end
