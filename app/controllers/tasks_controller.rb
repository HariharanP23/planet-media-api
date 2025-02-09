class TasksController < ApplicationController
  before_action :find_task, only: [ :show, :update, :destroy ]
  def index
    @pagy, @tasks = pagy(@current_user.tasks, limit: 20)

    render json: {
      tasks: ActiveModel::Serializer::CollectionSerializer.new(@tasks, serializer: TaskSerializer),
      pagination: {
        current_page: @pagy.page,
        total_pages: @pagy.pages,
        total_count: @pagy.count,
        next_page: @pagy.next,
        prev_page: @pagy.prev,
        items_per_page: @pagy.vars[:limit]
      }
    }
  end

  def show
    render json: {
      task: TaskSerializer.new(@task)
    }
  end

  def create
    @task = @current_user.tasks.new(task_params)

    if @task.save!
      render json: {
        task: TaskSerializer.new(@task)
      }, status: :created
    else
      render_error @task.errors.full_messages, 422
    end
  rescue ActiveRecord::RecordInvalid => e
    render_error e.record.errors.full_messages, 422
  end

  def update
    if @task.update!(task_params)
      render json: {
        task: TaskSerializer.new(@task)
      }
    else
      render_error @task.errors.full_messages, 422
    end
  rescue ActiveRecord::RecordInvalid => e
    render_error e.record.errors.full_messages, 422
  end

  def destroy
    if @task.destroy!
      render json: { message: "Task deleted successfully" }
    else
      render_error @task.errors.full_messages, 422
    end
  end

private

  def find_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error "Task not found", 404
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
