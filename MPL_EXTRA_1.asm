section .data
    array dq 10, 25, 5, 99, 67, 2, 88
    count equ 7

    msg1 db "Largest: "
    len1 equ $-msg1

    msg2 db 10, "Smallest: "
    len2 equ $-msg2

section .bss
    largest resq 1
    smallest resq 1
    buf resb 20

section .text
    global _start

_start:
    mov rsi, array
    mov rcx, count

    ; initialize
    mov rax, [rsi]
    mov [largest], rax
    mov [smallest], rax

    add rsi, 8
    dec rcx

loop1:
    cmp rcx, 0
    je print

    mov rbx, [rsi]

    ; largest
    mov rax, [largest]
    cmp rbx, rax
    jle chk_small
    mov [largest], rbx

chk_small:
    ; smallest
    mov rax, [smallest]
    cmp rbx, rax
    jge next
    mov [smallest], rbx

next:
    add rsi, 8
    dec rcx
    jmp loop1

; -------- PRINT --------
print:
    ; print "Largest: "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, len1
    syscall

    mov rax, [largest]
    call print_num

    ; print "Smallest: "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall

    mov rax, [smallest]
    call print_num

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall

; -------- NUMBER PRINT FUNCTION --------
print_num:
    mov rcx, buf+19
    mov rbx, 10
    mov byte [rcx], 10    ; newline

convert:
    dec rcx
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rcx], dl
    test rax, rax
    jnz convert

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx

    mov rdx, buf+20
    sub rdx, rcx

    syscall
    ret
