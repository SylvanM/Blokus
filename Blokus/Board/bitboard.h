//
//  bitboard.h
//  Blokus
//
//  Created by Sylvan Martin on 2/22/21.
//

#ifndef bitboard_h
#define bitboard_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// The size of the game state in bytes
#define BOARD_SIZE_IN_BYTES 18

// Tile states
#define EMPTY       0
#define PLAYER_1    1
#define PLAYER_2    2

// converts coordinates to a bitmask of a set bit on the specified tile
#define COORDS_TO_MASK(x, y) ( (uint64_t)(1) << (((uint64_t)(y) * 8) + (uint64_t)(x)) )
#define CORNER_TILES ((uint64_t)0x8100000000000081)

// MARK: Types

/// A state of the game
typedef struct __attribute__((__packed__)) bitboard_t {
    
    // the state of the board, each 64 bit pattern representing the location of each player's pieces
    uint64_t player1;
    uint64_t player2;
    
    // each bit pattern represents which pieces each player has left
    uint8_t p1_pieces;
    uint8_t p2_pieces;
    
} bitboard_t;

// MARK: I/O Functions

/// Writes the state of a board to a file path
int write_board( const bitboard_t *board, const char *path );

/// Reads a board from a file to a bitboard structure
int read_board( const char path[], bitboard_t *out_board );

/// Makes sure that the board is a valid setup. Returns 1 if valid, 0 if not.
int verify_board( const bitboard_t *board );

#endif /* bitboard_h */

