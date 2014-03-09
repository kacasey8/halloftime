json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :user_id, :project_id, :hours, :minutes
  json.url task_url(task, format: :json)
end
