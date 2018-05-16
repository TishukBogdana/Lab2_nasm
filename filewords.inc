section .text
extern parse_uint
extern string_copy
extern print_int
section .data
colon "print_int", hey
dq print_int

colon "parse_uint", tes
dq parse_uint

colon "string_copy", tost
dq string_copy
