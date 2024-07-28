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

def filter_format(cards:[Card])->[Card]
let do_noting:filter_format = fn(cards:[Card])->[Card]:cards

class CardAction:
    game: Game

    def get_game():
        return game

    def return_to_hand():
        pass()
    
    def trade():
        pass()
    
    def move(move_from:[Card],move_to:[Card], card:Card): //):
        move_from.remove_obj(card)
        move_to.push(card)

    def sacrifice(caller:Player, amount:int=1)://util function
        sacrifice(caller, caller.stable(), amount)

    // send a card in your Sable to the discard pile
    def sacrifice(caller:Player, cards:[Card], amount:int=1):
        let chosen_cards = game.sacrifice_submenu(cards, amount)
        caller.remove_stable(chosen_cards)
        game.get_game_state().discard(chosen_cards)
        for(chosen_cards)c:
            c.on_deletion(caller)

    // send a card from another player's Stable to the discard pile
    def destroy(caller:Player, amount:int=1, card_filter:filter_format=do_noting)->void:
        let players = game.get_game_state().get_players().copy()
        players.remove_obj(caller)
        let chosen_cards, chosen_player = game.destroy_submenu(players, amount, card_filter)
        chosen_player.remove_stable(chosen_cards)
        game.get_game_state().discard(chosen_cards)
        for(chosen_cards)c:
            c.on_deletion(chosen_player)
    
    // send card from your hand to the discard pile
    def discard(caller, cards:[Card], amount:int=1):
        let chosen_cards = game.discard_submenu(cards, amount)[0]
        caller.discard(chosen_cards)
        game.get_game_state().discard(chosen_cards)
    
    def sacrifice_or_destroy(caller:Player, amount:int=1, card_filter:filter_format=do_noting):
        let players = game.get_game_state().get_players().copy()
        let chosen_cards, chosen_player = game.destroy_submenu(players, amount, card_filter)
        chosen_player.remove_stable(chosen_cards)
        game.get_game_state().discard(chosen_cards)
        for(chosen_cards)c:
            c.on_deletion(caller)
    
    def ask_to_activate()->bool:
        return game.ask_to_activate()
    
    def choice_selection(choices:[string])->int:
        return game.choice_selection(choices)
    
    def peek_top_deck(amount:int)->[Card]: //):
        return game.peek_top_deck(amount)
    
    def search_deck(amount:int, card_filter:filter_format)->[Card]: //):
        return game.search_deck(amount, card_filter)

