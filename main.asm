[org 0x100]

jmp start

message_1: db 'Lives:',0
message_2: db 'Score:',0

; ===========================================
;       0/1 BITMAP PATTERNS
; ===========================================
; 1 = RED BLOCK, 0 = BLACK SPACE

; "YOU WON" Pattern
msg_win_1: db '100010011100100100000100010011100110010010',0
msg_win_2: db '010100100010100100000100010100010101010010',0
msg_win_3: db '001000100010100100000101010100010100110010',0
msg_win_4: db '001000100010100100000101010100010100010000',0
msg_win_5: db '001000011100011000000010100011100100010010',0

; "GAME OVER" Pattern
msg_loss_1: db '01110001000100010111000000111001000100111001110',0
msg_loss_2: db '10000010100110110100000001000101000100100001001',0
msg_loss_3: db '10110011100101010110000001000101000100110001110',0
msg_loss_4: db '10001010100100010100000001000100101000100001010',0
msg_loss_5: db '01110010100100010111000000111000010000111001001',0

Total_Lives: dw 3000            ; Starting Lives (Standard is 3)
Current_Score: dw 0

Ball_Row: dw 21
Ball_Col: dw 28

; --- [CHANGE IS HERE] ---
Ball_DX: dw 0   ; 0 means NO horizontal movement initially (Straight Up)
Ball_DY: dw -1  ; -1 means Moving Up

Paddle_X: dw 25 

ClrScr:
    mov ax,0xb800
    mov es,ax
    xor di,di
    mov cx, 2000
    mov ax,0x0720
    rep stosw
    ret 

Print_Top_Border:
    mov ah,02h 
    mov bh,0 
    int 10h
    mov ah,09h
    mov al,'*'
    mov bh,0
    mov bl,0x03
    mov cx,80
    int 10h
    ret 

Print_Side_Borders:
    mov ax,0xb800
    mov es,ax
    mov di,160
    mov al,'*'
    mov ah,0x03
LP:
    mov [es:di],ax 
    add di,158        
    mov [es:di],ax 
    add di,2
    cmp di,3840 
    jb LP       
    call Print_Top_Border
    ret 

Draw_Mid_Line:
    mov bh,0        
    mov bl,0x03     
    mov dh,1 
lp:
    mov dl,55       
    mov ah,02h
    int 10h  
    mov ah,09h  
    mov al,'*'
    mov cx,1
    int 10h
    inc dh   
    cmp dh,24 
    jbe lp
    ret 

Break_Right_Box:
    mov bh,0        
    mov bl,0x03     
    mov dl,55         
    mov dh,12         
    mov ah,02h
    int 10h  
    mov ah,09h  
    mov al,'*'
    mov cx,24
    int 10h
    ret 

Print_message_1: 
    mov ax, 0b800h
    mov es, ax
    mov ax, 10   ;Row#10      
    mov bl, 80
    mul bl            
    add ax, 58   ;Col#58      
    shl ax, 1        
    mov di, ax        
    mov si, message_1 
NextChar:
    mov al, [si]      
    cmp al, 0         
    je DoneMsg        
    mov [es:di], al   
    mov byte [es:di+1], 07h 
    inc si            
    add di, 2         
    jmp NextChar
DoneMsg:
    ret 

Print_message_2: 
    mov ax, 0b800h
    mov es, ax
    mov ax, 22        ; row#22
    mov bl, 80        
    mul bl                
    add ax, 58        ; col#58        
    shl ax, 1        
    mov di, ax      
    mov si, message_2 
nextChar:
    mov al, [si]      
    cmp al, 0         
    je doneMsg        
    mov [es:di], al   
    mov byte [es:di+1], 07h 
    inc si            
    add di, 2         
    jmp nextChar
doneMsg:
    ret 

Print_Score:
    push bp
    mov bp,sp
    push es 
    push ax
    push bx
    push cx
    push dx
    push di 

    mov ax,[bp+4]
    mov bx,10
    mov cx,0
nextdigit:
    mov dx,0
    div bx 
    add dl,0x30 
    push dx
    inc cx
    cmp ax,0
    jne nextdigit

    mov ax,0xb800
    mov es,ax
    mov ax,22 ; Row#22
    mov bl,80
    mul bl
    add ax,65 ; COL#65
    shl ax,1  
    mov di,ax;

