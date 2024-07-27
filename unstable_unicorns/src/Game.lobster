import Card
import Player
import GameState


class Game:
    g: GameState = GameState{}

    def get_game_state():
        return g

    // send a card in your Stable to the discard pile
    def sacrifice_submenu(cards:[Card], amount:int):
        return [Card{"","","",baby_unicorn,GRN,CardAction{this}}]

    // send a card from another player's Stable to the discard pile
    def destroy_submenu(cards: [Card], amount:int, players:[Player]):
        return [Card{"","","",baby_unicorn,GRN,CardAction{this}}], g.get_players()[0]
    
    // send card from your hand to the discard pile
    def discard_submenu():
        pass()
    
    def ask_to_activate()->bool:
        return false

    def start():
        pass()

class Cli: Game
    def chooser<T>(arr:[T], amount:int)->[T]:
        var input_arr = []
        //TODO: make help input format printout
        while 1:
            let msg = concat_string(map(arr)c,i:"[{i+1}] {c.name}", "\n")
            let input = get_line(msg+"\nselect {amount} items from 1-{arr.len}: ")
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
    def destroy_submenu(cards: [Card], amount:int, players:[Player]):
        print("{REDHB}-- destroy: --{reset}")
        let chosen_player: Player = choose_player(players)
        return choose_cards(chosen_player.stable(), amount), chosen_player

    // send card from your hand to the discard pile
    def discard_submenu():
        pass()

    // when something has the choice to be activated or not 
    //EX: When this card enters your Stable, you may DESTROY a Unicorn. If you do, SACRIFICE this card.
    def ask_to_activate()->bool:
        let option = get_line("activate this card? [y] [n]: ")//TODO: yes if just pressed enter
        return option == "y" or option == "Y"

    
    private def beginning_phase():
        g.update_phase(beginning_phase)
        let option = get_line("activate a card? [y] [N]: ")
        if option == "y" or option == "Y":
            let card = choose_card(g.current_players_turn.stable())
            card.activate(g.current_players_turn)//TODO: repeat question if card cant be activated

    private def draw_phase():
        g.update_phase(draw_phase)

    private def action_phase():
        g.update_phase(action_phase)
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
                // check for win condition

    private def end_phase():
        g.update_phase(end_phase)
        g.end_phase_cleanup()
        //TODO: remove hands(maybe for everyone) if too big

    def start():
        g.init()
        while 1:
            print("\n{CYNB}==== round {g.num_rounds()} ==={reset}\n")
            print(g.fmt())
            print("{YEL}==============================  beginning phase  ============================={reset}")
            beginning_phase()
            print("{YEL}==============================    draw phase    =============================={reset}")
            g.draw(g.current_players_turn)
            draw_phase()
            print("{YEL}==============================    action phase  =============================={reset}")
            action_phase()
            print("{YEL}============================== end of turn phase ============================={reset}")
            end_phase()
            // check if hand is too big

            g.update_player_turn()



class Gui: Game
