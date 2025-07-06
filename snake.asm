left equ 0
top equ 2
row equ 15
col equ 40
right equ left+col
bottom equ top+row

.model small

_DATA segment
    msg db "Welcome to the snake game!!",0
    instructions db 0AH,0DH,"Use a, s, d and w to control your snake",0AH,0DH,"Use q anytime to quit",0DH,0AH, "Press any key to continue$"
    quitmsg db "Thanks for playing! hope you enjoyed",0
    gameovermsg db "OOPS!! your snake died! :P ", 0
    scoremsg db "Score: ",0
    head db '^',10,10
    body db '*',10,11, 3*15 DUP(0)
    segmentcount db 1
    fruitactive db 1
    fruitx db 8
    fruity db 8
    gameover db 0
    quit db 0   
    delaytime db 5
_DATA ends

.stack 100h

_CODE segment
main proc far
    mov ax, _DATA
    mov ds, ax 
    
    mov ax, 0b800H
    mov es, ax
    
    mov ax, 0003H
    int 10H
    
    lea bx, msg
    mov dx,00
    call writestringat
    
    lea dx, instructions
    mov ah, 09H
    int 21h
    
    mov ah, 07h
    int 21h
    mov ax, 0003H
    int 10H
    call printbox      
    
mainloop:       
    call delay             
    lea bx, msg
    mov dx, 00
    call writestringat
    call shiftsnake
    cmp gameover,1
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
    mov delaytime, 100
    mov dx, 0000H
    lea bx, gameovermsg
    call writestringat
    call delay    
    jmp quit_mainloop    
    
quitpressed_mainloop:
    mov ax, 0003H
    int 10H    
    mov delaytime, 100
    mov dx, 0000H
    lea bx, quitmsg
    call writestringat
    call delay    
    jmp quit_mainloop    

quit_mainloop:
    mov ax, 0003H
    int 10h    
    mov ax, 4c00h
    int 21h  
; ... your other code sections (delay, fruitgeneration, dispdigit, etc.) stay unchanged ...
; just copy your existing code here without modifications.

; Make sure to add everything else you posted before exactly as-is here.
; For brevity, not repeating the entire 500+ lines; but your other procs
; like shiftsnake, keyboardfunctions, draw, etc. don't need changes.

main endp
_CODE ends

end main
