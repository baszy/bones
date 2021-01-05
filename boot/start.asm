; Second-stage loader
; TODO: This gets loaded at 0x0100:0x0000 hardcoded by the boot sector
org 0x1000

[bits 16]

global start
start:
    ; Data segment is here so we can use hardcoded data again
    mov ax, 0x0100
    mov ds, ax

    ; Extra segment is where we will store the info structure
    mov ax, 0x0800
    mov es, ax

    ; Zeroing other registers
    xor ax, ax
    mov si, ax
    mov di, ax

    ; TODO: we use the same stack as the boot sector but that's shifty

    ; Preparing for int 0x15
    xor ebx, ebx
    mov edx, `PAMS` ; Magic number

smap:
    clc
    mov eax, 0xe820
    mov ecx, 0x18
    int 0x15
    jc .done ; Note that failures are not handled

    ; The list may wrap around to zero so we quit if it does
    test ebx, ebx
    jz .done

    ; Increment by 24 and continue
    mov ax, di
    add ax, 0x18
    mov di, ax

    jmp smap

.done:
    ; Disabling interrupts including NMI
    cli
    cmos_port equ 0x70
    in al, cmos_port
    ; Clearing the NMI bit
    and al, 0b01111111
    out cmos_port, al

    ; Checking A20
    call check_a20
    cmp ax, 0x0000
    je continue

    ; BIOS int 0x15 method
    mov ax, 0x2401
    int 0x15
    call check_a20
    cmp ax, 0x0000
    je continue

    ; Keyboard controller method
    call kb_wait_for_input
    mov al, 0xad ; Disable first port
    out 0x64, al
    call kb_wait_for_input
    mov al, 0xd0 ; Ready to read controller output port
    out 0x64, al
    call kb_wait_for_output
    in al, 0x60 ; Save output port data
    push ax
    call kb_wait_for_input
    mov al, 0xd1 ; Ready to write controller output port
    out 0x64, al
    call kb_wait_for_input
    pop ax
    or al, 2 ; Enabling A20 bit
    out 0x60, al ; Write to output port
    call kb_wait_for_input
    mov al, 0xae ; Enable first port
    out 0x64, al

    ; If it isn't enabled by now, we lose I guess. Try FAST A20 here

continue:
    xor eax, eax
    mov ds, ax
    mov eax, gdt.start
    mov dword [descriptor + 2], eax
    mov eax, (gdt.end - gdt.start)
    mov word [descriptor], ax
    lgdt [descriptor]

    ; Finally, we can enter protected mode
    mov eax, cr0
    or eax, 0x01
    mov cr0, eax

    ; Jump into protected mode code segment
    jmp 0x08:protected

; Switch to 32-bit code once in protected mode
[bits 32]
protected:
    ; Setting up data segments
    mov eax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; TODO: Hardcoded address of kernel ELF file
    kernel_location equ 0x1200
    mov eax, kernel_location
    call load_elf

    jmp ebx

    hlt

; GDT description structure
descriptor: resw 3

; We create a basic GDT so the kernel can boot and set its own one later
gdt.start:
; Null selector: required on some systems
null: resb 8
; Default code segment: starts 0x0, ends 0xffffffff, readable and executable
code: dw 0xffff
      dw 0x0000
      db 0x00
      db 0b10011010
      db 0b11001111
      db 0x00
; Default data segment: startx 0x0, ends 0xffffffff, readable and writable
data: dw 0xffff
      dw 0x0000
      db 0x00
      db 0b10010010
      db 0b11001111
      db 0x00
gdt.end:

; 16-bit real mode subroutines
[bits 16]

; Returns ax = 0 if A20 is enabled, and ax = 1 otherwise
%define sig_addr 0x7dfe
check_a20:
    push es
    push di

    mov ax, 0xffff
    mov es, ax
    mov di, 0x0010

    mov ax, [sig_addr]
    cmp ax, [es:sig_addr + di]
    jne .good

    mov word [sig_addr], 0xfeda
    mov ax, [sig_addr]
    cmp ax, [es:sig_addr + di]
    jne .good

    mov ax, 0x0001
    jmp .leave

.good:
    mov ax, 0x0000

.leave:
    pop di
    pop es
    ret

; Reads status register of Intel 8042 and waits for input buffer to be empty
kb_wait_for_input:
    in al, 0x64
    and al, 0b0010
    jnz kb_wait_for_input
    ret

; Reads status register of Intel 8042 and waits for output buffer to be full
kb_wait_for_output:
    in al, 0x64
    and al, 0b0001
    jz kb_wait_for_output
    ret

; 32-bit protected mode subroutines
[bits 32]

; Loads ELF executable from the address stored in eax while trashing literally
; every register imaginable
; Returns ebx -> Entry point of the executable
load_elf:
    ; TODO: These checks are unneccessary because we are loading trusted code

    ; Check for 0x7f, E, L, F signature
    mov dword ebx, [eax]
    cmp ebx, `\x7fELF`
    jne .fail

    ; Check for 32-bit mode
    mov byte bl, [eax + 4]
    test bl, 1
    jz .fail

    ; Check for little endianness
    mov byte bl, [eax + 5]
    test bl, 1
    jz .fail

    mov dword ebx, [eax + 28]
    add ebx, eax
    xor edx, edx
    mov word dx, [eax + 44]

.load_segments:
    mov dword ecx, [ebx]
    ; We only care about loadable segments (segment type = 1)
    test ecx, 1
    jz .fail

    ; Source of segmenmt (offset into file)
    mov dword esi, [ebx + 4]
    add esi, eax
    ; Destination of segment in memory
    mov dword edi, [ebx + 8]

    ; Size of the segment in file
    mov dword ecx, [ebx + 16]

    ; TODO: Should we copy dwords or single bytes?
    rep movsb
    ; TODO: Clear memory based on the size of the segment in memory
    ; mov dword edx, [ebx + 20]
    ; sub edx, ecx

    ; Move on to next segment or break if finished
    xor ecx, ecx
    mov word cx, [eax + 42]
    add ebx, ecx
    dec edx
    jz .done

    jmp .load_segments

.done:
    ; Program entry point address
    mov dword ebx, [eax + 24]
    ret

.fail:
    ; Return entry point of zero if executable could not be loaded
    xor ebx, ebx
    ret
