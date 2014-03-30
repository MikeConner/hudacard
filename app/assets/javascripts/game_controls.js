var BALANCE_SPEED = 3000;

  $(document).ready(function() {
  var wait = 1000;

  // Result box WIN/LOSE
  $('#winbox').hide()
  $('#hash').hide();

  // Fronts of the cards
  $('cardfront').hide();

  // Mid-game notes
  $('.midgame').hide();

  // Show first card
  $('#seq1').show();
  drawCard($('#seq1'), changeCard($('#value1').val(), $('#suit1').val()), $('#suit1').val(), 160);
  $('#card1').hide();
  $('#announcer').delay(wait).fadeOut(0);
  for (var idx = 2; idx <= 5; idx++) {
    drawCard($('#seq' + idx), changeCard($('#value' + idx).val()), $('#suit'+idx).val(), 160);
    $('#seq' + idx).delay(wait * (idx - 1)).fadeIn(wait);
    $('#card' + idx).delay(wait * (idx - 1)).fadeOut(0);
  }

  for (var idx = 2; idx <= 4; idx++) {
/* 
 * class names for
  NEUTRAL_COLOR = 'neutral-color'
  WINNING_COLOR = 'winning-color'
  JACKPOT_COLOR = 'jackpot-color'
  SMALL_LOSS_COLOR = 'small-loss-color'
  BIG_LOSS_COLOR = 'big-loss-color'
*/  
    // Change class of #bet-progress to reflect progress; class will change background and foreground colors as necessary
    var newClass = $('#progress' + idx).val();
    
    if (idx > 2) {
      var oldClass = $('#progress' + (idx - 1).toString()).val();
      if (oldClass != newClass) {
        setTimeout(removeProgressClass(oldClass, wait * (idx - 1)));      	
      }
    }
    setTimeout(addProgressClass(newClass, wait * (idx - 1)));
    /*
    $("#bet-progress").delay(wait * (idx - 1)).addClass($('#progress' + idx).val());
    if (idx > 2) {
        $("#bet-progress").delay(wait * (idx - 1)).removeClass($('#progress' + (idx - 1).toString()).val());    	
    }*/
//    $(".progress-bar").delay(wait * (idx - 1)).css('background-color', progressColor($('#announcer' + idx).text()) );
//    $('#announcer' + idx).delay(wait * (idx - 1)).fadeIn(wait);
//    $('#announcer' + idx).delay(0).fadeOut(0);
  }

    //$("#bet-progress").delay(wait * 4).removeClass($('#progress4').val());     
    setTimeout(removeProgressClass($('#progress4').val(), wait * 4));  
    setTimeout(displayPayout, wait * 4);
      
    $('#winbox').delay(wait * 4).fadeIn(wait);
    $('#hash').delay(wait * 4).fadeIn(wait);

    setTimeout(updateBalance, wait * 5);
  });
 
  function addProgressClass(className) {
  	$("#bet-progress").addClass(className);
  }
  
  function removeProgressClass(className) {
  	$("#bet-progress").removeClass(className);  	
  }
  
  function displayPayout() {
    //$('#payout-announcer').delay(wait * 4).css('display', 'block');
  	$('#payout-announcer').css('display', 'block');
  }
  // Announce progress
  var progression = 20,
  progress = setInterval(function() {
    $('#progress .progress-text').text(progression + '%');
    $('#progress .progress-bar').css({'width':progression+'%'});
    if(progression == 100) {
        clearInterval(progress);
    } else
        progression += 20;
  }, 800);

  function updateBalance() {
    var satBal = parseInt($('#satoshibalance').text());
    var satPay = parseInt($('#payout').val());
    var btcBalNew = (satPay + satBal) / 100000;

    if (!(isNaN(satPay) || (0 == satBal))) {
        $('#btcbalance').text(btcBalNew + " m฿");
        if (satPay < 0){
          $('#satoshibalance').text(satBal + satPay);
        }
        else {
          $('#satoshibalance').countTo({
                      from: satBal,
                      to: satBal + satPay,
                      speed: BALANCE_SPEED,
                      refreshInterval: 50,
                      onComplete: function(value) { console.debug(this);}
                    });
        }
    }
  }
