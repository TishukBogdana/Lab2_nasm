section .text
%include "colon.inc"

extern read_word
extern find_word
extern print_char
extern print_string
extern print_newline
extern print_error
extern string_length
extern exit

global _start

section .rodata
err: db "No entrance",0

%include "filewords.inc"
    
section .text
_start:
mov rsi, 256
mov rdx, rsp
sub rdx, 256
mov rdi, rdx
call read_word
mov rdi, rax
mov rsi, po
call find_word
test rax, rax
jz .error
add rax, 8
mov rdi, rax
call string_length
add rdi, rax
inc rdi
mov rcx, [rdi]
mov rdi, rcx

call print_string
call print_newline
mov rdi, 0
 call exit
   
.error: mov rax, 1
mov rsi, err
mov rdi, 2
mov rdx, 12
syscall
mov rdi, 0
   call exit
