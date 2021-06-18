//
//  Game.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/22/21.
//

import Foundation

/**
 * A move that can be made in the game
 */
struct Move {
    
    /// The piece to be placed
    var piece: Piece
    
    /// The orientation of the piece
    var orientation: Int
    
    /// The coordinates of the bottom left hand corner of the piefe
    var coords: (x: Int, y: Int)
    
}

/**
 * A class that manages the game.
 *
 * This class is responsible for having each player take their turn, and also provides class functions for evaluating the legality of moves.
 */
class Game {
    
    // MARK: Properties
    
    /// The game board
    var gameBoard: BitBoard
    
    // MARK: Enumerations
    
    /**
     * An error in making move, ways a move can be illegal
     */
    enum MoveError: Error {
        
        /// The piece would overlap an existing tile
        case tileOccupied
        
        /// The piece wasn't placed on a corner location, or was incorrectly touching the face of a friendly tile
        case invalidLocation
        
        /// Each piece can only be used once!
        case pieceAlreadyUsed
        
        /// The piece was placed in a spot that would put it outside the boundaries
        case outsideBorder
        
        /// The player's first piece must cover a corner tile
        case illegalStart
        
    }
    
    /**
     * A game status
     */
    enum GameStatus {
        case onGoing
        case draw
        case playerOneWins
        case playerTwoWins
    }
    
    // MARK: Initializers
    
    /**
     * Creates a new, empty game
     */
    init() {
        gameBoard = BitBoard()
    }
    
    /**
     * Creates a game from a bitboard file
     */
    init(fromPath path: String) {
        gameBoard = BitBoard(fromPath: path)
    }
    
    // MARK: Game Functions
    
    /**
     * Runs a game between two players and returns the winner
     *
     * - Returns: a `GameStatus` which is either `draw`, `playerOneWins`, or `playerTwoWins`
     */
    func runGame(playerOne: Player, playerTwo: Player, verbose: Bool = true) -> GameStatus {
        
        while Game.gameStatus(for: gameBoard) == .onGoing {
            
            if verbose {
                print("-----------------------------")
            }
            
            // check that player one has moves to make
            if !(Game.getAllMoves(byPlayer: 1, on: gameBoard).isEmpty) {
                
                if verbose { print("Player 1's turn.") }
                
                gameBoard.makeLegalMove(playerOne.move(subjectiveBoard: gameBoard), by: 1)
                
                if verbose {
                    print("Player 1 made a move. Now showing current state of board.")
                    gameBoard.printBoard()
                }
                
            } else if verbose {
                print("Player 1 has no legal moves. Skipping their turn.")
            }
            
            // check that player one has moves to make
            if !(Game.getAllMoves(byPlayer: 2, on: gameBoard).isEmpty) {
                
                if verbose { print("Player 2's turn.") }
                
                gameBoard.makeLegalMove(playerTwo.move(subjectiveBoard: gameBoard.flipped()), by: 2)
                
                if verbose {
                    print("Player 2 made a move. Now showing current state of board.")
                    gameBoard.printBoard()
                }
                
            } else if verbose {
                print("Player 2 has no legal moves. Skipping their turn.")
            }
        }
        
        return Game.gameStatus(for: gameBoard)
        
    }
    
    /**
     * Resets the game
     */
    func reset() {
        self.gameBoard = BitBoard()
    }
    
    /**
     * Runs a game against a remote player
     */
    func playAgainstRemote(remote: Remote, local: Player, localGoesFirst: Bool = true) -> GameStatus {
        
        var moveCounter: Int = 0
        
        do {
            print("Waiting 5 seconds")
            sleep(5)
            print("Done!")
        }
        
        return .draw
        
    }
    
}
