// import std

//Regular text
let BLK = "\x1B[0;30m"
let RED = "\x1B[0;31m"
let GRN = "\x1B[0;32m"
let YEL = "\x1B[0;33m"
let BLU = "\x1B[0;34m"
let MAG = "\x1B[0;35m"
let CYN = "\x1B[0;36m"
let WHT = "\x1B[0;37m"

//Regular bold text
let BBLK = "\x1B[1;30m"
let BRED = "\x1B[1;31m"
let BGRN = "\x1B[1;32m"
let BYEL = "\x1B[1;33m"
let BBLU = "\x1B[1;34m"
let BMAG = "\x1B[1;35m"
let BCYN = "\x1B[1;36m"
let BWHT = "\x1B[1;37m"

//Regular underline text
let UBLK = "\x1B[4;30m"
let URED = "\x1B[4;31m"
let UGRN = "\x1B[4;32m"
let UYEL = "\x1B[4;33m"
let UBLU = "\x1B[4;34m"
let UMAG = "\x1B[4;35m"
let UCYN = "\x1B[4;36m"
let UWHT = "\x1B[4;37m"

//Regular background
let BLKB = "\x1B[40m"
let REDB = "\x1B[41m"
let GRNB = "\x1B[42m"
let YELB = "\x1B[43m"
let BLUB = "\x1B[44m"
let MAGB = "\x1B[45m"
let CYNB = "\x1B[46m"
let WHTB = "\x1B[47m"

//High intensty background 
let BLKHB = "\x1B[0;100m"
let REDHB = "\x1B[0;101m"
let GRNHB = "\x1B[0;102m"
let YELHB = "\x1B[0;103m"
let BLUHB = "\x1B[0;104m"
let MAGHB = "\x1B[0;105m"
let CYNHB = "\x1B[0;106m"
let WHTHB = "\x1B[0;107m"

//High intensty text
let HBLK = "\x1B[0;90m"
let HRED = "\x1B[0;91m"
let HGRN = "\x1B[0;92m"
let HYEL = "\x1B[0;93m"
let HBLU = "\x1B[0;94m"
let HMAG = "\x1B[0;95m"
let HCYN = "\x1B[0;96m"
let HWHT = "\x1B[0;97m"

//Bold high intensity text
let BHBLK = "\x1B[1;90m"
let BHRED = "\x1B[1;91m"
let BHGRN = "\x1B[1;92m"
let BHYEL = "\x1B[1;93m"
let BHBLU = "\x1B[1;94m"
let BHMAG = "\x1B[1;95m"
let BHCYN = "\x1B[1;96m"
let BHWHT = "\x1B[1;97m"

//Reset
let reset = "\x1B[0m"
let CRESET = "\x1B[0m"
let COLOR_RESET = "\x1B[0m"

def color_grid():
    for(11)i: 
        let r = map(10)j:
            let n = 10*i+j
            if n>108: 
                ""
            elif n < 10:
                "\u001B[{n}m  {n}\u001B"
            else:
                "\u001B[{n}m {n}\u001B"
        r.concat_string("")
        .print()

    // (map(255)i: reset+i+" \x1B["+i+"mhi")
    //     .concat_string(" ")
    //     .print()
    // print("")
    // for(5)j:
    //     (map(255)i: reset+i+" \x1B[{j};"+i+"mhi")
    //         .concat_string(" ")
    //         .print()
    //     print("")

// color_grid()


def strip_ansi_code(s):
    var str = s
    var start = 0 
    while (start = find_string(str, "\x1B")) != -1:
        if start == -1:
            break
        let end = find_string(str, "m", start)
        str = substring(str, 0, start)+substring(str, end+1, str.length-end-1)
    return str
