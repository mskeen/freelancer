class LogMonitorsController

  setup_click_handler: ->
    $("body").on "click", "#monitor-ips .ip-row", ->
      $("#monitor-ips tr.selected").removeClass("selected")
      $(@).addClass("selected")
      $.ajax "/log_ips/#{$(@).data("ip-id")}"

  refresh: ->
    console.log("timeout")
    status = $("#monitor-status").data("status")
    if status == "pending" || status == "processing"
      console.log("reloading")
      selected_id = $("#monitor-ips tr.selected").attr("id")
      mon_id = $("#monitor-status").data("id")
      site_id = $("#monitor-status").data("site-id")
      $.ajax("/sites/#{site_id}/log_monitors/#{mon_id}.js").done ->
        if selected_id
          $("##{selected_id}").addClass("selected")
      setTimeout @.freelancer.log_monitors.refresh, 3000

  init: ->

  show: ->
    @.setup_click_handler()
    setTimeout @.refresh, 3000

this.freelancer.log_monitors = new LogMonitorsController
