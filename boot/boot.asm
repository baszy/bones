org 0x0000

[bits 16]

; Reads %2 sectors from disk in edx given offset %1 and writes them to es:di
%macro disk_read 2
    ; Setup disk address packet
    mov byte [disk_packet.size], 0x10
    mov word [disk_packet.sectors], %2
    mov word [disk_packet.offset], di
    mov word [disk_packet.segment], es
    mov dword [disk_packet.start_sector], %1
    mov dword [disk_packet.start_sector + 4], (%1 / 0x100000000)

    mov si, disk_packet
    mov ah, 0x42
    int 0x13
%endmacro

relocate:
    ; Copy source is here 0x7c00
    mov ax, 0x07c0
    mov ds, ax
    mov si, 0x0000

    ; Copy destination is 0x0600
    mov ax, 0x0060
    mov es, ax
    mov di, 0x0000

    ; We are movsding 1 sector (so, 0x0200 bytes)
    mov cx, 0x0200
    rep movsb

    jmp 0x0060:(start - $$)

; Expects to be running from address 0x0600
start:
    ; Don't want to be rudely interrupted
    cli

    ; Data segment is here so we can use hardcoded data for interrupts
    mov ax, cs
    mov ds, ax

    ; Extra segment is where we will load the next stage
    mov ax, 0x0100
    mov es, ax

    ; Stack segment is placed just below the extra segment
    stack_size equ 0x0100
    mov ax, es
    sub ax, (stack_size / 0x10)
    mov ss, ax
    mov sp, stack_size

    ; Checking low memory size
    clc
    int 0x12
    jc .fail

    ; Save drive reference, hope BIOS isnt buggy
    push dx

    ; Could reset video mode or scroll to clear screen
    mov ax, 0x0003
    int 0x10

    ; Print the banner (not functional set DS)
    mov si, welcome_msg
    call bios_print

    xor ah, ah
    int 0x16

    ; Check if int 0x13 extensions are supported
    clc
    mov ah, 0x41
    mov bx, 0x55aa
    int 0x13
    jc .fail ; We have to deal with CHS at some point :(

    xor ax, ax
    mov di, ax
    clc
    disk_read 0x01, 0x2A ; Hardcoded offset / length of second stage
    jc .fail

    ; Jump into intermediate loader
    jmp 0x0100:0x0000

; If you get here something is wrong
.fail:

.reset:
    ; Wait for key
    xor ah, ah
    int 0x16

    ; Reset, maybe we shouldn't
    int 0x19

; Prints the string in the si register using int 0x10
bios_print:
    lodsb

    ; and al, al
    cmp al, 0x00
    je .leave

    mov ah, 0x0e
    mov bx, 0x0007
    int 0x10

    jmp bios_print

.leave:
    ret

; Prints the number in the ax register in decimal using int 0x10
; Trashes ax, bx, and cx lmao
bios_print_dec:
    mov cx, ax

.loop:
    mov ax, cx
    xor ah, ah
    mov bx, 0x000a
    div bl
    mov cx, ax

    ; ah contains remainder now
    mov al, 0x30
    add al, ah

    mov ah, 0x0e
    mov bx, 0x0007
    int 0x10

    cmp cl, 0x00
    jne .loop

    ret

; Global data
disk_packet:
.size: resb 1
.padding: resb 1
.sectors: resw 1
.offset: resw 1
.segment: resw 1
.start_sector: resd 2

welcome_msg: db `bones bootloader, v0.0`, 0x0a, 0x0d
             db `Press any key to continue...`, 0x00

die_msg: db `Error in system call`, 0x0a, 0x0d, 0x00

; Finally disk info / partition table
times 440 - ($ - $$) db 0x00

disk_label: resb 4

; 0x5a5a if write protect should be enabled
write_protect: db 0x00, 0x00

part_table:
.p1: resb 16
.p2: resb 16
.p3: resb 16
.p4: resb 16

db 0x55, 0xaa
