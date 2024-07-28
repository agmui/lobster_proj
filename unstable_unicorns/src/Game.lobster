import Card
import Player
import GameState


class Game:
    g: GameState = GameState{}

    def get_game_state():
        return g
    
    def choose_cards(cards: [Card], amount:int)->[Card]://):
        return []

    def choose_card(cards: [Card])->Card:
        return choose_cards(cards, 1)[0]

    def choose_players(players:[Player], amount:int)->[Player]://):
        return []

    def choose_player(players:[Player])->Player:
        return choose_players(players, 1)[0]

    // send a card in your Stable to the discard pile
    def sacrifice_submenu(cards:[Card], amount:int):
        return [Card{"","","",baby_unicorn,GRN,CardAction{this}}]

    // send a card from another player's Stable to the discard pile
    def destroy_submenu(players:[Player], amount:int, card_filter):
        return [Card{"","","",baby_unicorn,GRN,CardAction{this}}], g.get_players()[0]
    
    // send card from your hand to the discard pile
    def discard_submenu(cards:[Card],amount:int):
        return [Card{"","","",baby_unicorn,GRN,CardAction{this}}]

    def peek_top_deck(amount:int)->[Card]: //):
        return []
    
    def ask_to_activate()->bool:
        return false

    def start():
        pass()

class Cli: Game
    def chooser<T>(arr:[T], amount:int)->[T]:
        if arr.len == 0:
            print("\n{BMAG}no options to choose from!!{reset}\n")
            return []
        var input_arr = []
        //TODO: make help input format printout
        while 1:
            let display_name = fn c: if type_string(c) == "Player": c.name else: c.fmt()
            let msg = concat_string(map(arr)c,i:"[{i+1}] {display_name(c)}", "\n")
            let init_input = get_line(msg+"\nselect {amount} items from 1-{arr.len}: ")
            let input = if init_input == "": "1" else: init_input
            print("")
            let raw_input,res = parse_data(typeof [int], "["+input+"]")
            guard raw_input != nil and res == nil:// TODO: use guard idk
                error("\"{input}\" is not valid\n")
            input_arr = raw_input

            guard input_arr.len == amount:
                if input_arr.len < amount:
                    error("selected too little")
                else:
                    print(input_arr, input_arr.len, amount)
                    print(input_arr.len == amount)
                    error("selected too much")
            if  all(map(input_arr)i:in_range(i, arr.len, 1)):
                break
            error("\"{input}\" is not valid\n")
        return map(input_arr)n: arr[n-1]

    def choose_cards(cards: [Card], amount:int)->[Card]://):
        print("{BLKB}- choose {amount} card -{reset}")
        return chooser(cards,amount)
    
    def choose_card(cards: [Card])->Card:
        return choose_cards(cards, 1)[0]
    
    def choose_players(players:[Player], amount:int)->[Player]://):
        print("- choose {amount} player -")
        return chooser(players, amount)
    
    def choose_player(players:[Player])->Player:
        return choose_players(players, 1)[0]

    // send a card in your Stable to the discard pile
    def sacrifice_submenu(cards:[Card], amount:int):
        print("{MAGHB}-- sacrifice: --{reset}")
        return choose_cards(cards, amount)

    // send a card from another player's Stable to the discard pile
    def destroy_submenu(players:[Player], amount:int, card_filter):
        print("{REDHB}-- destroy: --{reset}")
        let chosen_player: Player = choose_player(players)
        return choose_cards(card_filter(chosen_player.stable()), amount), chosen_player

    // send card from your hand to the discard pile
    def discard_submenu(cards:[Card], amount:int):
        print("{BLUB}-- discard: --{reset}")
        return choose_cards(cards, amount)

    // when something has the choice to be activated or not 
    //EX: When this card enters your Stable, you may DESTROY a Unicorn. If you do, SACRIFICE this card.
    def ask_to_activate()->bool:
        let option = get_line("activate this card? [y] [n]: ")//TODO: yes if just pressed enter
        return option == "y" or option == "Y"

    def peek_top_deck(amount:int)->[Card]://):
        print("- deck peak -")
        let cards = map(amount)i:g.get_deck()[i]
        (map(cards)c: c.fmt())
                .concat_string(" | ")
                .print()
        print("-------------\n")
        return cards
    
    private def beginning_phase():
        let option = get_line("activate a card? [y] [N]: ")
        if option == "y" or option == "Y":
            let card = choose_card(g.current_players_turn.stable())//TODO: filter out cards cant cant be activated?
            card.activate(g.current_players_turn)//TODO: repeat question if card cant be activated

    private def draw_phase():
        g.draw(g.current_players_turn)

    private def action_phase():
        var action = ""
        while action != "d" and action != "p":
            action = get_line("draw [d], play [p]: ")
            print("")
            if action != "d" and action != "p":
                error("{action} not recognized\n")
            if action=="d":
                g.draw(g.current_players_turn) //TODO: rename player.draw()
            else:
                let card = choose_card(g.current_players_turn.hand())
                g.current_players_turn
                    .use(card)
                    .play(g.current_players_turn)

    private def end_phase():
        g.end_phase_cleanup()
        //TODO: remove hands(maybe for everyone) if too big
    
    def advance_phase():
        let og_phase = g.get_phase()
        switch g.get_phase():
            case beginning_phase:
                print("\n{CYNB}==== round {g.num_rounds()} ==={reset}\n")
                print(g.deck_info())
                print(g.fmt())
                print("{YEL}==============================  beginning phase  ============================={reset}")
                beginning_phase()
                print(g.fmt())
                if g.get_phase() == og_phase: g.update_phase(draw_phase) // checks if phase has been tampered with.
            case draw_phase:
                print("{YEL}==============================    draw phase    =============================={reset}")
                draw_phase()
                if g.get_phase() == og_phase: g.update_phase(action_phase)// TODO: this is jank
            case action_phase:
                print("{YEL}==============================    action phase  =============================={reset}")
                action_phase()
                print(g.fmt())
                if g.get_phase() == og_phase: g.update_phase(end_phase)
            case end_phase:
                print("{YEL}============================== end of turn phase ============================={reset}")
                end_phase()
                // check if hand is too big
                g.update_player_turn()
                if g.get_phase() == og_phase: g.update_phase(beginning_phase)

    def start():
        g.init()
        forever():
            advance_phase()



class Gui: Game
