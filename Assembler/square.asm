%macro pushd 0
    push edx
    push ecx
    push ebx
    push eax
%endmacro

%macro popd 0
    pop eax
    pop ebx
    pop ecx
    pop edx
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

%macro dprint 0
    pushd
    
    mov ecx, 10
    mov bx, 0
    %%_divide:
        mov edx, 0
        div ecx
        push dx
        inc bx
        test eax, eax
        jnz %%_divide
        mov cx, bx
    %%_digit:
        pop ax
        add ax, '0'
        mov [count], ax
        print 1, count
        dec cx
        mov ax, cx
        cmp cx, 0
        jg %%_digit
    popd
%endmacro

%macro calc 2
    push edx
    push ecx
    push ebx
    
    xor edx, edx
    mov ecx, %2
    push ecx
    
    mov eax, %1
    div ecx

    pop edx
    
    add eax, edx
    xor edx, edx
    mov ecx, 2
    div ecx
    
    pop edx
    pop ecx
    pop ebx 

%endmacro

%macro get_abs 0
    pushd
    
    mov edx, eax
    sar edx, 31
    xor eax,  edx
    sub eax, edx
    mov [number], eax
    
    popd
%endmacro


section .text

global _start

_start:
    mov eax, [number]
    
    cmp eax, 0
    jl get_abs
    
    mov ecx, 2 
    div ecx
    mov edx, 0
    mov [x1], eax 

    calc [number], eax; x2
    mov [x2], eax
    
_loop:
    mov eax, [x1]
    mov ecx, [x2]
    sub eax, ecx
    
    cmp eax, 1
    jl _end

    mov eax, [x2]
    mov [x1], eax
    calc [number], [x1]
    mov [x2], eax
    jmp _loop
    
_end:
    mov eax, [x2]
    dprint
    
    print nlen, newline
    print len, message
    print nlen, newline

    mov     eax, 1
    int     0x80
    
section .data
    number dd -625
    message db "Done"
    len equ $ - message
    newline db 0xA, 0xD
    nlen equ $ - newline

segment .bss
    count resd 1
    x1 resd 1
    x2 resd 1
    result resd 1
