; Fixed Snake Game in x86 Assembly
; Corrected boundary calculations, data structures, and logic

left equ 1
top equ 3
row equ 15
col equ 40
right equ left+col-1
bottom equ top+row-1

.model small

_DATA segment
    msg db "Welcome to the snake game!!",0
    instructions db 0AH,0DH,"Use a, s, d and w to control your snake",0AH,0DH,"Use q anytime to quit",0DH,0AH, "Press any key to continue$"
    quitmsg db "Thanks for playing! hope you enjoyed",0
    gameovermsg db "OOPS!! your snake died! :P ", 0
    scoremsg db "Score: ",0

    ; Snake data structure: each segment has direction/char + x + y (3 bytes each)
    head_char db '^'
    head_x db 20
    head_y db 10

    ; Body segments: character + x + y for each segment (3 bytes each)
    body db 45 DUP(0)  ; 15 segments max * 3 bytes each
    segmentcount db 1

    fruitactive db 0
    fruit_x db 8
    fruit_y db 8

    gameover db 0
    quit db 0
    delaytime db 8

    ; Direction storage for movement
    direction db '^'  ; current direction
_DATA ends

.stack 200h

_CODE segment
main proc far
    mov ax, _DATA
    mov ds, ax

    mov ax, 0b800H
    mov es, ax

    ; Clear screen
    mov ax, 0003H
    int 10H

    ; Display welcome message
    lea bx, msg
    mov dx, 0000h
    call writestringat

    ; Display instructions
    lea dx, instructions
    mov ah, 09H
    int 21h

    ; Wait for key press
    mov ah, 07h
    int 21h

    ; Clear screen and start game
    mov ax, 0003H
    int 10H
    call printbox

    ; Initialize snake position
    mov head_x, 20
    mov head_y, 10
    mov direction, '^'
    mov head_char, '^'

mainloop:
    call delay
    call shiftsnake

    cmp gameover, 1
    je gameover_mainloop

    call keyboardfunctions
    cmp quit, 1
    je quitpressed_mainloop

    call fruitgeneration
    call draw

    jmp mainloop

gameover_mainloop:
    mov ax, 0003H
    int 10H
    mov delaytime, 50
    mov dx, 0000H
    lea bx, gameovermsg
    call writestringat
    call delay
    jmp quit_mainloop

quitpressed_mainloop:
    mov ax, 0003H
    int 10H
    mov delaytime, 50
    mov dx, 0000H
    lea bx, quitmsg
    call writestringat
    call delay
    jmp quit_mainloop

quit_mainloop:
    ; Clear screen
    mov ax, 0003H
    int 10h
    mov ax, 4c00h
    int 21h

main endp

delay proc
    mov ah, 00
    int 1Ah
    mov bx, dx
jmp_delay:
    int 1Ah
    sub dx, bx
    cmp dl, delaytime
    jl jmp_delay
    ret
delay endp

fruitgeneration proc
    cmp fruitactive, 1
    je ret_fruitactive

regenerate:
    ; Generate random X coordinate
    mov ah, 00
    int 1Ah
    mov ax, dx
    xor dx, dx
    mov bx, col-2
    div bx
    mov fruit_x, dl
    add fruit_x, left+1

    ; Generate random Y coordinate
    mov ah, 00
    int 1Ah
    add dx, 12345  ; Add offset for different random
    mov ax, dx
    xor dx, dx
    mov bx, row-2
    div bx
    mov fruit_y, dl
    add fruit_y, top+1

    ; Check if fruit position conflicts with snake
    mov dh, fruit_y
    mov dl, fruit_x
    call readcharat
    cmp bl, ' '
    jne regenerate  ; If not empty space, regenerate

    mov fruitactive, 1

ret_fruitactive:
    ret
fruitgeneration endp

dispdigit proc
    add dl, '0'
    mov ah, 02H
    int 21H
    ret
