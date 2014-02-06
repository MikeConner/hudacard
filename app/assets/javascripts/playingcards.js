function changeCard( rank ) {
var RANKS = {
    A : 'ace',
    2: 'two',
    3: 'three',
    4: 'four',
    5: 'five',
    6: 'six',
    7: 'seven',
    8: 'eight',
    9: 'nine',
    10: 'ten',
    J: 'jack',
    Q: 'queen',
    K: 'king',
    JK: '',
  };
  return RANKS[rank];


};


function drawCard(target, rank, suit, width) {
  var RANKS = {
    ace: 'A',
    two: '2',
    three: '3',
    four: '4',
    five: '5',
    six: '6',
    seven: '7',
    eight: '8',
    nine: '9',
    ten: '10',
    jack: 'J',
    queen: 'Q',
    king: 'K',
    joker: 'JK'
  };

  var SUITS = {
    club: '&clubs;',
    diamond: '&diams;',
    spade: '&spades;',
    heart: '&hearts;'
  };

  var spans = new Array();
    
  spans.push('<div class="corner top"><span class="number">' + RANKS[rank] + '</span><span>' + SUITS[suit] + '</span></div>');

  if (rank == 'ace') {
    spans.push('<span class="suit middle_center">' + SUITS[suit] + '</span>');
  }

  else if ((rank == 'two') || (rank == 'three')) {
    spans.push('<span class="suit top_center">' + SUITS[suit] + '</span>');

    if (rank == 'three') {
      spans.push('<span class="suit middle_center">' + SUITS[suit] + '</span>');
    }

    spans.push('<span class="suit bottom_center">' + SUITS[suit] + '</span>');
  }

  else if ((rank == 'four') || (rank == 'five') || (rank == 'six') || (rank == 'seven') || (rank == 'eight')  || (rank == 'nine') || (rank == 'ten')) {
    spans.push('<span class="suit top_left">' + SUITS[suit] + '</span>');
    spans.push('<span class="suit top_right">' + SUITS[suit] + '</span>');

    if (rank == 'five') {
      spans.push('<span class="suit middle_center">' + SUITS[suit] + '</span>');
    }

    else if ((rank == 'six') || (rank == 'seven') || (rank == 'eight')) {
      spans.push('<span class="suit middle_left">' + SUITS[suit] + '</span>');

      if ((rank == 'seven') || (rank == 'eight')) {
        spans.push('<span class="suit middle_top">' + SUITS[suit] + '</span>');

        if (rank == 'eight') {
          spans.push('<span class="suit middle_bottom">' + SUITS[suit] + '</span>');
        }
      }

      spans.push('<span class="suit middle_right">' + SUITS[suit] + '</span>');
    }

    else if ((rank == 'nine') || (rank == 'ten')) {
      spans.push('<span class="suit middle_top_left">' + SUITS[suit] + '</span>');
      spans.push('<span class="suit middle_top_right">' + SUITS[suit] + '</span>');

      if (rank == 'nine') {
        spans.push('<span class="suit middle_bottom">' + SUITS[suit] + '</span>');
      }

      else if (rank == 'ten') {
        spans.push('<span class="suit middle_top_center">' + SUITS[suit] + '</span>');
        spans.push('<span class="suit middle_bottom_center">' + SUITS[suit] + '</span>');
      }

      spans.push('<span class="suit middle_bottom_left">' + SUITS[suit] + '</span>');
      spans.push('<span class="suit middle_bottom_right">' + SUITS[suit] + '</span>');
    }

    spans.push('<span class="suit bottom_left">' + SUITS[suit] + '</span>');
    spans.push('<span class="suit bottom_right">' + SUITS[suit] + '</span>');
  }

  else if (rank == 'jack') {
    spans.push('<span class="face middle_center"><img src="/img/faces/face-jack-' + suit + '.png"></span>');
  }

  else if (rank == 'queen') {
    spans.push('<span class="face middle_center"><img src="/img/faces/face-queen-' + suit + '.png"></span>');
  }

  else if (rank == 'king') {
    spans.push('<span class="face middle_center"><img src="/img/faces/face-king-' + suit + '.png"></span>');
  }

  else if (rank == 'joker') {
    spans.push('<span class="face middle_center"><img src="/img/faces/face-joker.png"></span>');
  }

  spans.push('<div class="corner bottom"><span class="number">' + RANKS[rank] + '</span><span>' + SUITS[suit] + '</span></div>');

  if (width != null) {
    target.css({
      'width': width,
      'font-size': width * 12.5 / 200
    });
  }

  target.addClass('card'); target.html('<div class="card-' + rank + ' ' + suit + '">' + spans.join("\n") + '</div>');
}
