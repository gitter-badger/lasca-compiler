#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <gc.h>

struct type_info {
  int type;
  void* value;
};


void lasca_init() {
    GC_init();
    puts("Init Lasca 0.0.0.1 runtime :)");
}

void *gcMalloc(size_t s) {
    return GC_malloc(s);
}

struct type_info *box(int type_id, void *value) {
  struct type_info* ti = (struct type_info*) gcMalloc(8);
  ti->type = type_id;
  ti->value = value;
  return ti;
}

struct type_info * boxBool(int i) {
  int* result = (int *) gcMalloc(sizeof(i));
  *result = i;
  return box(0, result);
}

struct type_info * boxInt(int i) {
  int* result = (int *) gcMalloc(sizeof(i));
  *result = i;
  return box(1, result);
}

void *unbox(struct type_info* ti, int expected) {
  if (ti->type == expected) {
  	return ti->value;
  } else {
    printf("AAAA!!! Expected %i but got %i", expected, ti->type);
    exit(1);
  }
}

const int ADD = 10;
const int SUB = 11;                           // x - y
const int MUL = 12;
const int DIV = 13;                           // x / y
const int MOD = 14;                           // x % y

const int EQ = 42;                            // x == y
const int NE = 43;                            // x != y
const int LT = 44;                            // x < y
const int LE = 45;                            // x <= y
const int GE = 46;                            // x >= y
const int GT = 47;                            // x > y
  // Boolean unary operations
const int ZNOT = 50;                          // !x

  // Boolean binary operations
const int ZOR = 60;                           // x || y
const int ZAND = 61;                          // x && y

void *runtimeBinOp(int code, struct type_info* lhs, struct type_info* rhs) {
  if (lhs->type != rhs->type) {
  	printf("AAAA!!! Type missmatch! lhs = %i, rhs = %i", lhs->type, rhs->type);
  	exit(1);
  }
  int left = *(int*)lhs->value;
  int right = *(int*)rhs->value;
  void* result = NULL;

  switch (code) {
  case ADD: result = boxInt(left + right); break;
  case SUB: result = boxInt(left - right); break;
  case MUL: result = boxInt(left * right); break;
  case DIV: result = boxInt(left / right); break;
  case EQ:  result = boxBool(left == right); break;
  case NE:  result = boxBool(left != right); break;
  case LT:  result = boxBool(left < right); break;
  case LE:  result = boxBool(left <= right); break;
  case GE:  result = boxBool(left > right); break;
  default:
  	printf("AAAA!!! Unsupported binary operation %i", code);
    exit(1);
  }
  return result;
}

double putchard(double X) {
  putchar((char)X);
  fflush(stdout);
  return 0;
}
