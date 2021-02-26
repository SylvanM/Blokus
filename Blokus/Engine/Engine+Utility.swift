//
//  Engine+Utility.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/25/21.
//

import Foundation

/**
 * Includes utility functions, like finding all possible moves
 */
extension Engine {
    
    // MARK: Class Utility Functions
    
    /**
     * Finds all the possible legal moves by a player on a board
     */
    class func getAllMoves(byPlayer player: Int, on board: BitBoard) -> [Move] {
        
        // a common case is that a player is out of pieces. Instead of looping through every case to
        // discover that, we can check for it here to save time.
        let playerInventory = player == 1 ? board.playerOnePiecesLeft : board.playerTwoPiecesLeft
        
        if playerInventory == 0 {
            return []
        }
        
        var allMoves: [Move] = []
        
        // we are going to use a super inefficient and gross way of doing this for the time being.
        // when I think of a prettier way, I'll do that
        
        // loop through all pieces, orientations, and positions
        
        for piece in Piece.allCases {
            for orientation in 0..<4 {
                for x in 0..<8 {
                    for y in 0..<8 {
                        
                        let move = Move(piece: piece, orientation: orientation, coords: (x: x, y: y))
                        
                        // if the move is legal, add it to the array
                        do {
                            _ = try Game.verify(move: move, fromPlayer: player, on: board)
                            allMoves.append(move)
                        } catch {
                            // if there is an error, just don't add the move to the array!
                        }
                        
                    }
                }
            }
        }
        
        return allMoves
        
    }
    
    
}
