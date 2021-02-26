//
//  Player.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/23/21.
//

import Foundation

/**
 * Description of a player in a game of Blokus
 */
protocol Player {
    
    // MARK: Functions
    
    /**
     * Given a subjective view of the board (with this player as player 1) return a move which the player determines to be the best move
     *
     * **Note:** It is the player's responsibility to make a *legal* move. Making sure the move is legal should be handled in this function as
     * whatever is returned will be assumed to be legal.
     *
     * - Parameters:
     *      - board: A subjective `BitBoard` with player 1 being this player
     *
     * - Returns: The decided move by the player
     */
    func move(subjectiveBoard board: BitBoard) -> Move
    
}
