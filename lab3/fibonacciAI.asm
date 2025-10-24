global _start
section .text
_start:
    mov rax, 1          ; Системний виклик write
    mov rdi, 1          ; Файловий дескриптор stdout
    mov rsi, prompt     ; Адреса повідомлення
    mov rdx, prompt_len ; Довжина повідомлення
    syscall             ; Виклик
    mov rax, 0          ; Системний виклик read
    mov rdi, 0          ; Файловий дескриптор stdin
    mov rsi, input      ; Буфер для вводу
    mov rdx, 10         ; Максимальна довжина вводу
    syscall
    mov rsi, input
    call atoi           ; Конвертувати введений рядок у число
    mov rbx, rax        ; Зберігаємо n у rbx
    cmp rbx, 0
    jl invalid          ; Якщо n < 0
    cmp rbx, 93
    jg invalid          ; Якщо n > 93
    call fibonacci      ; Обчислити число Фібоначчі
    mov rbx, rax        ; Зберігаємо результат
    mov rdi, output
    call itoa           ; Конвертувати результат у рядок
    mov r12, rax        ; Зберігаємо довжину рядка
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_msg_len
    syscall             ; Вивести повідомлення
    mov rax, 1
    mov rsi, output
    mov rdx, r12
    syscall             ; Вивести число
    mov rax, 1
    mov rsi, newline
    mov rdx, 1
    syscall             ; Вивести новий рядок
    mov rax, 60         ; Системний виклик exit
    xor rdi, rdi        ; Код виходу 0
    syscall
invalid:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall
    mov rax, 60
    mov rdi, 1          ; Код виходу 1
    syscall
atoi:
    xor rax, rax
    xor rcx, rcx
atoi_loop:
    movzx rbx, byte [rsi + rcx]
    cmp rbx, 10         ; Перевірити на новий рядок
    je atoi_done
    sub rbx, '0'        ; Перетворити символ у цифру
    imul rax, rax, 10   ; Помножити попередній результат на 10
    add rax, rbx        ; Додати нову цифру
    inc rcx
    jmp atoi_loop
atoi_done:
    ret
fibonacci:
    cmp rbx, 0
    je fib_zero
    cmp rbx, 1
    je fib_one
    mov rax, 0          ; F(0) = 0
    mov rcx, 1          ; F(1) = 1
    mov r8, rbx         ; Лічильник ітерацій
fib_loop:
    mov r9, rax         ; Зберігаємо попереднє значення
    mov rax, rcx        ; rax = F(n-1)
    add rcx, r9         ; rcx = F(n) = F(n-1) + F(n-2)
    dec r8              ; Зменшуємо лічильник
    jnz fib_loop        ; Продовжуємо, якщо r8 != 0
    ret
fib_zero:
    xor rax, rax        ; Повертаємо 0
    ret
fib_one:
    mov rax, 1          ; Повертаємо 1
    ret
itoa:
    mov rbx, 10
    mov rcx, 0
    mov r8, rax
itoa_loop:
    xor rdx, rdx
    div rbx             ; Ділимо на 10
    add dl, '0'         ; Перетворити залишок у символ
    mov [rdi + rcx], dl ; Зберігаємо символ
    inc rcx
    test rax, rax
    jnz itoa_loop
    mov rax, rcx        ; Довжина рядка
    mov r9, rcx
    shr r9, 1           ; Половина довжини для реверсу
    mov r10, 0
reverse_loop:
    cmp r10, r9
    jge reverse_done
    mov al, [rdi + r10]
    mov bl, [rdi + rcx - 1]
    mov [rdi + r10], bl
    mov [rdi + rcx - 1], al
    inc r10
    dec rcx
    jmp reverse_loop
reverse_done:
    ret
section .data
prompt: db "Введіть номер числа Фібоначчі для обчислення (0-93): "
prompt_len equ $ - prompt
result_msg: db "Число Фібоначчі з номером n дорівнює "
result_msg_len equ $ - result_msg
error_msg: db "Будь ласка, введіть число від 0 до 93.\n"
error_msg_len equ $ - error_msg
newline: db 10
section .bss
input resb 10
output resb 20