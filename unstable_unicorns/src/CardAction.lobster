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
let do_nothing:filter_format = fn(cards:[Card])->[Card]:cards 

/*
useful functions:
* shuffle discard back into deck 
* some "every other player" or every player must do x
* look at other players hand and choose
// * return to hand?(stable -> hand) (Temporal Paradox)
// * choose cards from discard (Nightmare's Conjuring, Kittencorn Burglar)
* player to the left func? (mery-go-round)
// * choose from other players hand
* would be destroyed (unicorn bribe, BlackKnightUnicorn)
*/
class CardAction:
    game: Game

    def get_game():
        return game

    def return_card(chosen_player, chosen_cards):
        chosen_player.return_to_hand(chosen_cards)
    
    def trade():
        pass()
    
    //TODO: decide if folowing functions should go into GameState class
    def move(move_from:[Card],move_to:[Card], card:Card):
        //TODO: card arrs are private so this func cant exist
        //FIXME: for card Hex player hand must only be mutated though discard function
        // note: then move should only be used 
        // when not using the conventional actions(sacrifice, destroy)
        // bc it has noting to setoff/trip?
        move_from.remove_obj(card)
        move_to.push(card)
    
    def shuffle_into_deck(card:Card):
        game.get_game_state().shuffle_into_deck(card)
    
    def steal(caller:Player, chosen_player:Player, chosen_card:Card):
        steal(caller,chosen_player,chosen_card)

    // take from any players stable into your stable
    def steal(caller:Player, chosen_player:Player, chosen_cards:[Card]):
        chosen_player.remove_stable(chosen_cards)
        for(chosen_cards)card:
            caller.add_stable(card)
            card.enter_stable(caller)
        

    def sacrifice(caller:Player,chosen_card:Card):
        sacrifice(caller, [chosen_card])

    // send a card in your Sable to the discard pile
    def sacrifice(caller:Player,chosen_cards:[Card]):
        // Note:all sacrifice calls must go though here bc of the broadcast
        caller.remove_stable(chosen_cards)
        game.get_game_state().discard(chosen_cards)// use move for destroy() also
        for(chosen_cards)c:
            c.sac_or_destroy(caller)

        game.get_game_state().sacrifice_pub.publish(card_event{caller, chosen_cards})

    // send a card from another player's Stable to the discard pile
    def destroy(caller:Player, chosen_player:Player, chosen_cards:[Card]):
        chosen_player.remove_stable(chosen_cards)
        game.get_game_state().discard(chosen_cards)
        for(chosen_cards)c:
            c.sac_or_destroy(chosen_player)

        game.get_game_state().destroy_pub.publish(card_event{caller, chosen_cards})

    def discard(caller:Player, chosen_cards:[Card]):
        caller.discard(chosen_cards)
        game.get_game_state().discard(chosen_cards)


    def return_card_menu(caller:Player, amount:int=1,card_filter:filter_format=do_nothing):
        let players = game.get_game_state().get_players().copy()
        players.remove_obj(caller)
        let chosen_cards, chosen_player = game.return_submenu(players, amount, card_filter)
        return_card(chosen_player, chosen_cards)
    
    def sacrifice_menu(caller:Player, amount:int=1)://util function
        sacrifice_menu(caller, caller.stable(), amount)

    def sacrifice_menu(caller:Player, cards:[Card], amount:int=1):
        let chosen_cards = game.sacrifice_submenu(cards, amount)
        //TODO: on empty/imposable stable condition

        sacrifice(caller, chosen_cards)

    def destroy_menu(caller:Player, amount:int=1, card_filter:filter_format=do_nothing)->void:
        let players = game.get_game_state().get_players().copy()
        players.remove_obj(caller)
        let chosen_cards, chosen_player = game.destroy_submenu(players, amount, card_filter)

        destroy(caller, chosen_player, chosen_cards)

    
    // send card from your hand to the discard pile
    def discard_menu(caller, cards:[Card], amount:int=1):
        let chosen_cards = game.discard_submenu(cards, amount)

        discard(caller, chosen_cards)
    
    def sacrifice_or_destroy(caller:Player, amount:int=1, card_filter:filter_format=do_nothing):
        let players = game.get_game_state().get_players().copy()
        let chosen_cards, chosen_player = game.destroy_submenu(players, amount, card_filter)
        if(chosen_player == caller):
            sacrifice(caller,chosen_cards)
        else:
            destroy(caller, chosen_player, chosen_cards)
    
    def steal_menu(caller:Player, amount:int=1,card_filter:filter_format=do_nothing):
        let players = game.get_game_state().get_players.copy()
        players.remove_obj(caller)

        // let chosen_player = get_game().choose_player(players)
        // let chosen_card = get_game().choose_card(chosen_player.stable())
        let chosen_cards, chosen_player = game.steal_submenu(players,amount,card_filter) 
        steal(caller, chosen_player, chosen_cards)
        return chosen_cards, chosen_player

    def choose_from_hand(caller:Player, can_peek:bool=true, amount:int=1):
        let players = game.get_game_state().get_players().copy()
        players.remove_obj(caller)

        let chosen_card, chosen_player = game.take_from_hand_submenu(players, can_peek, amount)
        chosen_player.taken_from_hand(chosen_card)
        return chosen_card

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
    
    def search_discard(amount:int, card_filter:filter_format=do_nothing)->[Card]: //):
        let chosen_card = game.discard_choose(amount, card_filter)
        game.get_game_state().remove_from_discard(chosen_card)
        return chosen_card

