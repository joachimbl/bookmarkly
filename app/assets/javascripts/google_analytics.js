/**
* Function that tracks a click on an outbound link in Google Analytics.
* This function takes a valid URL string as an argument, and uses that URL string
* as the event label.
*/
var trackOutboundLink = function(url) {
 ga('send', 'event', 'outbound', 'click', url);
}

$(document).on('click', '[data-outbound-link]', function(event) {
  var url = $(this).attr('href');
  trackOutboundLink(url);
});