dispdigit endp

dispnum proc
    test ax, ax
    jz retz
    xor dx, dx
    mov bx, 10
    div bx
    push dx
    call dispnum
    pop dx
    call dispdigit
    ret
retz:
    ret
dispnum endp

setcursorpos proc
    mov ah, 02H
    push bx
    mov bh, 0
    int 10h
    pop bx
    ret
setcursorpos endp

draw proc
    ; Display score
    lea bx, scoremsg
    mov dx, 0109h
    call writestringat
    mov dx, 0109h + 7
    call setcursorpos
    mov al, segmentcount
    dec al
    xor ah, ah
    call dispnum

    ; Draw snake head
    mov bl, head_char
    mov dh, head_y
    mov dl, head_x
    call writecharat

    ; Draw snake body
    lea si, body
    mov cx, 0
    mov cl, segmentcount
    dec cx  ; Don't count head

draw_body_loop:
    test cx, cx
    jz draw_fruit

    mov bl, ds:[si]     ; Get body character
    test bl, bl
    jz draw_fruit

    mov dh, ds:[si+2]   ; Get Y coordinate
    mov dl, ds:[si+1]   ; Get X coordinate
    call writecharat

    add si, 3           ; Move to next segment
    dec cx
    jmp draw_body_loop

draw_fruit:
    cmp fruitactive, 1
    jne draw_end
    mov bl, 'X'
    mov dh, fruit_y
    mov dl, fruit_x
    call writecharat

draw_end:
    ret
draw endp

readchar proc
    mov ah, 01H
    int 16H
    jnz keybdpressed
    xor dl, dl
    ret
keybdpressed:
    mov ah, 00H
    int 16H
    mov dl, al
    ret
readchar endp

keyboardfunctions proc
    call readchar
    cmp dl, 0
    je no_key_pressed

    cmp dl, 'w'
    jne check_s
    cmp direction, 'v'  ; Can't reverse into self
    je no_key_pressed
    mov direction, '^'
    mov head_char, '^'
    ret

check_s:
    cmp dl, 's'
    jne check_a
    cmp direction, '^'  ; Can't reverse into self
    je no_key_pressed
    mov direction, 'v'
    mov head_char, 'v'
    ret

check_a:
    cmp dl, 'a'
    jne check_d
    cmp direction, '>'  ; Can't reverse into self
    je no_key_pressed
    mov direction, '<'
    mov head_char, '<'
    ret

check_d:
    cmp dl, 'd'
    jne check_q
    cmp direction, '<'  ; Can't reverse into self
    je no_key_pressed
    mov direction, '>'
    mov head_char, '>'
    ret

check_q:
    cmp dl, 'q'
    jne no_key_pressed
    mov quit, 1

no_key_pressed:
    ret
keyboardfunctions endp

shiftsnake proc
    ; First, shift body segments backward
    call shift_body_segments

    ; Store current head position as first body segment if we have body
    cmp segmentcount, 1
    je move_head_only

    ; Move current head to first body position
    lea si, body
    mov bl, '*'
    mov ds:[si], bl      ; Body character
    mov bl, head_x
    mov ds:[si+1], bl    ; X coordinate
    mov bl, head_y
    mov ds:[si+2], bl    ; Y coordinate

move_head_only:
    ; Calculate new head position based on direction
    mov al, direction
    mov bl, head_x
    mov bh, head_y

    cmp al, '<'
    jne check_right
    dec bl
    jmp update_head_pos

check_right:
    cmp al, '>'
    jne check_up
    inc bl
    jmp update_head_pos

check_up:
    cmp al, '^'
    jne check_down
    dec bh
    jmp update_head_pos

check_down:
    inc bh

