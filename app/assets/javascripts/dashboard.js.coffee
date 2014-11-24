class DashboardController
  init: ->
    console.log "Dashboard init"

  index: ->
    console.log "Dashboard index"

this.Freelancer.dashboard = new DashboardController