nextpos:
    pop dx
    mov dh,0x07     
    mov [es:di],dx
    add di,2
    loop nextpos

    pop di
    pop dx
    pop cx 
    pop bx
    pop ax
    pop es
    pop bp
    ret 2 

Print_Lives:
    push bp
    mov bp,sp
    push es 
    push ax
    push bx
    push cx
    push dx
    push di 

    mov ax,[bp+4]
    mov bx,10
    mov cx,0
Nextdigit:
    mov dx,0
    div bx 
    add dl,0x30 
    push dx
    inc cx
    cmp ax,0
    jne Nextdigit

    mov ax,0xb800
    mov es,ax
    mov ax,10 ; Row#10
    mov bl,80
    mul bl
    add ax,65 ; COL#65
    shl ax,1  
    mov di,ax;

Nextpos:
    pop dx
    mov dh,0x07     
    mov [es:di],dx
    add di,2
    loop Nextpos

    pop di
    pop dx
    pop cx 
    pop bx
    pop ax
    pop es
    pop bp
    ret 2 

Pink:
    mov ah,0x57
    jmp Next
  
Bleu:
    mov ah,0x17
    jmp Next

mix:
    mov ah,0x67
    jmp Next

Print_Rows:
    mov ax,1          
    mov bl,80
    mul bl            
    add ax,1          
    shl ax,1          
    mov di,ax         

    mov ax,0b800h
    mov es,ax

    mov ah,0x47       
    mov al,'#'        

    mov bl,4          
    mov bh,1          

Next_Row:
    mov dx,54      
    mov cx,5       

Next_Brick:
    mov  word[es:di],0x0720
    add di,2
    mov cx,5
Brick_Loop:
    mov [es:di],ax
    add di,2
    loop Brick_Loop

    sub dx,6           
    cmp dx,0
    jg Next_Brick     

    add di,52           
    inc bh               
    mov dh,2
    cmp bh,dh
    je Pink
    mov dh,3
    cmp bh,dh
    je Bleu
    mov dh,4
    cmp bh,dh
    je mix

Next:
    cmp bh,bl
    jle Next_Row         
    ret  

Draw_Paddle:
    mov ax,0xb800
    mov es,ax
    mov ax,22 ;Row#22
    mov bl,80
    mul bl
    add ax,[Paddle_X] 
    shl ax,1
    mov di,ax    
    mov cx,7     
    mov ah,0x0B
    mov al,'='
Paddle_Loop:
    mov [es:di],ax
    add di,2
    loop Paddle_Loop
    ret 

Erase_Paddle:
    mov ax,0xb800
    mov es,ax
    mov ax,22 
    mov bl,80
    mul bl
    add ax,[Paddle_X] 
    shl ax,1   
    mov di,ax
    mov cx,7
Erase_Loop:
    mov word[es:di],0x0720 
    add di,2
    loop Erase_Loop
    ret 

Draw_Ball:
    mov ax,0xb800
    mov es,ax
    mov ax,[Ball_Row]
    mov bl,80
    mul bl
    add ax,[Ball_Col]
    shl ax,1
    mov di,ax
    mov ah,0x0E ;Ball Color
    mov al,'O'
    mov [es:di],ax
    ret 

Erase_Ball:
    ; === BORDER PROTECTION ===
    mov ax,0xb800
    mov es,ax
    
    mov ax,[Ball_Row]
    mov bl,80
    mul bl
    add ax,[Ball_Col]
    shl ax,1
    mov di,ax

    cmp word [Ball_Row], 0
    jle Restore_Border      

    mov word[es:di],0x0720
    ret 

Restore_Border:
    mov word[es:di], 0x032A 
    ret

Move_Ball:
    call Erase_Ball 
    mov ax,[Ball_Col]
    add ax,[Ball_DX]
    mov [Ball_Col],ax
    mov ax,[Ball_Row]
    add ax,[Ball_DY]
    mov [Ball_Row],ax

    call Draw_Ball 

    mov cx, 0FFFFh
Delay_Loop:
    loop Delay_Loop
    mov cx, 0FFFFh
Delay_loop:
    loop Delay_loop
    mov cx,0Fh
delay_loop:
    loop delay_loop
    ret 

Erase_One_Brick:
    push bp
    mov bp, sp
    push es
    push ax
    push di
    push cx
    
    cmp si, 1
    jl Erase_Ret        

    mov ax, 0xb800
    mov es, ax
    
    mov ax, si          
    push cx             
    mov bx, 80
    mul bx              
    pop cx              
    add ax, cx          
    shl ax, 1           
    mov di, ax
    
    mov cx, 6           
    mov ax, 0x0720      
    
