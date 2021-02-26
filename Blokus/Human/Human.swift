//
//  Human.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/23/21.
//

import Foundation

/**
 * A human player
 */
class Human: Player {
    
    // MARK: Functions
    
    func move(subjectiveBoard board: BitBoard) -> Move {
        var move = Move(piece: .singleTile, orientation: 0, coords: (x: 0, y: 0))
        
        print("HUMAN, it is your turn. Here is the state of the board:")
        board.printBoard(perspective: 1)
        
        do {
            print("What piece do you want to place?")
            // show piece options
            print("Enter piece identifier: ", terminator: "")
            let pieceIdentifier = Int(readLine()!)!
            move.piece = Piece(rawValue: pieceIdentifier)!
            
            print("Enter orientation: ", terminator: "")
            move.orientation = Int(readLine()!)!
            
            print("Enter x coord: ", terminator: "")
            move.coords.x = Int(readLine()!)!
            print("Enter y coord: ", terminator: "")
            move.coords.y = Int(readLine()!)!
            
            _ = try Game.verify(move: move, fromPlayer: 1, on: board)
        } catch {
            // just do this recursively until the user doesn't make an illegal move.
            print("ERROR: You made an illegal move: \(error). Let's try that again.")
            return self.move(subjectiveBoard: board)
        }
        
        return move
    }
    
}
