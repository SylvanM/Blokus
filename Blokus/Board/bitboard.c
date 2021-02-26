//
//  bitboard.c
//  Blokus
//
//  Created by Sylvan Martin on 2/22/21.
//

#include "bitboard.h"

#define P1_SYMBOL '1'
#define P2_SYMBOL '2'
#define EMPTY_TILE_SYMBOL ' '

// MARK: I/O Functions

int write_board( const bitboard_t *board, const char *path ) {
    
    FILE *board_file = fopen(path, "wb");
    
    fwrite(board, sizeof(bitboard_t), 1, board_file);
    fclose(board_file);
    
    return 0;

}

int read_board( const char path[], bitboard_t *out_board ) {
    
    FILE *board_file = fopen(path, "rb");
    
    fread(out_board, sizeof(bitboard_t), 1, board_file);
    fclose(board_file);
    
    return 0;
    
}

int verify_board( const bitboard_t *board ) {
    
    // If either bit patterns for each player have any single bit in common, that means there is overlap, which there shouldn't be.
    if (board->player1 & board->player2)
        return 0;
    
    return 1;
}
