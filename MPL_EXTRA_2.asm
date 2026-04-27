section .data
    array dq 64, 25, 12, 22, 11, 90, 5, 77
    n equ 8

    msg1 db "Before Sorting:", 10
    len1 equ $-msg1

    msg2 db 10, "After Sorting:", 10
    len2 equ $-msg2

    space db " "
    nl db 10

section .bss
    buffer resb 32

section .text
    global _start

; -----------------------------
; PRINT STRING
; -----------------------------
print_str:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

; -----------------------------
; PRINT NUMBER (FIXED)
; rax = number
; -----------------------------
print_num:
    mov rbx, 10
    mov rcx, buffer+31
    mov byte [rcx], 0

    cmp rax, 0
    jne convert
    dec rcx
    mov byte [rcx], '0'
    jmp print_ready

convert:
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rcx
    mov [rcx], dl
    test rax, rax
    jnz .loop

print_ready:
    mov rsi, rcx
    lea rdx, [buffer+31]
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

    ret

; -----------------------------
; PRINT ARRAY (FIXED)
; -----------------------------
print_array:
    mov rsi, array
    mov rcx, n

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

; -----------------------------
; BUBBLE SORT
; -----------------------------
sort_array:
    mov rcx, n-1

.outer:
    mov rsi, 0
    mov rdx, rcx

.inner:
    mov rax, [array + rsi*8]
    mov rbx, [array + rsi*8 + 8]

    cmp rax, rbx
    jle .no_swap

.swap:
    mov [array + rsi*8], rbx
    mov [array + rsi*8 + 8], rax

.no_swap:
    inc rsi
    dec rdx
    jnz .inner

    loop .outer
    ret

; -----------------------------
; MAIN
; -----------------------------
_start:

    ; BEFORE
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, len1
    syscall

    call print_array

    ; SORT
    call sort_array

    ; AFTER
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall

    call print_array

    ; EXIT
    mov rax, 60
    xor rdi, rdi
    syscall
