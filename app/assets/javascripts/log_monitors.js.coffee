class LogMonitorsController

  setup_click_handler: ->
    $("#monitor-ips").on "click", ".ip-row", ->
      console.log("ip #{$(@).data("ip-id")}")

  init: ->
    console.log("log_monitors init")

  show: ->
    console.log("log_monitors show")
    @.setup_click_handler()

this.freelancer.log_monitors = new LogMonitorsController
