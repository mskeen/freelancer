class TasksController

  select_task_category: (category_id) ->
    $(".active").removeClass("active")
    $("#task-category-" + category_id).addClass("active")

  setup_click_handler: ->
    $("#task-categories-list").on "click", "li.task-category", ->
      freelancer.tasks.select_task_category($(@).data("id"))

  init: ->

  index: ->
    @.setup_click_handler()
    if first_category_id = $(".task-category").first().data("id")
      @.select_task_category(first_category_id)

this.freelancer.tasks = new TasksController
