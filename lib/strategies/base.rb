module Intrigue
module Strategy
  class Base

    def self.inherited(base)
      StrategyFactory.register(base)
    end

    ###
    ### Helper method for starting a task run
    ###
    def self.start_recursive_task(old_task_result, task_name, entity, options=[])
      project = old_task_result.project

      # check to see if it already exists
      existing_task_result = Intrigue::Model::TaskResult.all(:project => project).first(:name => "#{task_name} on #{entity.name}")

      if existing_task_result
        puts "Skipping!!!! Task result (#{task_name} on #{entity.name}) already exists."
        return existing_task_result
      else
        puts "Starting recursive task: #{task_name} on #{entity.name}"
      end

      # Create the task result, and associate our entity and options
      new_task_result = Intrigue::Model::TaskResult.create({
          :scan_result => old_task_result.scan_result,
          :name => "#{task_name} on #{entity.name}",
          :task_name => task_name,
          :options => options,
          :base_entity => entity,
          :logger => Intrigue::Model::Logger.create(:project => project),
          :project => project,
          :handlers => old_task_result.handlers,
          :depth => old_task_result.depth - 1
      })
      new_task_result.start

    new_task_result
    end

end
end
end
