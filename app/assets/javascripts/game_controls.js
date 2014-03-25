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
    $(".progress-bar").delay(wait * (idx - 1)).css('background-color', progressColor($('#announcer' + idx).text()) );
//    $('#announcer' + idx).delay(wait * (idx - 1)).fadeIn(wait);
//    $('#announcer' + idx).delay(0).fadeOut(0);
  }

    $('#winbox').delay(wait * 4).fadeIn(wait);
    $('#hash').delay(wait * 4).fadeIn(wait);

    setTimeout(updateBalance, wait * 5);
  });

  function progressColor(antxt) {
    rv = "blue";
    if (antxt.indexOf("you WIN!") > 0){
      rv = "light Green";
    
    } else if (antxt.indexOf("you LOSE!") > 0){
      rv = "Orange";
    } else if (antxt.indexOf("you LOSE 3x!") > 0){
          rv = "Red";
    } else if (antxt.indexOf("5x JACKPOT!") > 0){
            rv = "Green";
    } else if (antxt.indexOf("WIN DOUBLE!") > 0){
            rv = "Green";
    } else if (antxt.indexOf("determines winner") > 0){
            rv = "BLUE";
    } else if (antxt.indexOf("LOSE DOUBLE!") > 0){
            rv = "Red";
    } 
    return rv;
  };

  // Annouce progress
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
