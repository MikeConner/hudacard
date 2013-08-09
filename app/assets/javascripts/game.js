// Min/Max in mBTC
var minimum_bet = 1;
var maximum_bet = 1;

$(document).ready(function() {
	$("#bookmarkme").click(function() {
		var url = $('bookmark_url').val();
		
	    if (window.sidebar) { // Mozilla Firefox Bookmark
	        window.sidebar.addPanel(url, document.title,"");
	    } 
	    else if( /*@cc_on!@*/false) { // IE Favorite
	        window.external.AddFavorite(url, document.title); 
	    } 
	    else if(window.opera && window.print) { // Opera Hotlist
	        this.title = document.title;
	        return true;
	    } 
	    else { // webkit - safari/chrome
	        //alert('Press ' + (navigator.userAgent.toLowerCase().indexOf('mac') != - 1 ? 'Command/Cmd' : 'CTRL') + ' + D to bookmark the link.');
	        alert('Right click on the link to bookmark it.');
	    }
	});

  minimum_bet = parseInt($('#min_bet').val());
  maximum_bet = parseInt($('#max_bet').val());

  $('#plusMilli').click(function() {
    var origVal = parseInt($('#game_bet').val());
    var newval = origVal + minimum_bet;
    $('#game_bet').val(newval);
    checkRange();
  });
  
  $('#plusMilliTen').click(function() {
    var origVal = parseInt($('#game_bet').val());
    var newval = origVal + minimum_bet * 10;
    $('#game_bet').val(newval);
    checkRange();
  });
  
  $('#red').click(function() {
    cr = checkRange();
  });

  $('#black').click(function() {
    cr = checkRange();
  });
  
  $('#minusMilli').click(function() {
    var origVal = parseInt($('#game_bet').val());
    var newval = origVal - minimum_bet;
    $('#game_bet').val(newval);
    checkRange();
  });
  
  $('#minusMilliTen').click(function() {
    var origVal = parseInt($('#game_bet').val());
    var newval = origVal - minimum_bet * 10;
    $('#game_bet').val(newval);
    checkRange();
  });

  function checkRange () {
    var rv = 0;
    if (isNaN(parseInt($('#game_bet').val()) )) {
        alert('Invalid bet; setting to minimum bet');
        $('#game_bet').val(minimum_bet);
    }
    else {
      var origVal = parseInt($('#game_bet').val());
      if (origVal > maximum_bet) {
        alert('Too much! Setting to maximum bet');
        $('#game_bet').val(maximum_bet);
      }
      else if (origVal < minimum_bet) {
        alert('Below minimum! Setting to minimum bet')
        $('#game_bet').val(minimum_bet);
      }
	}
  }
});