Erase_Brick_Loop:
    mov [es:di], ax
    add di, 2
    loop Erase_Brick_Loop
    
Erase_Ret:
    pop cx
    pop di
    pop ax
    pop es
    pop bp
    ret 

;=========================================================
; DRAW 0/1 PATTERN ROUTINE (FIXED)
; Uses 0xDB (Block) for better visibility
;=========================================================
Print_Big_Msg_Loop:
    cld                 ; Clear Direction Flag (Ensure Forward)
    mov dx, 5           ; Loop 5 times (5 lines)
    
.line_loop:
    push ax             ; Save Row
    push bx             ; Save Col
    push dx             ; Save Counter
    push si             ; Save String Pointer
    
    ; --- Calculate DI ---
    push ax
    push bx
    mov cx, 80
    mul cx              
    pop bx
    add ax, bx          
    shl ax, 1           
    mov di, ax
    pop ax              
    
    mov ax, 0xb800
    mov es, ax
    
.char_loop:
    lodsb               ; AL = [SI], SI++
    cmp al, 0           
    je .next_line_prep
    
    cmp al, '1'
    je .draw_red
    
    ; Draw Black Space (0)
    mov ax, 0x0020      ; 00=Black BG, 20=Space
    mov [es:di], ax
    jmp .next_char

.draw_red:
    ; Draw Red Block (1)
    ; Char 0xDB is a solid block. Color 0x0C (Light Red)
    mov ax, 0x0CDB      
    mov [es:di], ax

.next_char:
    add di, 2
    jmp .char_loop
    
.next_line_prep:
    pop si              ; Restore start of line
    ; Find 0 to move to next line
.find_null:
    lodsb
    cmp al, 0
    jne .find_null
    ; SI now points to start of next string
    
    pop dx
    pop bx
    pop ax
    
    inc ax              ; Next Row
    dec dx
    cmp dx, 0
    jne .line_loop      ; If dx > 0, do next line
    
    ; --- Flush Buffer & Wait ---
.flush:
    mov ah, 01h
    int 16h
    jz .wait
    mov ah, 00h
    int 16h
    jmp .flush
.wait:
    mov ah, 00h
    int 16h
    jmp Game_Exit
    ret

; B R G B I R G B 
;RG=6, GB=3 , RB=5

start:
    call ClrScr

    mov dh,0
    mov dl,0 
    call Print_Top_Border

    mov dh,24
    call Print_Side_Borders
    call Draw_Mid_Line
    call Break_Right_Box
    call Print_message_1
    call Print_message_2

    push word[Current_Score]
    call Print_Score
    push ax
    mov ax,[Total_Lives]
    push ax
    call Print_Lives
    pop ax

    call Print_Rows
    call Draw_Paddle
    call Draw_Ball

; =============================================================
; MAIN GAME LOOP
; =============================================================

Game_Loop:

    call Paddle_Movement 
   ; --- Calculate Candidate Positions ---

    mov bx, [Ball_Col]
    add bx, [Ball_DX]   ; bx = New Column

    mov si, [Ball_Row]
    add si, [Ball_DY]   ; si = New Row
    ; --- Side Wall Collision Check ---

    cmp bx, 2           ; Left Wall
    jge Check_Right_Wall
    jmp Flip_dx_left    ; Far jump handler

Check_Right_Wall:
    cmp bx, 54          
    jle After_Side_Walls
    jmp Flip_dx_right   ; Bounce back if > 54

After_Side_Walls:

