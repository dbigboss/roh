class TodoController < ApplicationController
  def index
    @todos = Todo.all
  end

  def new
    @todo = Todo.new
  end

  def show
    @todo = Todo.find(params["id"])
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      @success = "Todo successfully created"
    else
      render :new
    end
  end

  def edit
    @todo = Todo.find(params["id"])
  end

  def update
    @todo = Todo.find(params["id"])
    @todo.update(todo_params)
  end

  def destroy
    @todo = Todo.find(params["id"])
    @todo.destroy
  end

  private

  def todo_params
    params["todo"].symbolize_keys
  end
end
