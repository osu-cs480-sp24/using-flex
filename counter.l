%{
#include <stdio.h>

int num_chars = 0;
int num_words = 0;
int num_lines = 0;
int num_ints = 0;
%}

%option noyywrap

%%

\n {
  num_lines++;
  num_chars++;
}

int {
  num_ints++;
  REJECT;
}

[^ \t\n]+ {
  num_words++;
  num_chars += yyleng;
}

. {
  num_chars++;
}

%%

int main() {
  yylex();
  printf("\t%d\t%d\t%d\t%d\n", num_lines, num_words, num_chars, num_ints);
  return 0;
}
