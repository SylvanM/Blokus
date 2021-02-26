//
//  Game+Utility.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/23/21.
//

import Foundation

/**
 * Contains helper functions for evaluating the legality of moves
 */
extension Game {
    
    // MARK: Class Functions
    
    /**
     * Get all adjacent tiles to a bitpattern
     */
    class func allAdjacentTiles(to tiles: UInt64) -> UInt64 {
        
        var faceTiles: UInt64 = 0;
        
        // get a bit pattern of all the tiles that are touching the faces of the proposed piece placement
        // do this by looping through every tile. If it is touching a face of the proposed piece tile, flag it.
        for y in 0..<8 {
            for x in 0..<8 {
                
                // if this tile isn't part of the tiles we are searching around, skip it
                if BitBoard.coordsToMask(x, y) & tiles == 0 { continue }
                
                // check faces near this tile
                // don't check the tile if it's outside the game board, so check for that
                
                // these are boolean values which will be later anded with the flag value (which will be 1 or 0)
                let leftEdgeSafe    = (x > 0)
                let rightEdgeSafe   = (x < 7)
                let bottomEdgeSafe  = (y > 0)
                let topEdgeSafe     = (y < 7)
                
                faceTiles |= leftEdgeSafe   ? (BitBoard.coordsToMask(x - 1, y + 0)) : 0
                faceTiles |= rightEdgeSafe  ? (BitBoard.coordsToMask(x + 1, y + 0)) : 0
                faceTiles |= bottomEdgeSafe ? (BitBoard.coordsToMask(x + 0, y - 1)) : 0
                faceTiles |= topEdgeSafe    ? (BitBoard.coordsToMask(x + 0, y + 1)) : 0
                
            }
        }
        
        faceTiles &= ~tiles;
        
        return faceTiles;
        
    }
    
    class func allCornerTiles(to tiles: UInt64) -> UInt64 {
        var cornerTiles: UInt64 = 0;
        
        // get a bit pattern of all the tiles that are touching the faces of the proposed piece placement
        // do this by looping through every tile. If it is touching a face of the proposed piece tile, flag it.
        for y in 0..<8 {
            for x in 0..<8 {
                
                // if this tile isn't part of the tiles we are searching around, skip it
                if BitBoard.coordsToMask(x, y) & tiles == 0 { continue }
                
                // check faces near this tile
                // don't check the tile if it's outside the game board, so check for that
                
                // these are boolean values which will be later anded with the flag value (which will be 1 or 0)
                let leftEdgeSafe    = (x > 0)
                let rightEdgeSafe   = (x < 7)
                let bottomEdgeSafe  = (y > 0)
                let topEdgeSafe     = (y < 7)
                
                cornerTiles |= (leftEdgeSafe    && bottomEdgeSafe)  ? (BitBoard.coordsToMask(x - 1, y - 1)) : 0
                cornerTiles |= (rightEdgeSafe   && bottomEdgeSafe)  ? (BitBoard.coordsToMask(x + 1, y - 1)) : 0
                cornerTiles |= (leftEdgeSafe    && topEdgeSafe)     ? (BitBoard.coordsToMask(x - 1, y + 1)) : 0
                cornerTiles |= (rightEdgeSafe   && topEdgeSafe)     ? (BitBoard.coordsToMask(x + 1, y + 1)) : 0
                
            }
        }
        
        cornerTiles &= ~tiles;
        cornerTiles &= ~allAdjacentTiles(to: tiles)
        
        return cornerTiles;
    }
    
    /**
     * Checks the legality of a move. If legal, it returns the bit pattern of the newly placed tile
     *
     * - Parameters:
     *      - move: The move to check
     *      - player: Which player is making the move (1 or 2)
     *      - board: The board to test the move on
     *
     * - Returns: The bitpattern of the newly placed tile, if legal
     * - Throws: An error regarding the illegality of the moves
     */
    class func verify(move: Move, fromPlayer player: Int, on board: BitBoard) throws -> UInt64 {
        
        let friendlyTiles = player == 1 ? board.playerOneTiles : board.playerTwoTiles
        let enemyTiles    = player == 1 ? board.playerTwoTiles : board.playerOneTiles
        let moveBitPattern = getPieceBitPattern(piece: move.piece, orientation: move.orientation) << ( move.coords.x + (move.coords.y * 8) )
        
        // Make sure the piece is actually in the player's inventory
        if player == 1 {
            if board.playerOnePiecesLeft & (1 << move.piece.rawValue) == 0 {
                throw MoveError.pieceAlreadyUsed
            }
        }
        else {
            if board.playerTwoPiecesLeft & (1 << move.piece.rawValue) == 0 {
                throw MoveError.pieceAlreadyUsed
            }
        }
            
        
        // make sure the piece does indeed fit within the board
        
        let pieceDimensions = getPieceDimensions(piece: move.piece, orientation: move.orientation)
        
        if ( ( move.coords.x + pieceDimensions.width - 1 > 7 ) || ( move.coords.y + pieceDimensions.height - 1 > 7 ) ) {
            throw MoveError.outsideBorder
        }
        
        // make sure their first move is covering a corner tile
        if friendlyTiles == 0 {
            if moveBitPattern & CORNER_TILES == 0 {
                throw MoveError.illegalStart
            } else {
                // make sure it doesn't overlap with opponent
                if moveBitPattern & enemyTiles != 0 {
                    throw MoveError.tileOccupied
                }
                return moveBitPattern
            }
        }
        
        // first make sure that the move does not overlap with any pieces.
        if (moveBitPattern & board.playerOneTiles) + (moveBitPattern & board.playerTwoTiles) != 0 {
            throw MoveError.tileOccupied
        }
        
        // now make sure that the piece ONLY touches the corner of all friendly pieces
        let faceTiles   = allAdjacentTiles(to: moveBitPattern)
        let cornerTiles = allCornerTiles(to: friendlyTiles)
        
        // check that the moveBitpattern DOES overlap with a corner tile, but that it's adjacent tiles do NOT overlap with any friendly squares
        if !( (moveBitPattern & cornerTiles != 0) && (friendlyTiles & faceTiles == 0) ) {
            throw MoveError.invalidLocation
        }
            
        return moveBitPattern
        
    }
    
    /**
     * This executes a given move on a given board. If the move is illegal, it throws the error.
     *
     * - Parameters:
     *      - move: The move to be made
     *      - player: The player making the move
     *      - board: The board on which to make the move
     *
     * - Returns: The new board with the made move
     * - Throws: An error if the move is illegal
     */
    class func makeMove(_ move: Move, by player: Int, on board: BitBoard) throws -> BitBoard {
        
        let bitPattern = try verify(move: move, fromPlayer: player, on: board)
        
        var newBoard = board
        
        if player == 1 {
            newBoard.playerOneTiles |= bitPattern
            newBoard.playerOnePiecesLeft &= ~(1 << move.piece.rawValue)
        } else {
            newBoard.playerTwoTiles |= bitPattern
            newBoard.playerTwoPiecesLeft &= ~(1 << move.piece.rawValue)
        }
        
        return newBoard
        
    }
    
    /**
     * Determines the status of the game given a board
     */
    class func gameStatus(for board: BitBoard) -> GameStatus {
        
        if Engine.getAllMoves(byPlayer: 1, on: board).isEmpty && Engine.getAllMoves(byPlayer: 2, on: board).isEmpty {
            
            if board.playerOneTiles > board.playerTwoTiles {
                return .playerOneWins
            } else if board.playerTwoTiles > board.playerOneTiles {
                return .playerTwoWins
            } else {
                return .draw
            }
            
        }
        
        return .onGoing
    }
    
}
