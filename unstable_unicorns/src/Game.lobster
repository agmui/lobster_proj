import Card
import Player
import GameState


class Game:
    g: GameState = GameState{}

    def get_game_state():
        return g

    // send a card in your Stable to the discard pile
    def sacrifice_submenu(caller: Player):
        pass()

    // send a card from another player's Stable to the discard pile
    def destroy_submenu(caller: Player):
        pass()
    
    // send card from your hand to the discard pile
    def discard_submenu():
        pass()

    def start():
        pass()

class Cli: Game
    def chooser<T>(arr:[T])->T:
        var index = 0
        while not in_range(index, length(arr), 1):
            let msg = concat_string(map(arr)c,i:"[{i+1}] {c.name}", "\n")
            let input = get_line(msg+"\nselect # from 1-{arr.len}: ")
            print("")
            index = string_to_int(input)
            if not in_range(index, length(arr), 1):
                error("\"{input}\" is not valid\n")
        return arr[index-1]

    def choose_card(cards: [Card])->Card:
        print("{BLKB}- choose a card -{reset}")
        return chooser(cards)
    
    def choose_player(players:[Player])->Player:
        print("choose a player")
        return chooser(players)
    // send a card in your Stable to the discard pile
    def sacrifice_submenu(caller: Player):
        print("{MAGHB}- sacrifice: -{reset}")

    // send a card from another player's Stable to the discard pile
    def destroy_submenu(caller: Player):
        print("{REDHB}- destroy: -{reset}")
        let players: [Player] = g.get_players().copy()
        players.remove_obj(caller)
        let chosen_player: Player = choose_player(players)
        let chosen_card: Card = choose_card(chosen_player.stable())
        chosen_player.destroy(chosen_card)
    
    // send card from your hand to the discard pile
    def discard_submenu():
        pass()
    
    private def beginning_phase():
        // get_line(":")
        pass()
    private def draw_phase():
        pass()
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
                // check for win condition

    private def end_phase():
        pass()


    def start():
        g.init()
        while 1:
            print("\n{CYNB}==== round {g.num_rounds()} ==={reset}\n")
            print(g.fmt())
            print("{YEL}==============================  beginning phase  =============================={reset}")
            beginning_phase()
            print("{YEL}==============================    draw phase    =============================={reset}")
            g.draw(g.current_players_turn)
            draw_phase()
            print("{YEL}==============================    action phase  =============================={reset}")
            action_phase()
            print("{YEL}============================== end of turn phase =============================={reset}")
            end_phase()
            // check if hand is too big

            g.update_player_turn()



class Gui: Game
