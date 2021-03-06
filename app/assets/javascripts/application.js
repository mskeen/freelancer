//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require freelancer
//= require Chart
//= require_tree .

(function($, undefined) {
  doc_ready = function() {
    freelancer.setup();
    var $body = $("body")
    var controller = $body.data("controller").replace(/\//g, "_");
    var action = $body.data("action");

    var activeController = freelancer[controller];

    if (activeController !== undefined) {
      if ($.isFunction(activeController.init)) {
        activeController.init();
      }

      if ($.isFunction(activeController[action])) {
        activeController[action]();
      }
    }

  };

  $(document).ready(doc_ready);
  $(document).on('page:load', doc_ready)

})(jQuery);
