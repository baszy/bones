section .text

; TODO: Not inlinable
; TODO: Function prologue and epilogue are unnecessary for leaf functions

global inb:function
inb:
    push ebp
    mov ebp, esp

    mov dx, [ebp + 8]
    in al, dx

    leave
    ret

global inw:function
inw:
    push ebp
    mov ebp, esp

    mov dx, [ebp + 8]
    in ax, dx

    leave
    ret

global inl:function
inl:
    push ebp,
    mov ebp, esp

    mov dx, [ebp + 8]
    in eax, dx

    leave
    ret

global outb:function
outb:
    push ebp
    mov ebp, esp

    mov dx, [ebp + 8]
    mov al, [ebp + 12]
    out dx, al

    leave
    ret

global outw:function
outw:
    push ebp
    mov ebp, esp

    mov dx, [ebp + 8]
    mov ax, [ebp + 12]
    out dx, ax

    leave
    ret

global outl:function
outl:
    push ebp
    mov ebp, esp

    mov dx, [esp + 8]
    mov eax, [esp + 12]
    out dx, eax

    leave
    ret
