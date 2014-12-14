this.freelancer ?= {

  spinner_setup: ->
    $(document).on 'ajax:before ajaxStart page:fetch', ->
      $(".spinner").show()

    $(document).on 'ajax:complete ajaxComplete page:change', ->
      $(".spinner").hide()


  setup: ->
    this.spinner_setup()
}
