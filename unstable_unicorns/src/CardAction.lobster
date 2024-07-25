class Game//:

// class Game
// class Player//:

// R: return (Stable>Hand)
// T: trade
// M: move
// D: Discard
// Uni: unicorn
// Chos: choose (assumed one unless specified)
// Up/Dow: upgrade/ Downgrade
// BBUni: baby unicorn
// opp: opponate
// #: arbitrary amount
// S: sacrifice
// Dis: Discard pile
// [start]: begging of turn
// [enter]: when card enters stable
// [S] [D]: condition of if sacrificed or destroyed activate
// look: look at top # of cards in deck or dis
// May: player has option to do or not do action
// Phase: adds or takes a phase
// F: forced action


class CardAction:
    game: Game

    def return_to_hand():
        pass()
    
    def trade():
        pass()
    
    def move():
        pass()

    // send a card in your Sable to the discard pile
    def sacrifice(caller):
        game.sacrifice_submenu(caller)

    // send a card from another player's Stable to the discard pile
    def destroy(caller):
        game.destroy_submenu(caller)
    
    // send card from your hand to the discard pile
    def discard():
        pass()
    
