; -----------------------------------------
; Remove duplicates from 64-bit array
; NASM x86-64 Linux
; -----------------------------------------

section .data
    array dq 10, 20, 10, 30, 40, 20, 50, 30
    n     equ 8

    msg db "Unique Elements:", 10
    len equ $-msg

    space db " "
    nl db 10

section .bss
    unique resq 8

section .text
    global _start

; -----------------------------------------
; PRINT STRING
; rsi = address, rdx = length
; -----------------------------------------
print_str:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

; -----------------------------------------
; PRINT NUMBER (SAFE FIXED VERSION)
; rax = number
; -----------------------------------------
print_num:
    mov rbx, 10
    sub rsp, 32

    mov rcx, rsp
    add rcx, 31
    mov byte [rcx], 0

    cmp rax, 0
    jne .convert

    dec rcx
    mov byte [rcx], '0'
    jmp .print

.convert:
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rcx
    mov [rcx], dl
    test rax, rax
    jnz .loop

.print:
    mov rsi, rcx
    lea rdx, [rsp+31]
    sub rdx, rcx

    mov rax, 1
    mov rdi, 1
    syscall

    ; print space
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

    add rsp, 32
    ret

; -----------------------------------------
; PRINT ARRAY
; -----------------------------------------
print_array:
    mov rsi, unique
    mov rcx, r8        ; number of unique elements

.loop:
    mov rax, [rsi]
    push rcx
    call print_num
    pop rcx

    add rsi, 8
    dec rcx
    jnz .loop

    ; newline
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    ret

; -----------------------------------------
; REMOVE DUPLICATES
; r8 = unique count
; -----------------------------------------
remove_duplicates:
    xor r8, r8          ; unique count = 0
    xor rsi, rsi        ; i = 0

.outer:
    cmp rsi, n
    jge .done

    mov rax, [array + rsi*8]

    xor rdi, rdi        ; j = 0
    mov rcx, r8         ; compare with unique[]

.check:
    cmp rcx, 0
    je .insert

    mov rbx, [unique + rdi*8]
    cmp rbx, rax
    je .skip

    inc rdi
    dec rcx
    jmp .check

.insert:
    mov [unique + r8*8], rax
    inc r8

.skip:
    inc rsi
    jmp .outer

.done:
    ret

; -----------------------------------------
; MAIN
; -----------------------------------------
_start:

    ; print message
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    ; remove duplicates
    call remove_duplicates

    ; print result
    call print_array

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall
