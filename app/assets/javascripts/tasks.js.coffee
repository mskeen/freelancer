class TasksController

  select_task_category: (category_id) ->
    $(".selected-category").removeClass("selected-category")
    $("#task-category-" + category_id).addClass("selected-category")

  setup_click_handler: ->
    $(".task-category").on "click", ->
      freelancer.tasks.select_task_category($(@).data("id"))

  init: ->

  index: ->
    @.setup_click_handler()
    if first_category_id = $(".task-category").first().data("id")
      @.select_task_category(first_category_id)

this.freelancer.tasks = new TasksController
