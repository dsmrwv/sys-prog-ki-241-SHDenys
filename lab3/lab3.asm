global _start
section .text
_start:
    ; Підготовка до системного виклику write
    mov rax, 1        ; Номер системного виклику для write
    mov rdi, 1        ; Файловий дескриптор (1 = stdout)
    mov rsi, message  ; Адреса повідомлення
    mov rdx, 7        ; Довжина повідомлення
    syscall           ; Виклик системного виклику

    ; Підготовка до системного виклику exit
    mov rax, 60       ; Номер системного виклику для exit
    xor rdi, rdi      ; Статуc виходу 0
    syscall           ; Виклик системного виклику

section .data
message: db "KI-241", 10  ; Номер групи та символ нового рядка
