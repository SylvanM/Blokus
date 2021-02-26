//
//  Engine.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/25/21.
//

import Foundation

/**
 * A class for analyzing and playing Blokus
 */
class Engine: Player {
    
    func move(subjectiveBoard board: BitBoard) -> Move {
        
        // this AI is pretty simple. all it knows is that more tiles is good, so place the biggest tiles first.
        var legalMoves = Engine.getAllMoves(byPlayer: 1, on: board)
        
        let largestSize = legalMoves.map { getPieceArea(piece: $0.piece) }.max()
        
        legalMoves.removeAll(where: { (move) -> Bool in
            getPieceArea(piece: move.piece) < largestSize!
        })
        
        return legalMoves.randomElement()!
        
    }
    
}
