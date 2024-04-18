%{
#include <stdio.h>
#include <stdlib.h>

static int num_ops = 0;
static int num_nums = 0;

#define MAX_IDS 512
static char* ids[MAX_IDS];
static int num_ids = 0;

static int have_err = 0;

void save_id(char* id);
%}

%option yylineno
%option noyywrap

%%

[ \t\n]* { /* Ignore whitespace */ }

[a-z][0-9]? {
  save_id(yytext);
}

[0-9]+("."[0-9]+)? {
  num_nums++;
}

"=" { num_ops++; }
"+" { num_ops++; }
"-" { num_ops++; }
"*" { num_ops++; }
"/" { num_ops++; }

";" { /* Ignore */ }
"(" { /* Ignore */ }
")" { /* Ignore */ }

. {
  fprintf(stderr, "Invalid symbol on line %d: %s\n", yylineno, yytext);
  have_err = 1;
}

<<EOF>> {
  return have_err;
}

%%

void save_id(char* id) {
  if (num_ids >= MAX_IDS) {
    printf("Too many identifiers!");
    return;
  }

  for (int i = 0; i < num_ids; i++) {
    if (strcmp(id, ids[i]) == 0) {
      return;
    }
  }

  int l = strlen(id) + 1;
  ids[num_ids] = malloc(l * sizeof(char));
  strncpy(ids[num_ids], id, l);
  num_ids++;
}

int main() {
  if(!yylex()) {
    printf("Identifiers:\n");
    for (int i = 0; i < num_ids; i++) {
      printf("  %s\n", ids[i]);
    }

    printf("Number of operators: %d\n", num_ops);
    printf("Number of numbers: %d\n", num_nums);
  }
}
