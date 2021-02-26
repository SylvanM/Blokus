//
//  main.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/22/21.
//

import Foundation


let sylvan = Human()
let another = Engine()

let result = Game.runGame(playerOne: Engine(), playerTwo: Engine())

print("Result: \(result)")
