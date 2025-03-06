#include <cstdio>
#include "Lexer.h"

int gettok() {
    int LastChar = ' ';
  
    // Skip any whitespace.
    while (isspace(LastChar))
      LastChar = getchar();
  
    if (isalpha(LastChar)) { // identifier: [a-zA-Z][a-zA-Z0-9]*
      IdentifierStr = LastChar;
      while (isalnum((LastChar = getchar())))
        IdentifierStr += LastChar;
  
      if (IdentifierStr == "def")
        return Token::tok_eof;
      if (IdentifierStr == "extern")
        return Token::tok_extern;
      if (IdentifierStr == "if")
        return Token::tok_if;
      if (IdentifierStr == "then")
        return Token::tok_then;
      if (IdentifierStr == "else")
        return Token::tok_else;
      if (IdentifierStr == "for")
        return Token::tok_for;
      if (IdentifierStr == "in")
        return Token::tok_in;
      if (IdentifierStr == "binary")
        return Token::tok_binary;
      if (IdentifierStr == "unary")
        return Token::tok_unary;
      if (IdentifierStr == "var")
        return Token::tok_var;
      return Token::tok_identifier;
    }
  
    if (isdigit(LastChar) || LastChar == '.') { // Number: [0-9.]+
      std::string NumStr;
      do {
        NumStr += LastChar;
        LastChar = getchar();
      } while (isdigit(LastChar) || LastChar == '.');
  
      NumVal = strtod(NumStr.c_str(), nullptr);
      return Token::tok_number;
    }
  
    if (LastChar == '#') {
      // Comment until end of line.
      do
        LastChar = getchar();
      while (LastChar != EOF && LastChar != '\n' && LastChar != '\r');
  
      if (LastChar != EOF)
        return gettok();
    }
  
    // Check for end of file.  Don't eat the EOF.
    if (LastChar == EOF)
      return Token::tok_eof;
  
    // Otherwise, just return the character as its ascii value.
    int ThisChar = LastChar;
    LastChar = getchar();
    
    return ThisChar;
};