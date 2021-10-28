%macro pushd 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro popd 0
    pop edx
    pop ecx
    pop ebx
    pop eax
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

%macro printd 0
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

%%_digit:
    pop ax
    add ax, '0'
    mov [result], ax
    print 1, result
    dec bx
    cmp bx, 0
    jnz %%_digit
    popd
%endmacro

section .text
    global _start

_start:
    mov ebx, 0
    
_loopX:
    add al, [x + ebx]
    inc ebx
    cmp ebx, xlen
    jne _loopX

    push ebx
    mov ecx, 4
    mov eax, xlen
    div ecx
    
    push eax
    pop ecx
    mov edx, 0
    pop eax
    div ecx
    
    mov ebx, 0

_loopY:
    add al, [y + ebx]
    inc ebx
    cmp ebx, ylen
    jne _loopY

    push eax
    mov ecx, 4
    mov eax, xlen
    div ecx
    
    push eax
    pop ecx
    mov edx, 0
    pop eax
    div ecx
    
    mov ebx, 0
    
_mean:
    sub eax, edx
    
    printd
    
    mov ebx, 0
    mov eax, 1
    int 0x80
    
section .data
    x dd 5, 3, 2, 6, 1, 7, 4
    xlen equ $ - x
    y dd 0, 10, 1, 9, 2, 8, 5
    ylen equ $ - y
    
section .bss
    result resb 1
