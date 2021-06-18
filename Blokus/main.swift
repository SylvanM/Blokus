//
//  main.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/22/21.
//

import Foundation


//let alice = Engine()
//let bob   = Engine()
//
//let game = Game()
//
//for i in 0..<3 {
//    game.reset()
//    _ = game.runGame(playerOne: alice, playerTwo: bob, verbose: false)
//    game.gameBoard.write(toPath: "/Users/sylvanm/board_\(i)")
//    print("Wrote board \(i)")
//}

let thing: UInt64 = 0b1100111110001000101101001110111000001000000110000000000000000000
let part1: UInt64 = 0b11001111100010001011010011101110
let part2: UInt64 = 0b00001000000110000000000000000000
let fully: UInt64 = part1 << 32 + part2
print(thing == fully)

print(thing)

//func gameState(playerOne: UInt64, playerTwo: UInt64) -> Int {
//    if playerOne.nonzeroBitCount > playerTwo.nonzeroBitCount {
//        return 1
//    } else if playerOne.nonzeroBitCount < playerTwo.nonzeroBitCount {
//        return 2
//    } else {
//        return 0
//    }
//}
//
//print(gameState(playerOne: 27233256695211385, playerTwo: 17514830415214936064))
