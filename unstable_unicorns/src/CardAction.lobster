import const

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

def filter_format(cards:[Card])->[Card] //):
let do_noting:filter_format = fn(cards:[Card])->[Card]:cards 

class CardAction:
    game: Game

    def get_game():
        return game

    def return_to_hand():
        pass()
    
    def trade():
        pass()
    
    def move(move_from:[Card],move_to:[Card], card:Card):
        move_from.remove_obj(card)
        move_to.push(card)

    // all sacrifice calls must go though here bc of the broadcast
    def sacrifice(caller:Player,chosen_cards:[Card]):
        print("sac", chosen_cards[0].fmt())
        caller.remove_stable(chosen_cards)//TODO: maybe replace bot 2 calls with move
        game.get_game_state().discard(chosen_cards)// use move for destroy() also
        for(chosen_cards)c:
            c.leave_stable(caller)

        game.get_game_state().sacrifice_pub.publish(card_event{caller, chosen_cards})
        print(game.get_game_state().fmt())

    def destroy(caller:Player, chosen_cards:[Card], chosen_player:Player):
        chosen_player.remove_stable(chosen_cards)
        game.get_game_state().discard(chosen_cards)
        for(chosen_cards)c:
            c.leave_stable(chosen_player)

        game.get_game_state().destroy_pub.publish(card_event{caller, chosen_cards})

    def discard(caller:Player, chosen_cards:[Card]):
        caller.discard(chosen_cards)
        game.get_game_state().discard(chosen_cards)


    def sacrifice_menu(caller:Player, amount:int=1)://util function
        sacrifice_menu(caller, caller.stable(), amount)

    // send a card in your Sable to the discard pile
    def sacrifice_menu(caller:Player, cards:[Card], amount:int=1):
        let chosen_cards = game.sacrifice_submenu(cards, amount)
        //TODO: on empty stable condition

        sacrifice(caller, chosen_cards)

    // send a card from another player's Stable to the discard pile
    def destroy_menu(caller:Player, amount:int=1, card_filter:filter_format=do_noting)->void:
        let players = game.get_game_state().get_players().copy()
        players.remove_obj(caller)
        let chosen_cards, chosen_player = game.destroy_submenu(players, amount, card_filter)

        destroy(caller, chosen_cards, chosen_player)

    
    // send card from your hand to the discard pile
    def discard_menu(caller, cards:[Card], amount:int=1):
        let chosen_cards = game.discard_submenu(cards, amount)

        discard(caller, chosen_cards)
    
    def sacrifice_or_destroy(caller:Player, amount:int=1, card_filter:filter_format=do_noting):
        let players = game.get_game_state().get_players().copy()
        let chosen_cards, chosen_player = game.destroy_submenu(players, amount, card_filter)
        if(chosen_player == caller):
            sacrifice(caller,chosen_cards)
        else:
            destroy(caller, chosen_cards, chosen_player)

    def ask_to_activate(card_name)->bool:
        return game.ask_to_activate(card_name)
    
    def choose_card(cards):
        return game.choose_card(cards)

    def choice_selection(choices:[string])->int:
        return game.choice_selection(choices)
    
    def peek_top_deck(amount:int)->[Card]: //):
        return game.peek_top_deck(amount)
    
    def search_deck(amount:int, card_filter:filter_format)->[Card]: //):
        return game.search_deck(amount, card_filter)

