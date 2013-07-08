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
        speed: 1000,  // how long it should take to count between the target numbers
        refreshInterval: 100,  // how often the element should be updated
        decimals: 0,  // the number of decimal places to show
        onUpdate: null,  // callback method for every time the element is updated,
        onComplete: null,  // callback method for when the element finishes updating
    };
})(jQuery);


$(document).ready(function(){
  // initialize tooltip for advisors




  var wait = 1000;

  $('#winbox').hide()
  $('#seq0').hide();
  $('#seq1').hide();
  $('#seq2').hide();
  $('#seq3').hide();
  $('#seq4').hide();
  $('#winning').hide();
  $('#hash').hide();

  $('#seq0').fadeIn(wait*0);
  $('#card1').hide();
  $('#seq1').delay(wait*0).fadeIn(wait);
  $('#card2').hide();

  $('#seq2').delay(wait*2).fadeIn(wait);
  $('#card3').delay(wait*2).fadeOut(0);

  $('#seq3').delay(wait*3).fadeIn(wait);
  $('#card4').delay(wait*3).fadeOut(0);

  $('#seq4').delay(wait*4).fadeIn(wait);
  $('#card5').delay(wait*4).fadeOut(0);

  $('#winning').delay(wait*5).fadeIn(wait);
  $('#hash').delay(wait*5).fadeIn(wait);
  $('#winbox').delay(wait*5).fadeIn(wait);
  updateBalance();


  $('#plusMili').click(function() {
    var origVal = parseFloat($('#bet').val());
    var newval = origVal + 0.001;
    $('#bet').val(newval.toFixed(3));
    checkRange();
  });
  $('#plusMiliTen').click(function() {
    var origVal = parseFloat($('#bet').val());
    var newval = origVal + 0.01;
    $('#bet').val(newval.toFixed(3));
    checkRange();

  });
  $('#red').click(function() {
    cr = checkRange();
  });

  $('#black').click(function() {
    cr = checkRange();
  });
  $('#minusMili').click(function() {
    var origVal = parseFloat($('#bet').val());
    var newval = origVal - 0.001;
    $('#bet').val(newval.toFixed(3));
    checkRange();
  });
  $('#minusMiliTen').click(function() {
    var origVal = parseFloat($('#bet').val());
    var newval = origVal - 0.01;
    $('#bet').val(newval.toFixed(3));
    checkRange();

  });

  function updateBalance()
  {
  var btcBal = parseFloat($('#btcbalance').text());

  var satBal = parseInt($('#satoshibalance').text());
  var satPay = parseInt($('#payout').val());
  var btcBalNew = (satPay + satBal)/100000000

  

  if (isNaN(satPay)){


  }
else{

      setTimeout(function(){
          $('#btcbalance').text(btcBalNew);
    //      $('#satoshibalance').text(satBal+satPay);
    $('#satoshibalance').countTo({
                from: satBal,
                to: satBal+satPay,
                speed: 3000,
                refreshInterval: 50,
                onComplete: function(value) {
                    console.debug(this);
                }});
      }, wait*5);
    }
  }


  function checkRange ()
  {
    var rv = 0;
    if (isNaN(parseFloat($('#bet').val()) )) {
      var newval = 0.001;
      $('#bet').val(newval.toFixed(3));

    }
    var origVal = parseFloat($('#bet').val());
    if (origVal > 0.05)
    {
      var newval = 0.05;
      $('#bet').val(newval.toFixed(3));
      rv = 2;
    }
    else {
      if (origVal<0.001) {
        var newval = 0.001;
        $('#bet').val(newval.toFixed(3));
        rv = 1;
      }
    }

  }
});