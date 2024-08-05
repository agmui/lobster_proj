import dictionary

import Card
import Game
import CardAction

class card_data:
  name: string
  img: string
  text: string
  type: string
  quantity: string
  deck: string

abstract class parser:
    def parse_file(g: Game) -> [Card],[Card]: //):
        return [],[]

/*
useful links:
https://flatbuffers.dev/flatbuffers_guide_tutorial.html
https://github.com/google/flatbuffers/blob/master/samples/monster_generated.lobster
https://github.com/google/flatbuffers/blob/master/tests/lobstertest.lobster
https://github.com/google/flatbuffers/blob/master/lobster/flatbuffers.lobster
https://github.com/google/flatbuffers/blob/master/samples/sample_binary.lobster
https://flatbuffers.dev/flatbuffers_guide_use_lobster.html
https://github.com/google/flatbuffers/blob/master/samples/sample_text.lobster
https://github.com/google/flatbuffers/blob/master/samples/monsterdata.json
*/
class json_parser: parser
    file_name: string = "../data/data_copy.json"

    
    /*
    def convert_data(card: card_data) -> Card:
        let type2enum = dictionary<string,CardType>() // TODO: find number
        type2enum.add("Baby Unicorn", instant)
        type2enum.add("Magic", magic)
        type2enum.add("Upgrade", upgrade)
        type2enum.add("Downgrade", downgrade)
        type2enum.add("Baby Unicorn", baby_unicorn)
        type2enum.add("Basic Unicorn", basic_unicorn)
        type2enum.add("Magical Unicorn", magical_unicorn)
        type2enum.add("Ultimate Unicorn", ultimate_unicorn)

        // let class_name: string = replace_string(card.name, " ", "")
        // let type: CardType = type2enum.get(card.type)

        // let rez = switch class_name:
        //     case "Baby Unicorn (Pink)": nil //UnicornPoison{}
        //     case "Baby Unicorn (Pink)": nil
        //     default: nil //TODO: make black pink error card

        // return rez
        return UnicornPoison{"help", "help", "help", magic, "", }
    */

    def parse_file():
        let json = read_file(file_name)
        if json == nil:
            print("error: file not found")
            assert false

        let str = substring(json, 1, json.length()-2)

        let rez = map(tokenize(str,"\}"," "))s:
                    map(tokenize(s, "\n", " "))a:
                        let i = find_string(a, ":")
                        if(i!=-1):
                            substring(a, i+1, -1)
                        else:
                            ""
        rez.pop()

        let card_arr = map(rez)r:
            let r2 = escape_string(sum(r), "\'", "\\", "")
            parse_data(typeof card_data, "card_data\{ {r2} \}")
            //TODO: just take the first index of r and make that the class/obj name
            // then take the rest as attributes

        map(card_arr)c,i:
            if c != nil:
                convert_data(c)
            else:
                nil
        return [],[]

class mock_parser: parser
    def parse_file(game: Game):
        let cardAction = CardAction{game}

        let bb=BabyUnicorn_Pink{
                "Baby Unicorn (Pink)",
                "Baby_Unicorn_(Pink).png",
                "If this card would be sacrificed, destroyed, or returned to your hand, return it to the Nursery instead.",
                baby_unicorn,
                BBLK,
                cardAction
            }
            
        let bb2=BabyUnicorn_Red{
                "Baby Unicorn (Red)",
                "Baby_Unicorn_(Red).png",
                "If this card would be sacrificed, destroyed, or returned to your hand, return it to the Nursery instead.",
                baby_unicorn,
                RED,
                cardAction
            }

        let poison = UnicornPoison{
                "Unicorn Poison",
                "Unicorn_Poison.png",
                "DESTROY a Unicorn.",
                magic,
                BGRN,
                cardAction
            }
        let tfo = TwoForOne{
            "Two-For-One",
            "Two-For-One.png",
            "SACRIFICE a card, then DESTROY two cards.",
            magic,
            YEL,
            cardAction
        }

        let gtb = GlitterBomb{
            "Glitter Bomb",
            "Glitter_Bomb.png",
            "If this card is in your Stable at the beginning of your turn, you may SACRIFICE a card, then DESTROY a card.",
            upgrade,
            GRN,
            cardAction
        }

        let ucm = UnicornMafia{
            "Unicorn Mafia",
            "Unicorn_Mafia.png",
            """
            If this card is in your Stable at the beginning of your turn,
            you may DISCARD 2 cards.
            If you do, SACRIFICE or DESTROY a card.
            """,
            upgrade,
            BLK,
            cardAction
        }

        let stu = StabbyTheUnicorn{
            "Stabby The Unicorn",
            "Stabby_The_Unicorn.png",
            "If this card is sacrificed or destroyed, you may DESTROY a Unicorn",
            magical_unicorn,
            REDHB,
            cardAction
        }

        let csu = ChainsawUnicorn{
            "Chainsaw Unicorn",
            "Chainsaw_Unicorn.png",
            "When this card enters your Stable, you may SACRIFICE or DESTROY an Upgrade or Downgrade card.",
            magical_unicorn,
            BRED,
            cardAction
        }

        let fst = Foresight{
            "Foresight",
            "Foresight.png",
            """
            If this card is in your Stable at the beginning of your turn,
            you may look at the top 3 cards of the deck. If you do,
            add 1 of them to your hand,
            then shuffle the other 2 back into the deck
            and skip your Draw phase.	
            """,
            upgrade,
            GRNHB,
            cardAction
        }


        let ctc = ControlledChaos{
            "Controlled Chaos",
            "Controlled_Chaos.png",
            """
            If this card is in your Stable at the beginning of your turn,
            you may DISCARD 2 cards. If you do,
            DESTROY a Unicorn card OR search the deck for a Unicorn card and
            add it to your hand. Shuffle the deck.	
            """,
            upgrade,
            BYEL,
            cardAction
        }

        return [
            //== DEBUG ==
            //===========
            bb.copy(), bb2.copy(), bb.copy(), bb2.copy(),
        ],[
            // -- p0 hand --
            BlatantThievery(cardAction),
            TemporalParadox(cardAction),
            UnicornLasso(cardAction),
            poison.copy(),
            //-- p1 hand --
            poison.copy(),
            gtb.copy(),
            stu.copy(),
            tfo.copy(),

            // == adds to p0 stable ==
            BasicUnicornRed(cardAction),
            // ===== adds to discard ==
            BasicUnicornRed(cardAction),
            // ========================
            UnicornAbduction(cardAction),
            NightmaresConjuring(cardAction),
            Hex(cardAction),
            ExtraLife(cardAction),
            csu.copy(),
            KittencornBurglar(cardAction),
            SharkWithAHorn(cardAction),
            ctc.copy(),
            gtb.copy(),
            ucm.copy(),
            Puppicorn(cardAction),
            csu.copy(),
            fst.copy(),
            stu.copy(), 
        ]