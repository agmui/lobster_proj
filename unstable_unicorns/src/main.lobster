import std
import vec
import color
import gl
import imgui

import from "../../"
// import utils
import Game
import parser

set_print_depth(3)

def init_mock_players():
    let p0 = Player{"player 0"}
    let p1 = Player{"player 1"}
    return [p0,p1]

def main():
    print("== start game ==")
    let game: Game = Cli{}// Gui{}
    let p: parser = mock_parser{}
    let game_state = game.get_game_state()
    game_state.add_players(init_mock_players())
    let nursery, deck = p.parse_file(game)
    game_state.init_cards(nursery, deck)
    game.start()

main()