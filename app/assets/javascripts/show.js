/*
var COUNT_SPEED = 1000; // milliseconds

(function($) {
    $.fn.countTo = function(options) {
        // merge the default plugin settings with the custom options
        options = $.extend({}, $.fn.countTo.defaults, options || {});

        // how many times to update the value, and how much to increment the value on each update
        var loops = Math.ceil(options.speed / options.refreshInterval),
            increment = (options.to - options.from) / loops;

        return $(this).each(function() {
            var _this = this,
                loopCount = 0,
                value = options.from,
                interval = setInterval(updateTimer, options.refreshInterval);

            function updateTimer() {
                value += increment;
                loopCount++;
                $(_this).html(value.toFixed(options.decimals));

                if (typeof(options.onUpdate) == 'function') {
                    options.onUpdate.call(_this, value);
                }

                if (loopCount >= loops) {
                    clearInterval(interval);
                    value = options.to;

                    if (typeof(options.onComplete) == 'function') {
                        options.onComplete.call(_this, value);
                    }
                }
            }
        });
    };
    $.fn.countTo.defaults = {
        from: 0,  // the number the element should start at
        to: 100,  // the number the element should end at
        speed: COUNT_SPEED,  // how long it should take to count between the target numbers
        refreshInterval: 100,  // how often the element should be updated
        decimals: 0,  // the number of decimal places to show
        onUpdate: null,  // callback method for every time the element is updated,
        onComplete: null,  // callback method for when the element finishes updating
    };
})(jQuery);

$(document).ready(function() {
  var wait = 1000;

  // Result box WIN/LOSE
  $('#winbox').hide()
  // Fronts of the cards
  $('cardfront').hide();
  
  // Mid-game notes
  $('.midgame').hide();

  // Show first card
  $('#seq1').show();
  $('#card1').hide();
  $('#announcer').delay(wait).fadeOut(0);
  for (var idx = 2; idx <= 5; idx++) {
  	$('#seq' + idx).delay(wait * (idx - 1)).fadeIn(wait);
  	$('#card' + idx).delay(wait * (idx - 1)).fadeOut(0);
  }

  for (var idx = 2; idx <= 4; idx++) {
    $('#announcer' + idx).delay(wait * (idx - 1)).fadeIn(wait);
    $('#announcer' + idx).delay(0).fadeOut(0);  	
  }
  
  
  $('#winbox').delay(wait * 4).fadeIn(wait);
  
  updateBalance(); 
});

function updateBalance() {
  var btcBal = parseFloat($('#btcbalance').text());

  var satBal = parseInt($('#satoshibalance').text());
  var satPay = parseInt($('#payout').val());
  var btcBalNew = (satPay + satBal) * SATOSHI

  if (isNaN(satPay)){
    // Is this an error?
  }
  else {
      setTimeout(function(){
          $('#btcbalance').text(btcBalNew + " mBTC");
          if (satPay < 0){
            $('#satoshibalance').text(satBal+satPay);
          }
          else {
            $('#satoshibalance').countTo({
                        from: satBal,
                        to: satBal+satPay,
                        speed: BALANCE_SPEED,
                        refreshInterval: 50,
                        onComplete: function(value) { console.debug(this);}
                      });
          }
      }, wait*5);
   }
}
*/