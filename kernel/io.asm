section .text

; TODO: This assembly is not inlinable, and the function prologue and epilogue
; are probably unnecessary because these are "leaf" functions

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

	mov al, [ebp + 8]
	mov dx, [ebp + 12]
	out dx, al

	leave
	ret

global outw:function
outw:
	push ebp
	mov ebp, esp

	mov ax, [ebp + 8]
	mov dx, [ebp + 12]
	out dx, ax

	leave
	ret

global outl:function
outl:
	push ebp
	mov ebp, esp

	mov eax, [esp + 8]
	mov dx, [esp + 12]
	out dx, eax

	leave
	ret