;---------------------------------------------------------
; IMPROVED COLLISION LOGIC
;---------------------------------------------------------
Brick_Collision_Entry:
    ; 1. Vertical Bounds Check
    cmp si, 0            ; Check Top Wall (Row 0)
    jle Handle_Top_Bounce_A

    cmp si, 22           ; Check Paddle (Row 22)
    je Check_Paddle_Collision_A
    cmp si, 24           ; Check Bottom (Game Over)
    jae Life_Lost_Handler_A

    ; 2. Horizontal Bounds Check (Side Walls)
    ; Note: Side wall bounces are handled BEFORE this block in your code
    ; so we just need to make sure we don't read garbage memory.
    cmp bx, 0
    jl After_bottom_A      ; Safety: Don't read negative col
    cmp bx, 79
    jg After_bottom_A      ; Safety: Don't read past screen width

    ; 3. Optimization: Only check memory if we are in the "Brick Zone"
    ; Current bricks are Row 1-4. We check 1-6 to be safe for bottom hits.
    cmp si, 6            
    jg After_bottom_A      ; If Row > 6, no bricks there, skip memory read

    ; 4. Check Video Memory Content
    mov ax, 0xb800
    mov es, ax

    ; Calculate DI = (Row * 80 + Col) * 2
    mov ax, si
    push bx              ; Save Col
    mov cx, 80
    mul cx
    pop bx               ; Restore Col
    add ax, bx
    shl ax, 1
    mov di, ax

    mov dx, [es:di]      ; Read character + attribute
    cmp dl, 0x20         ; Is it a Space?
    je Brick_Miss_Pop    ; If Space, NO HIT.

    ; === HIT DETECTED ===
    ; Verify it's not a color attribute glitch (Optional but safer)
    ; Assuming bricks are drawn with '#' or similar non-null char
    cmp dl, 0            ; Check for null char just in case
    je Brick_Miss_Pop

    ; --- Handle Brick Removal ---
    ; Calculate Brick Index Logic...
    push ax              ; Save registers if needed
    
    ; Re-calculate Col for Erase function
    mov ax, bx           ; AX = Column
    dec ax               ; Adjust for offset
    xor ah, ah
    mov cl, 6
    div cl               ; AL = Brick Index
    mul cl               ; AX = Start Col relative
    inc ax               ; AX = Actual Start Col
    
    mov cx, ax           ; CX = Start Col argument
    push si              ; Push Row
    push cx              ; Push Start Col
    call Erase_One_Brick
    pop ax

    ; Update Score
    inc word [Current_Score]
    push word [Current_Score]
    call Print_Score

    ; Check Win
    cmp word [Current_Score], 36
    je Win_Handler_Jump

  ; ===========================================
    ; FIX FOR BALL DISAPPEARING AT TOP
    ; ===========================================
    
    ; Check: Kya hum Top Wall k bilkul sath hain?
    mov ax, [Ball_Row]
    cmp ax, 1           ; Agar Row 0 ya 1 hai
    jle Force_Down_Fix  ; To Zabar-dasti Neechay bhejo

    ; Normal Bounce (Baki screen k liye)
    mov ax, [Ball_DY]
    neg ax
    mov [Ball_DY], ax
    jmp After_bottom
Handle_Top_Bounce_A:
jmp Handle_Top_Bounce 
Check_Paddle_Collision_A:
jmp Check_Paddle_Collision

Force_Down_Fix:
    mov word [Ball_DY], 1   ; Force Direction DOWN
    jmp After_bottom
Life_Lost_Handler_A:
jmp Life_Lost_Handler
After_bottom_A:
jmp After_bottom


; ==========================================================
;   FIXED HANDLE TOP BOUNCE
; ==========================================================
Handle_Top_Bounce:
    mov word [Ball_DY], 1    ; Change direction to DOWN
    
    ; --- CRITICAL FIX ---
    ; We must re-calculate the target Row (si) because direction changed.
    ; If we don't, the ball will move into the brick at Row 1 without checking.
    
    mov si, [Ball_Row]       ; Get current Row (0)
    add si, [Ball_DY]        ; Add new DY (1) -> si = 1
    
    jmp Brick_Collision_Entry ; Re-check collision with new values       ; <--- Ball ko move honay den
Check_Paddle_Collision:
    jmp Check_Paddle

Brick_Miss_Pop:
    jmp After_bottom    

; ==========================================================
;   ADD THIS MISSING PART HERE
; ==========================================================
Win_Handler_Jump:
    jmp You_Won_Game
; ==========================================================

; ==========================================================
;        CHECK TOP WALL
; ==========================================================
Check_Top_Wall:
    cmp si, 1            
    jg Check_Paddle      
    
    mov word [Ball_DY], 1    
    
    cmp word [Ball_Row], 0
    jge .No_Clamp
    mov word [Ball_Row], 0
.No_Clamp:

    mov si, [Ball_Row]
    add si, [Ball_DY]   
    
    jmp Brick_Collision_Entry