update_head_pos:
    ; Check boundaries
    cmp bl, left
    jle game_over
    cmp bl, right
    jge game_over
    cmp bh, top
    jle game_over
    cmp bh, bottom
    jge game_over

    ; Update head position
    mov head_x, bl
    mov head_y, bh

    ; Check what's at new position
    mov dh, bh
    mov dl, bl
    call readcharat

    cmp bl, 'X'
    je ate_fruit

    cmp bl, '*'
    je game_over

    ret

game_over:
    mov gameover, 1
    ret

ate_fruit:
    ; Increase snake length
    inc segmentcount

    ; Clear fruit
    mov dh, fruit_y
    mov dl, fruit_x
    mov bl, ' '
    call writecharat
    mov fruitactive, 0

    ; Reduce delay to increase speed
    cmp delaytime, 3
    jle no_speed_increase
    dec delaytime

no_speed_increase:
    ret
shiftsnake endp

shift_body_segments proc
    ; Shift all body segments one position back
    mov cl, segmentcount
    dec cl              ; Don't count head
    cmp cl, 1
    jle no_shift_needed

    ; Start from the end and work backwards
    lea si, body
    mov al, 3
    mul cl              ; Calculate offset to last segment
    add si, ax
    sub si, 3           ; Point to last valid segment

shift_loop:
    cmp cl, 1
    jle no_shift_needed

    ; Copy from current-1 to current
    mov al, ds:[si-3]   ; Character
    mov bl, ds:[si-2]   ; X
    mov bh, ds:[si-1]   ; Y

    mov ds:[si], al     ; Store character
    mov ds:[si+1], bl   ; Store X
    mov ds:[si+2], bh   ; Store Y

    sub si, 3
    dec cl
    jmp shift_loop

no_shift_needed:
    ret
shift_body_segments endp

printbox proc
    ; Draw top border
    mov dh, top
    mov dl, left
    mov cx, col
    mov bl, '#'

top_border:
    call writecharat
    inc dl
    loop top_border

    ; Draw right border
    mov dh, top
    mov dl, right
    mov cx, row

right_border:
    call writecharat
    inc dh
    loop right_border

    ; Draw bottom border
    mov dh, bottom
    mov dl, right
    mov cx, col

bottom_border:
    call writecharat
    dec dl
    loop bottom_border

    ; Draw left border
    mov dh, bottom
    mov dl, left
    mov cx, row

left_border:
    call writecharat
    dec dh
    loop left_border

    ret
printbox endp

writecharat proc
    push dx
    push ax

    ; Calculate video memory offset
    mov al, dh          ; Row
    mov ah, 160         ; 80 chars * 2 bytes per char
    mul ah
    mov di, ax

    mov al, dl          ; Column
    mov ah, 2           ; 2 bytes per character
    mul ah
    add di, ax

    mov es:[di], bl     ; Write character
    mov byte ptr es:[di+1], 07h  ; White on black attribute

    pop ax
    pop dx
    ret
writecharat endp

readcharat proc
    push dx
    push ax

    ; Calculate video memory offset
    mov al, dh          ; Row
    mov ah, 160         ; 80 chars * 2 bytes per char
    mul ah
    mov di, ax

    mov al, dl          ; Column
    mov ah, 2           ; 2 bytes per character
    mul ah
    add di, ax

    mov bl, es:[di]     ; Read character

    pop ax
    pop dx
    ret
readcharat endp

writestringat proc
    push dx
    push ax

    ; Calculate video memory offset
    mov al, dh          ; Row
    mov ah, 160         ; 80 chars * 2 bytes per char
    mul ah
    mov di, ax

    mov al, dl          ; Column
    mov ah, 2           ; 2 bytes per character
    mul ah
    add di, ax

loop_writestringat:
    mov al, [bx]
    test al, al
    jz exit_writestringat
    mov es:[di], al
    mov byte ptr es:[di+1], 07h  ; White on black attribute
    add di, 2
    inc bx
    jmp loop_writestringat

exit_writestringat:
    pop ax
    pop dx
    ret
writestringat endp

_CODE ends

end main
