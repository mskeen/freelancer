class LogMonitorsController

  setup_click_handler: ->
    $("#monitor-ips").on "click", ".ip-row", ->
      $("#monitor-ips tr.selected").removeClass("selected")
      $(@).addClass("selected")
      $.ajax "/log_ips/#{$(@).data("ip-id")}"

  init: ->

  show: ->
    @.setup_click_handler()

this.freelancer.log_monitors = new LogMonitorsController
