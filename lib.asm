section .text

global read_word
global print_char
global print_newline
global print_string
global string_length
global string_equals
global exit
global parse_uint
global string_copy
global print_int
string_length:
    mov rax, -1 
    .loop: inc rax
     cmp byte[rdi +rax], 0x00 
  	jnz .loop 
    ret

print_string:

section .text
    mov rsi, rdi
    call string_length
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    ret


print_char:
    push rdi
    mov rsi, rsp
    mov rdi, 1
    mov rax, 1
    mov rdx, 1
    syscall
    pop rdi
    ret

print_newline:
    mov rdi, 10
    call print_char
    ret


print_uint:
   mov rsi, rsp
   mov rcx, 0 
    mov rax, rdi
     mov r9, 10
    .loop: mov rdx, 0
    div r9
    add dl, '0'
    dec rsi
    inc rcx
    mov byte[rsi], dl
    cmp rax, 0
    jnz .loop
   mov rax, 1
    mov rdx, rcx
    mov rdi, 1
    syscall
    ret

section .rodata
print_int:
db "prints value from rdi as signed int",0
section .text
       cmp rdi, 0
    jge .uint
    push rdi, 
    mov rdi, '-'
    call print_char
    pop rdi
    not rdi
    inc rdi
    .uint: call print_uint
    ret

string_equals:
    mov al, byte [rdi]
    cmp al, byte [rsi]
    jne .no
    inc rdi
    inc rsi
    test al, al
    jnz string_equals
    mov rax, 1
    ret
    .no:
    xor rax, rax
    ret


read_char:
    mov rax, 0
    push rax
    mov rsi, rsp
    mov rdx, 1
    mov rdi, 0
    syscall
    pop rax
    ret 

read_word:
	mov r10, rdi
mov r9, rsi
mov r8, 0	
	.loop:	
		call read_char
		cmp al, 0x09		
		jz .loop
		cmp al, 0xA			
		jz .loop
		cmp al, 0x20			
		jz .loop
		cmp al, 0
		jz .end
	.cycle:
		mov byte[r10+r8], al 
		inc r8	
		cmp r8, r9
		jz .over		
		call read_char		
		cmp al, 0x09
		jz .end
		cmp al, 0xA
		jz .end
		cmp al, 0x20
		jz .end
		cmp al, 0
		jz .end		
		jmp .cycle
	.end:
		mov byte[r10+r8], 0
		mov rax, r10
                   mov rdx, r8
		ret
	.over:
		mov rdx, r9
		mov rax, 0
    ret

 section .rodata
parse_uint: db "parses string value like unsigned int", 0
section .text 
	mov rax, 0

	mov r9, rdi
	
	.loop:
                    cmp byte[r9], "0"
		js .end
		cmp byte[r9], "9"+1
		jns .end
		mov r8, 10
		mul r8
		add al, byte[r9]
		sub al, "0"
		inc r9		
		jmp .loop
		
	.end:
		mov rdx, r9 
		sub rdx, rdi
ret


parse_int:
    cmp byte[rdi], '-'
   jne .uint
   mov rcx, 1
   inc rdi
   .uint: call parse_uint
  cmp rcx, 1
  jnz .exit
  inc rdx
  neg rax
   .exit: ret 

section .rodata
string_copy:
db "copies string",0
section .text
 push rsi
   call string_length
   cmp rax, rdx
   mov rsi, 0
  ja .exit
  pop rsi
      mov rcx, 0
    .loop:  mov al, [rdi+rcx]
           mov byte[rsi+rcx], al
           inc rcx
         cmp al, 0x00
         jnz .loop
   .exit: mov rax, rsi
    ret

exit:
mov rax, 60
syscall
