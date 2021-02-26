//
//  BitBoard.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/22/21.
//

import Foundation

/// The Swift representation of the board. This acts as an abstraction for the C represention
struct BitBoard {
    
    /// The C board this represents
    private var c_board: bitboard_t
    
    // MARK: Properties
    
    /**
     * The tiles occupied by player 1
     */
    var playerOneTiles: UInt64 {
        get { c_board.player1 }
        set { c_board.player1 = newValue }
    }
    
    /**
     * The tiles occupied by player 2
     */
    var playerTwoTiles: UInt64 {
        get { c_board.player2 }
        set { c_board.player2 = newValue }
    }
    
    /**
     * The pieces in player 1's inventory
     */
    var playerOnePiecesLeft: UInt8 {
        get { c_board.p1_pieces }
        set { c_board.p1_pieces = newValue }
    }
    
    /**
     * The pieces in player 2's inventory
     */
    var playerTwoPiecesLeft: UInt8 {
        get { c_board.p2_pieces }
        set { c_board.p2_pieces = newValue }
    }
    
    /**
     * The amount of tiles covered by player 1
     */
    var playerOneArea: Int {
        playerOneTiles.nonzeroBitCount
    }
    
    /**
     * The amount of tiles covered by player 2
     */
    var playerTwoArea: Int {
        playerTwoTiles.nonzeroBitCount
    }
    
    // MARK: Initializers
    
    /**
     * Create a new, empty board
     */
    init() {
        c_board = bitboard_t(player1: 0, player2: 0, p1_pieces: 0xFF, p2_pieces: 0xFF)
    }
    
    /**
     * Read a board from a file path
     */
    init(fromPath path: String) {
        self.init()
        read_board(path, &c_board)
    }
    
    // MARK: Static Functions
    
    /**
     * Converts coordinates to a bitmask
     */
    @inlinable static func coordsToMask(_ x: Int, _ y: Int)             -> UInt64 { 1 << ((UInt64(y) * 8) + UInt64(x)) }
    @inlinable static func coordsToMask(_ coords: (x: Int, y: Int))   -> UInt64 { coordsToMask(coords.x, coords.y) }
    
    // MARK: Functions
    
    /**
     * Prints the board
     *
     * - Parameters:
     *      - perspective: `0` to print from an objective perspective, `1` to print from player one's perspective, and `2` for player two.
     */
    func printBoard(perspective: Int = 0) {
        let playerOneSymbol = (perspective == 0) ? ("1") : ( (perspective == 1) ? ("O") : ("X") )
        let playerTwoSymbol = (perspective == 0) ? ("2") : ( (perspective == 1) ? ("X") : ("O") )
        let playerOnePosessive = (perspective == 0) ? ("Player 1's") : ( (perspective == 1) ? ("Your") : ("Opponent's") )
        let playerTwoPosessive = (perspective == 0) ? ("Player 2's") : ( (perspective == 1) ? ("Opponent's") : ("Your") )
        
        var binaryString: String = {
            var string = ""
            for i in 0..<8 {
                string += String((playerTwoPiecesLeft >> i) & 1)
            }
            return string
        }()
        
        print("\(playerTwoPosessive) pieces: \(binaryString)")
        print("\(playerTwoPosessive) tile coverage: \(playerTwoArea)")
        
        print("  +--------+ ")
        
        for y in (0..<8).reversed() {
            var row = "\(y)-|"
            for x in 0..<8 {
                
                if playerOneTiles & BitBoard.coordsToMask(x, y) != 0 {
                    row += playerOneSymbol
                } else if playerTwoTiles & BitBoard.coordsToMask(x, y) != 0 {
                    row += playerTwoSymbol
                } else {
                    row += " "
                }
                
            }
            print(row + "|")
        }
        
        print("  +--------+ ")
        print("   01234567  ")
        
        binaryString = {
            var string = ""
            for i in 0..<8 {
                string += String((playerOnePiecesLeft >> i) & 1)
            }
            return string
        }()
        
        print("\(playerOnePosessive) tile coverage: \(playerOneArea)")
        print("\(playerOnePosessive) pieces: \(binaryString)")
        
    }
    
    /**
     * Writes the board to a file path
     */
    func write(toPath path: String) {
        // make a copy of the board so we don't have to mark this method as mutating since Swift doesn't
        // understand that it's a const in the C function
        var board = c_board
        write_board(&board, path)
    }
    
    /**
     * Returns a version of the board with players 1 and 2 switched
     */
    func flipped() -> BitBoard {
        
        var flippedBoard = BitBoard()
        
        flippedBoard.playerOneTiles = self.playerTwoTiles
        flippedBoard.playerTwoTiles = self.playerOneTiles
        
        flippedBoard.playerOnePiecesLeft = self.playerTwoPiecesLeft
        flippedBoard.playerTwoPiecesLeft = self.playerOnePiecesLeft
        
        return flippedBoard
        
    }
    
    /**
     * Makes a move on the board. The move is assumed to be legal. If not, this crashes!
     */
    mutating func makeLegalMove(_ move: Move, by player: Int) {
        self.c_board = (try! Game.makeMove(move, by: player, on: self)).c_board
    }

}
