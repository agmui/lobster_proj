class Game
class Player
class Card
//:

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

    def get_game():
        return game

    def return_to_hand():
        pass()
    
    def trade():
        pass()
    
    def move():
        pass()

    def sacrifice(caller:Player, amount:int=1)://util function
        sacrifice(caller, caller.stable(), amount)

    // send a card in your Sable to the discard pile
    def sacrifice(caller:Player, cards:[Card], amount:int=1):
        let chosen_cards = game.sacrifice_submenu(cards, amount)
        caller.remove_stable(chosen_cards)
        game.get_game_state().discard(chosen_cards)

    def destroy(caller:Player, amount:int=1)://FIXME:
        destroy(caller, caller.stable(), amount)

    // send a card from another player's Stable to the discard pile
    def destroy(caller:Player, cards:[Card], amount:int=1):
        let players = game.get_game_state().get_players().copy()
        players.remove_obj(caller)
        let chosen_cards, chosen_player = game.destroy_submenu(cards, amount, players)
        chosen_player.remove_stable(chosen_cards)
        game.get_game_state().discard(chosen_cards)
    
    // send card from your hand to the discard pile
    def discard():
        pass()
    
    def ask_to_activate():
        return game.ask_to_activate()
