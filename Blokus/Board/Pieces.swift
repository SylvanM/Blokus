//
//  Pieces.swift
//  Blokus
//
//  Created by Sylvan Martin on 2/22/21.
//

import Foundation

// MARK: - Pieces

/**
 * Definition of the piece types with their orientation
 */
fileprivate let pieceTypes: [[UInt64]] = [
    [ 0b1,  0b1,    0b1,    0b1 ], // Single tile piece
    [ 0b11, 0b100000001, 0b11, 0b100000001 ], // 1 x 2 tile piece
    [ 0b100000011, 0b1000000011, 0b1100000010, 0b1100000001 ], // Small staircase piece
    [ 0b111, 0x10101, 0b111, 0x10101 ], // 3 x 1 piece
    [ 0b1000000111, 0x20302, 0b11100000010, 0x20602 ], // T shaped piece
    [ 0x107, 0x20203, 0b11100000100, 0x30101 ], // L piece
    [ 0x603, 0x10302, 0x603, 0x10302 ], // Squiggly
    [ 0b11 | 0b11 << 8, 0b11 | 0b11 << 8, 0b11 | 0b11 << 8, 0b11 | 0b11 << 8 ]
]

/**
 * Definitions of a piece's dimensions assuming an orientation of 0
 */
fileprivate let pieceDimensions: [ (width: Int, height: Int) ] = [
    (width: 1, height: 1),
    (width: 2, height: 1),
    (width: 2, height: 2),
    (width: 3, height: 1),
    (width: 3, height: 2),
    (width: 3, height: 2),
    (width: 3, height: 2),
    (width: 2, height: 2)
]

fileprivate let pieceAreas: [Int] = [
    1,
    2,
    3,
    3,
    4,
    4,
    4,
    4
]

// MARK: Enumerations

/**
 * A type of piece, also represented as an `Int`
 */
enum Piece: Int, CaseIterable {
    case singleTile = 0
    case oneByTwo   = 1
    case staircase  = 2
    case linePiece  = 3
    case triangle   = 4
    case hookPiece  = 5
    case squiggly   = 6
    case square     = 7
}

// MARK: Helper Functions

func getPieceBitPattern(piece: Piece, orientation: Int = 0) -> UInt64 {
    pieceTypes[piece.rawValue][orientation % 4]
}

func getPieceDimensions(piece: Piece, orientation: Int = 0) -> (width: Int, height: Int) {

    var dimensions = pieceDimensions[piece.rawValue]
    
    if orientation % 2 == 1 {
        let temp = dimensions.width
        dimensions.width = dimensions.height
        dimensions.height = temp
    }
    
    return dimensions
    
}

func getPieceArea(piece: Piece) -> Int {
    
    return pieceAreas[piece.rawValue]
    
}