Check_Paddle:
    mov ax, [Ball_DY]
    cmp ax, 0
    jle After_Paddle_Check  

    cmp si, 22
    jne After_Paddle_Check
    
    mov ax, [Paddle_X]
    mov cx, ax
    add cx, 7               
    
    cmp bx, ax
    jb After_Paddle_Check
    cmp bx, cx
    ja After_Paddle_Check
    ; === PADDLE HIT ===
    mov di, ax
    add di, 3
    mov ax, bx
    sub ax, di
    
    cmp ax, 0
    jl Set_Left_Bounce
    jg Set_Right_Bounce
    
    mov word [Ball_DX], 0
    jmp Do_Bounce

Set_Left_Bounce:
    mov word [Ball_DX], -1
    jmp Do_Bounce

Set_Right_Bounce:
    mov word [Ball_DX], 1

Do_Bounce:
    mov ax, [Ball_DY]
    neg ax
    mov [Ball_DY], ax
    jmp After_bottom

After_Paddle_Check:
    cmp si, 24
    jae Life_Lost_Handler
    jmp After_bottom

;---------------------------------------------------------
; JUMP HANDLERS
;---------------------------------------------------------
Flip_dx_left:
    mov ax, [Ball_DX]
    neg ax
    mov [Ball_DX], ax
    mov bx, [Ball_Col]
    add bx, [Ball_DX]
    jmp After_Side_Walls

Flip_dx_right:
    mov ax, [Ball_DX]
    neg ax
    mov [Ball_DX], ax
    mov bx, [Ball_Col]
    add bx, [Ball_DX]
    jmp After_Side_Walls

Life_Lost_Handler:
    jmp Lose_Life

After_bottom:

    call Move_Ball
   
    mov cx, 0x1100      ; Delay speed
Delay_Loop_Game:
    loop Delay_Loop_Game
    jmp Game_Loop

;---------------------------------------------------------
; GAME END HANDLERS
;---------------------------------------------------------
You_Won_Game:
    call ClrScr
    mov si, msg_win_1
    mov ax, 10          ; Start Row
    mov bx, 18          ; Start Col
    call Print_Big_Msg_Loop
    jmp Game_Exit

Game_Over_Screen:
    call ClrScr
    mov si, msg_loss_1
    mov ax, 10          ; Start Row
    mov bx, 15          ; Start Col
    call Print_Big_Msg_Loop
    jmp Game_Exit

;---------------------------------------------------------
; LOSE LIFE ROUTINE
;---------------------------------------------------------
Lose_Life: 
    dec word[Total_Lives]
    
    ; ===================================
    ;       GAME OVER CHECK
    ; ===================================
    cmp word[Total_Lives], 0
    je Game_Over_Screen        ; Jump to Game Over

    push word[Total_Lives]
    call Print_Lives
    call Erase_Ball
    
    ; --- Reset Position ---
    mov word[Ball_Row], 21
    mov ax, [Paddle_X]
    add ax, 3
    mov [Ball_Col], ax
    
    ; --- Force Straight Up on Reset ---
    mov word[Ball_DX], 0    ; Straight Up
    mov word[Ball_DY], -1
    
    call Draw_Ball
    
    mov cx, 0FFFFh
Delay_Lose:
    loop Delay_Lose
    mov cx, 0xFFFF      
Delay_Lose2:
    loop Delay_Lose2

    jmp Game_Loop

;============================================================
;===================Paddle Movement Area=====================
;============================================================

Paddle_Movement:
     mov ah, 01h
     int 16h
     jz NoKey

     mov ah, 00h
     int 16h

     cmp ah, 4Bh    ; Left Arrow
     je MoveLeft

     cmp ah, 4Dh    ; Right Arrow
     je MoveRight
     
     cmp ah, 01h    ; ESC Key
     je Game_Exit

     jmp NoKey

MoveLeft:
     cmp word[Paddle_X], 2
     jbe NoKey
     call Erase_Paddle
     sub word[Paddle_X], 2    
     cmp word[Paddle_X], 2
     jge .DrawL
     mov word[Paddle_X], 2    
.DrawL:
     call Draw_Paddle
     jmp NoKey

MoveRight:
     cmp word[Paddle_X], 48
     jae NoKey
     call Erase_Paddle
     add word[Paddle_X], 2    
     cmp word[Paddle_X], 48
     jle .DrawR
     mov word[Paddle_X], 48   
.DrawR:
     call Draw_Paddle
     jmp NoKey

NoKey:
     ret

;=========================================================
; EXIT
;=========================================================
Game_Exit:
    mov ah, 0x00
    mov al, 0x03    ; Return to Text Mode (Clear Screen)
    int 10h

    mov ax, 0x4c00
    int 0x21