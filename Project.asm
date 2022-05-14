data segment 
n_l db 13, 10, "$" 
 Draw_G db "_|_|_", 13, 10
db "_|_|_", 13, 10
db "_|_|_", 13, 10, "$" 
 Game_Turn db 9 DUP(?) 
 win_flag db 0 
player db "0$" 
 End_msg db "Game Ends Here", 13, 10, "$" 
game_start_message db "Game Starts now ", 13, 10, "$"
player_message db "Player turn $" 
win_message db " Wins!$" 
type_message db "Position : $"
ends 
 stack segment
dw 128 dup(?)
ends 
 extra segment 
 ends 
 code segment
start: 
mov ax, data
mov ds, ax
mov ax, extra
mov es, ax 
 
call set_Game_Turn 
 main_loop: 
call Clear_scr 
 lea dx, game_start_message 
call print 
 lea dx, n_l
call print 
 lea dx, player_message
call print
lea dx, player
call print 
 lea dx, n_l
call print 
 lea dx, Draw_G
call print 
 lea dx, n_l
call print 
 lea dx, type_message 
call print 
call R_K 
sub al, 49 
mov bh, 0
mov bl, al 
 call update_draw 
 call check 
 cmp win_flag, 1 
je game_over 
 call change_player 
 jmp main_loop 
 
change_player: 
lea si, player 
xor ds:[si], 1 
 ret 
 
update_draw:
mov bl, Game_Turn[bx]
mov bh, 0 
 lea si, player 
 cmp ds:[si], "0"
je draw_x 
 cmp ds:[si], "1"
je draw_o 
 draw_x:
mov cl, "x"
jmp update 
 draw_o: 
mov cl, "o" 
jmp update 
 update: 
mov ds:[bx], cl 
 ret 
 
check:
call check_line
ret 
 
check_line:
mov cx, 0 
 check_line_loop: 
cmp cx, 0
je first_line 
 cmp cx, 1
je second_line 
 cmp cx, 2
je third_line 
 call check_column
ret 
 first_line: 
mov si, 0 
jmp do_check_line 
 second_line: 
mov si, 3
jmp do_check_line 
 third_line: 
mov si, 6
jmp do_check_line 
 do_check_line:
inc cx 
 mov bh, 0
mov bl, Game_Turn[si]
mov al, ds:[bx]
cmp al, "_"
je check_line_loop 
 inc si
mov bl, Game_Turn[si] 
cmp al, ds:[bx]
jne check_line_loop 
 inc si
mov bl, Game_Turn[si] 
cmp al, ds:[bx]
jne check_line_loop 
 
mov win_flag, 1
ret 
 
check_column:
mov cx, 0 
 check_column_loop: 
cmp cx, 0
je first_column 
 cmp cx, 1
je second_column 
 cmp cx, 2
je third_column 
 call check_diagonal
ret 
 first_column: 
mov si, 0 
jmp do_check_column 
 second_column: 
mov si, 1
jmp do_check_column 
 third_column: 
mov si, 2
jmp do_check_column 
 do_check_column:
inc cx 
 mov bh, 0
mov bl, Game_Turn[si]
mov al, ds:[bx]
cmp al, "_"
je check_column_loop 
 add si, 3
mov bl, Game_Turn[si] 
cmp al, ds:[bx]
jne check_column_loop 
 add si, 3
mov bl, Game_Turn[si] 
cmp al, ds:[bx]
jne check_column_loop 
 
mov win_flag, 1
ret 
 
check_diagonal:
mov cx, 0 
 check_diagonal_loop: 
cmp cx, 0
je first_diagonal 
 cmp cx, 1
je second_diagonal 
 ret 
 first_diagonal: 
mov si, 0 
mov dx, 4
jmp do_check_diagonal 
 second_diagonal: 
mov si, 2
mov dx, 2
jmp do_check_diagonal 
 do_check_diagonal:
inc cx 
 mov bh, 0
mov bl, Game_Turn[si]
mov al, ds:[bx]
cmp al, "_"
je check_diagonal_loop 
 add si, dx
mov bl, Game_Turn[si] 
cmp al, ds:[bx]
jne check_diagonal_loop 
 add si, dx
mov bl, Game_Turn[si] 
cmp al, ds:[bx]
jne check_diagonal_loop 
 
mov win_flag, 1
ret 
 
game_over: 
call Clear_scr 
 lea dx, game_start_message 
call print 
 lea dx, n_l
call print 
 lea dx, Draw_G
call print 
 lea dx, n_l
call print 
 lea dx, End_msg
call print 
 lea dx, player_message
call print 
 lea dx, player
call print 
 lea dx, win_message
call print 
 jmp fim 
 
set_Game_Turn:
lea si, Draw_G
lea bx, Game_Turn 
 mov cx, 9 
 loop_1:
cmp cx, 6
je add_1 
 cmp cx, 3
je add_1 
 jmp add_2 
 add_1:
add si, 1
jmp add_2 
 add_2: 
mov ds:[bx], si 
add si, 2 
 inc bx 
loop loop_1 
 ret 
 
print: 
mov ah, 9
int 21h 
 ret 
 
Clear_scr: 
mov ah, 0fh
int 10h 
 mov ah, 0
int 10h 
 ret 
 
R_K: 
mov ah, 1 
int 21h 
 ret 
 
fim:
jmp fim 
 code ends 
 end start
