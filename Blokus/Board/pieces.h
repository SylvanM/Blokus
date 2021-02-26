//
//  pieces.h
//  Blokus
//
//  Created by Sylvan Martin on 2/22/21.
//

#ifndef pieces_h
#define pieces_h

#include <stdio.h>
#include "bitboard.h"
#include "game.h"
#include "blokus_error.h"

// MARK: Piece Definitions

// Piece bit index definitions (0 would mean the least significant bit)

#define SINGLE_PIECE_INDEX  (0)
#define ONE_BY_TWO_INDEX    (1)
#define STAIRCASE_INDEX     (2)
#define LINE_INDEX          (3)
#define T_PIECE_INDEX       (4)
#define L_PIECE_INDEX       (5)
#define SQUIGGLY_INDEX      (6)
#define SQUARE_INDEX        (7)

// Get the bit mask for a piece's bit index
#define PIECE_INDEX_MASK(i) (1 << i)

/**
 * The definitions of each piece (and their possible orientations) when placed in the "bottem-left hand" corner of the board.
 *
 * The orientation index `n` would represent the piece being rotated by `(90 * n)` degrees counterclockwise.
 */
static const uint64_t piece_types[8][4] = {
    
    { 0b1, 0b1, 0b1, 0b1 }, // Single tile piece
    { 0b11, 0b100000001, 0b11, 0b100000001 }, // 1 x 2 tile piece
    { 0b100000011, 0b1000000011, 0b1100000010, 0b1100000001 }, // Small staircase piece
    { 0b111, 0b1 | 1 << 8 | 1 << 16, 0b111, 0b1 | 1 << 8 | 1 << 16 }, // 3 x 1 piece
    { 0b1000000111, 1 << 17 | 1 << 9 | 1 << 1 | 1 << 8, 0b11100000010, 1 << 17 | 1 << 9 | 1 << 1 | 1 << 10 }, // T shaped piece
    { 1 << 8 | 0b111, 0b11 | 1 << 9 | 1 << 17, 0b11100000100, 0b11 << 16 | 1 << 8 | 1 << 0 }, // L piece
    { 0b11 | 0b11 << 9, 0b10 | 0b11 << 8 | 1 << 16, 0b11 | 0b11 << 9, 0b10 | 0b11 << 8 | 1 << 16 }, // Squiggly
    { 0b11 | 0b11 << 8, 0b11 | 0b11 << 8, 0b11 | 0b11 << 8, 0b11 | 0b11 << 8 }
    
};

/**
 * An array listing the horizontal and vertical dimensions of a piece of the respective index, assuming an orientation of zero.
 */
static const int piece_dimensions[8][2] = {
    
    { 1, 1 }, // Single tile
    { 2, 1 }, // 1 x 2 tile
    { 2, 2 }, // Small staircase
    { 3, 1 }, // 3 x 1 tile
    { 3, 2 }, // T shaped piece
    { 3, 2 }, // L shaped piece
    { 3, 2 }, // Squiggly
    { 2, 2 }, // Square
    
};

/**
 * An array describing the area of each piece for scoring
 */
static const int piece_areas[8] = {
    1,
    2,
    3,
    3,
    4,
    4,
    4,
    4
};

// MARK: Functions

#endif /* pieces_h */

