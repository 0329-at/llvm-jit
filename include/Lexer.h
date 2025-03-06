#ifndef LEXER_H
#define LEXER_H

#include <string>


enum Token : unsigned short {
    tok_eof,
  
    // commands
    tok_def,
    tok_extern,
  
    // primary
    tok_identifier,
    tok_number,
  
    // control
    tok_if,
    tok_then,
    tok_else,
    tok_for,
    tok_in,
  
    // operators
    tok_binary,
    tok_unary,
  
    // var definition
    tok_var,
};


static std::string IdentifierStr; // Filled in if tok_identifier
static double NumVal;             // Filled in if tok_number

/// gettok - Return the next token from standard input.
int gettok();

#endif