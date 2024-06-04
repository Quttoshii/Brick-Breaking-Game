.model small
.stack 100h

startPage macro				;STARTING PAGE------Page Number 0
	
	mov pageNum, 0	

	mov ah,6h			;set background
	mov al,0
	mov cx,0		
	mov dh,80
	mov dl,80
	mov bh,14h			
	int 10h

	call lines

endm

mainMenu macro				;MAIN MENU------Page Number 1

	call clearPrevScr
	mov pageNum, 1

	mov ah, 0Bh
	mov bh, 00h			;setting background colour
	mov bl, 0Bh			;setting black colour
	int 10h

	call designMenu
	call options
	
endm

namePage macro				;NAME PAGE--------Page Number 4
	mov pageNum, 4
	call clearPrevScr

	call nameLines

endm

instructions macro			;INSTRUCTIONS------Page Number 3
	call clearPrevScr
	
	mov pageNum, 3

	mov ah,0bh  	;set configuration to bg color
	mov bh,00h
	mov bl,01   	;black as bg
	int 10h
	
	call instruc

endm

levelOne macro				;First Level------Page Number 2

	mov pageNum, 2
	call clearPrevScr

	

	checkTime:
		.if lives == 0
			jmp endGame
		.endif

		mov ah,2ch		;to get system time
		int 21h		;ch=hour cl=minute dh=second dl=1/100 second

				;is the current time equal to the previous time
		cmp dl,time_ax	
		je checkTime	;if same then check again

		mov time_ax,dl	;updating time
		
		call moveslate
		call drawslate

		call checkCol	
		call checkSlate

		call moveBall
		call drawBall

		call drawLives
		call drawScore
	
		mov brick_colour, 0Ah
		call drawbrick
		
		.if score == 11 
			jmp outside
		.endif
	
		mov ah,01h
		int 16h
		jz checkTime
		mov ah,00h
		int 16h
		.if al == 'p'
			call pauseScreen
		.endif
	jmp checkTime
	outside:
		levelTwo
	endGame:
		call WriteFile
		gameOver
endm

levelTwo macro				;Second Level------Page Number 5

	mov pageNum, 5
	call clearPrevScr
	inc levels
	mov velocityX, 4h
	mov velocityY, 4h
	mov slate_velocity, 6

	mov flagB1, 0
	mov flagB2, 0
	mov flagB3, 0
	mov flagB4, 0
	mov flagB5, 0
	mov flagB6, 0
	mov flagB7, 0
	mov flagB8, 0
	mov flagB9, 0
	mov flagB10, 0
	mov flagB11, 0

	mov time_ax, 0

	mov slate_width, 50
	checkTime5:
		.if lives == 0
			jmp endGame2
		.endif

		mov ah,2ch		;to get system time
		int 21h		;ch=hour cl=minute dh=second dl=1/100 second

				;is the current time equal to the previous time
		cmp dl,time_ax	
		je checkTime	;if same then check again

		mov time_ax,dl	;updating time
		
		call moveslate
		call drawslate

		call checkCol	
		call checkSlate

		call moveBall
		call drawBall

		call drawLives
		call drawScore
	
		mov brick_colour, 02
		call drawbrick

		mov ah,01h
		int 16h
		jz checkTime5
		mov ah,00h
		int 16h
		.if al == 'p'
			call pauseScreen
		.endif

	jmp checkTime5
	
	endGame2:
		call WriteFile
		gameOver
endm

gameOver macro					;Game Over Screen-----------Page Number 9

	mov pageNum, 9
	call clearPrevScr

	mov ah,0bh  	;set configuration to bg color
	mov bh,00h
	mov bl,01   	;black as bg
	int 10h

	call g_screen

	mov ah, 4ch
	int 21h
endm

.data
pageNum dw 0

;------------------------------Page 0 Variables
line1 db 'BRICK BREAKER GAME','$'
line2 db 'Developers','$'
line3 db 'Afaq Alam   <21i-1700>','$'
line4 db 'Eman Tahir  <21i-1718>','$'
line5 db 'Shizra Burney  <21i-2660> ','$'

;-----------------------------Page 1 Variables
option1 db '1) Start ','$'
option2 db '2) High Scores','$'
option3 db '3) Instructions','$'
option5 db '4) Exit','$'
axisLim dw 0				;to set limit when drawing lines
temp dw 0				;temporary variable not being used anywhere

;----------------------------Page 2 Variables
window_w dw 320   		;320,as per video mode
window_h dw 200	   	;200 as per video mode
window_bounds dw 6		;to check collsion a bit before the boundary

;---------------------------

fname db 'Highscores.txt',0
levels db 1
;---------------------------

brick_width dw 42
brick_height dw 16
brick_colour db 0

			;for bricks in first row
brick_1x dw 10
brick_1y dw 2Ah

brick_2x dw 58
brick_2y dw 2Ah

brick_3x dw 106
brick_3y dw 2Ah

brick_4x dw 154
brick_4y dw 2Ah

brick_5x dw 202
brick_5y dw 2Ah

brick_6x dw 250
brick_6y dw 2Ah


			;for bricks in second row
brick_7x dw 20
brick_7y dw 64

brick_8x dw 68
brick_8y dw 64

brick_9x dw 116
brick_9y dw 64

brick_10x dw 164
brick_10y dw 64

brick_11x dw 212
brick_11y dw 64

			;for ball

ball_x dw 4Ah		;x axis
ball_y dw 9Fh		;y axis
ball_size dw 04h 		;16 pixels in total,4 for x axis ,4 for y axis
time_ax db 0 		;variable used to check if time has changed
velocityX dw 3h		;velocity of th ball in the x axis
velocityY dw 3h

new_ball dw 06h
temp_x dw ?
temp_y dw ?
			;slate
slatex dw 40
slatey dw 169

slate_width dw 82
slate_height  dw 5

slate_velocity dw 05

tempsx dw 0
tempsy dw 0

temp_slate_width dw 8
temp_slate_height dw 7
temp_slate_x dw ?
temp_slate_y dw ?

			;collision
flagB1 dw 0
flagB2 dw 0
flagB3 dw 0
flagB4 dw 0
flagB5 dw 0
flagB6 dw 0
flagB7 dw 0
flagB8 dw 0
flagB9 dw 0
flagB10 dw 0
flagB11 dw 0

			;scoring & lives
scoreStr db 'Score: ','$'
score dw 0
livesStr db 'Lives: ','$'
heart0 db ' ', ' ', ' ', '$'
heart1 db 3, ' ', ' ', '$'
heart2 db 3, 3, ' ', '$'
heart3 db 3, 3, 3,'$'
lives db 3
count db 0

;----------------------------Page 3 Variables
line_1 db 'INSTRUCTIONS','$'
line_2 db '   When a brick is hit, the ball bounces      away and the brick is destroyed.','$'
line_3 db 'The Player looses a life when the     ball touches the bottom of the screen.','$'
line_4 db 'Left Arrow Key = Move Slate Left','$'
line_5 db 'Right Arrow Key = Move Slate Right','$'
line_6 db 'Press Enter to go Back','$'

;----------------------------Page 4 Variables
name_line1 db 'Welcome to the Game','$'
name_line2 db 'Please enter your name below','$'
name_line4 db 'Hello Player  ','$'
playerName db 50 dup('$')

;---------------------------Page 8 Variables
pscreen_line1 db '1) Resume','$'
pscreen_line2 db '2) Instructions','$'
pscreen_line3 db '3) Exit','$'

;---------------------------Page 9 Variables
gameover_line1 db 'Game Over','$'

.code

pauseScreen proc				;Pause Screen---------------Page Number 8
	up:
	mov pageNum, 8
	call clearPrevScr

	mov ah,0bh  	;set configuration to bg color
	mov bh,00h
	mov bl,01   	;black as bg
	int 10h
	
	call pause_screen

	mov ah, 0			;taking user input
	int 16h
	.if al == '1'
		jmp down
	.elseif al == '2'
		instructions
		mov ah, 0			;taking user input
		int 16h
		.if al == 13
			jmp up
		.endif
	.elseif al == '3'
		gameOver
	.endif
	down:
	call clearPrevScr
	ret
pauseScreen endp

clearPrevScr proc				;Clearing previous screen to black

	mov ah, 0Ch			;setting to write pixel
	mov al, 00			
	mov bx, pageNum			;setting page number

	mov cx, 0
	mov dx, 0	
	int 10h

	mov axisLim, 320
	FHBlocks:				;to display different colour blocks
		FHTop:				;First Half Top
			mov cx, 0
			call drawHorLine
			inc dx			;setting row (Y-axis)
			cmp dx, 200
			je FHBottom
			jmp FHTop
		FHBottom:

ret
clearPrevScr endp

lines Proc				;TO WRITE ON START PAGE	

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 06h			;set row
	mov dl, 0Ah			;set column
	int 10h	

	
	mov ah, 09h
	mov dx, offset line1
	int 21h

	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 0Ah			
	mov dl, 0Fh			
	int 10h
	
	mov ah, 09h
	mov dx, offset line2
	int 21h

	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 0Ch			
	mov dl, 0Ah			
	int 10h
	
	mov ah, 09h
	mov dx, offset line3
	int 21h


	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 0Eh			
	mov dl, 0Ah			
	int 10h
	
	mov ah, 09h
	mov dx, offset line4
	int 21h

	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 16			
	mov dl, 0Ah			
	int 10h
	
	mov ah, 09h
	mov dx, offset line5
	int 21h

	
ret
lines endp

designMenu proc				;TO DECORATE MAIN MENU
	
	mov ah, 0Ch			;setting to write pixel
	mov al, 0Ah			;choosing light green colour
	mov bx, pageNum			;setting page number
	mov cx, 0
	mov dx, 0	
	int 10h
	mov axisLim, 64
	FHBlocks:				;to displayh different colour blocks
		FHTop:				;First Half Top
			mov cx, temp
			call drawHorLine
			inc dx			;setting row (Y-axis)
			cmp dx, 60
			je FHBottom
			jmp FHTop
		FHBottom:
		add cx, 64
		xchg cx, axisLim
		mov temp, cx
		inc al				;changing to next colour
		mov dx, 0
		cmp cx, 320
		jne FHBlocks
	
	mov temp, 0
	mov al, 0Ah				;choosing light green colour
	mov axisLim, 64
	mov dx, 140
	SHBlocks:				;Second Half Blocks
		SHTop:				;Second Half Top
			mov cx, temp
			call drawHorLine
			inc dx			;setting row (Y-axis)
			cmp dx, 200
			je SHBottom
			jmp SHTop
		SHBottom:
		add cx, 64
		xchg cx, axisLim
		mov temp, cx
		inc al				;changing to next colour
		mov dx, 140
		cmp cx, 320
		jne SHBlocks

ret
designMenu endp

options Proc				;TO DISPLAY MENU OPTIONS

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 08h			;set row
	mov dl, 0Ah			;set column
	int 10h
	
	mov ah, 09h
	mov dx, offset option1
	int 21h

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 0Ah			;set row
	mov dl, 0Ah			;set column
	int 10h
	
	mov ah, 09h
	mov dx, offset option2
	int 21h

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 0Ch			;set row
	mov dl, 0Ah			;set column
	int 10h
	
	mov ah, 09h
	mov dx, offset option3
	int 21h

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 0Eh			;set row
	mov dl, 0Ah			;set column
	int 10h
	
	mov ah, 09h
	mov dx, offset option5
	int 21h
ret
options endp


drawVerLine proc				;TO DRAW VERTICAL LINE
	DVLTop:
		int 10h
		inc dx
		cmp dx, axisLim
		je DVLBottom
		jmp DVLTop
	DVLBottom:
ret
drawVerLine endp

drawHorLine proc				;TO DRAW HORIZONTAL LINE
	
	DHLTop:
		int 10h
		inc cx
		cmp cx, axisLim
		je DHLBottom
		jmp DHLTop
	DHLBottom:
ret
drawHorLine endp

brick1 proc

mov cx,0
mov dx,0

mov cx,brick_1x			;initializing the starting positions
mov dx, brick_1y

	horizontal1:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour 			;chose  colour
		mov bx, pageNum
		int 10h

		inc cx				;incrementing the value of x axis(till width)
		mov ax,cx				;storing it
		sub ax,brick_1x			;for comparing later on
		cmp ax, brick_width		;comparing it with the width to make sure repetative pixels are not out of bound (width)
		jng horizontal1

		mov cx,brick_1x			;initializing the starting positions
		inc dx				;incrementing the value of y axis (till height)

		mov ax,dx				;same as above
		sub ax,brick_1y
		cmp ax,brick_height
		jng horizontal1


ret
brick1 endp

brick2 proc
mov cx,0
mov dx,0

mov cx,brick_2x
mov dx, brick_2y

	horizontal2:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_2x
		cmp ax, brick_width
		jng horizontal2

		mov cx,brick_2x
		inc dx

		mov ax,dx
		sub ax,brick_2y
		cmp ax,brick_height
		jng horizontal2

ret
brick2 endp

brick3 proc
mov cx,0
mov dx,0

mov cx,brick_3x
mov dx, brick_3y

	horizontal3:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_3x
		cmp ax, brick_width
		jng horizontal3

		mov cx,brick_3x
		inc dx

		mov ax,dx
		sub ax,brick_3y
		cmp ax,brick_height
		jng horizontal3

ret 
brick3 endp


brick4 proc
mov cx,0
mov dx,0

mov cx,brick_4x
mov dx, brick_4y

	horizontal4:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_4x
		cmp ax, brick_width
		jng horizontal4

		mov cx,brick_4x
		inc dx

		mov ax,dx
		sub ax,brick_4y
		cmp ax,brick_height
		jng horizontal4


ret 
brick4 endp


brick5 proc
mov cx,0
mov dx,0

mov cx,brick_5x
mov dx, brick_5y

	horizontal5:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_5x
		cmp ax, brick_width
		jng horizontal5

		mov cx,brick_5x
		inc dx

		mov ax,dx
		sub ax,brick_5y
		cmp ax,brick_height
		jng horizontal5


ret 
brick5 endp


brick6 proc
mov cx,0
mov dx,0

mov cx,brick_6x
mov dx, brick_6y

	horizontal6:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_6x
		cmp ax, brick_width
		jng horizontal6

		mov cx,brick_6x
		inc dx

		mov ax,dx
		sub ax,brick_6y
		cmp ax,brick_height
		jng horizontal6

ret 
brick6 endp


brick7 proc
mov cx,0
mov dx,0

mov cx,brick_7x
mov dx, brick_7y

	horizontal7:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_7x
		cmp ax, brick_width
		jng horizontal7

		mov cx,brick_7x
		inc dx

		mov ax,dx
		sub ax,brick_7y
		cmp ax,brick_height
		jng horizontal7

ret 
brick7 endp


brick8 proc
mov cx,0
mov dx,0

mov cx,brick_8x
mov dx, brick_8y

	horizontal8:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_8x
		cmp ax, brick_width
		jng horizontal8

		mov cx,brick_8x
		inc dx

		mov ax,dx
		sub ax,brick_8y
		cmp ax,brick_height
		jng horizontal8

ret 
brick8 endp


brick9 proc
mov cx,0
mov dx,0

mov cx,brick_9x
mov dx, brick_9y

	horizontal9:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_9x
		cmp ax, brick_width
		jng horizontal9

		mov cx,brick_9x
		inc dx

		mov ax,dx
		sub ax,brick_9y
		cmp ax,brick_height
		jng horizontal9

ret 
brick9 endp


brick10 proc
mov cx,0
mov dx,0

mov cx,brick_10x
mov dx, brick_10y

	horizontal10:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour 			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_10x
		cmp ax, brick_width
		jng horizontal10

		mov cx,brick_10x
		inc dx

		mov ax,dx
		sub ax,brick_10y
		cmp ax,brick_height
		jng horizontal10

ret 
brick10 endp


brick11 proc
mov cx,0
mov dx,0

mov cx,brick_11x
mov dx, brick_11y

	horizontal11:

		mov ah,0Ch	 			;write pixel
		mov al, brick_colour  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,brick_11x
		cmp ax, brick_width
		jng horizontal11

		mov cx,brick_11x
		inc dx

		mov ax,dx
		sub ax,brick_11y
		cmp ax,brick_height
		jng horizontal11

ret 
brick11 endp

drawbrick proc			;draw bricks procedure(draws all bricks and the slate too)
	
	;mov dl, 02
	mov cx, flagB1
	mov dl, 0Ah
	call changeColour
	call brick1

	mov cx, flagB2
	mov dl, 03h
	call changeColour
	call brick2

	mov cx, flagB3
	mov dl, 0Ch
	call changeColour
	call brick3

	mov cx, flagB4
	mov dl, 0Dh
	call changeColour
	call brick4

	mov cx, flagB5
	mov dl, 0Eh
	call changeColour
	call brick5
	
	mov cx, flagB6
	mov dl, 07h
	call changeColour
	call brick6

	mov cx, flagB7
	mov dl, 37
	call changeColour
	call brick7

	mov cx, flagB8
	mov dl, 05h
	call changeColour
	call brick8

	mov cx, flagB9
	mov dl, 04h
	call changeColour
	call brick9

	mov cx, flagB10
	mov dl, 09h
	call changeColour
	call brick10

	mov cx, flagB11
	mov dl, 02h
	call changeColour
	call brick11

mov cx,0
mov dx,0

mov cx,slatex
mov dx, slatey

	horizontalS:

		mov ah,0Ch	 			;write pixel
		mov al,06h  			;chose white as colour
		mov bh,00h
		int 10h

		inc cx
		mov ax,cx
		sub ax,slatex
		cmp ax, slate_width
		jng horizontalS

		mov cx,slatex
		inc dx

		mov ax,dx
		sub ax,slatey
		cmp ax,slate_height
		jng horizontalS



ret
drawbrick endp

drawBall proc

mov cx,0
mov dx,0

mov cx,ball_x					;set initial positions
mov dx,ball_y

	ballHorizontal:

		mov ah,0Ch	 			;write pixel
		mov al,0fh  			;chose white as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,ball_x
		cmp ax,ball_size
		jng ballHorizontal
	
		mov cx,ball_x  			;to go to initial col
		inc dx	    			;next line
	
							;when dx - ball_y is greater than ballsize, we exit
		mov ax,dx
		sub ax,ball_y
		cmp ax,ball_size
		jng ballHorizontal

ret
drawBall endp

checkSlate proc
	mov ax, slatex
	mov bx, slatey
	sub bx, ball_size
	.if ball_x >= ax 				;collision for ball and slate
		add ax, slate_width
		.if ball_x <= ax			
			.if ball_y >= bx
				add bx, slate_height
				.if ball_y <= bx	
					jmp neg_velocityY2
				.endif
			.endif
		.endif
	.endif

	jmp doNothing
	neg_velocityX2:
		NEG velocityX	;will be equal to its inverse
	ret

	neg_velocityY2:
		NEG velocityY	;will be equal to its inverse
	
	doNothing:
ret
checkSlate endp

checkCol proc
	mov cx, 0
	mov ax, 0
	mov bx, 0
	
	mov cx, flagB1
	mov ax, brick_1x
	mov bx, brick_1y
	call checkBrick
	mov flagB1, cx

	mov cx, flagB2
	mov ax, brick_2x
	mov bx, brick_2y
	call checkBrick
	mov flagB2, cx
	
	mov cx, flagB3
	mov ax, brick_3x
	mov bx, brick_3y
	call checkBrick
	mov flagB3, cx
	
	mov cx, flagB4
	mov ax, brick_4x
	mov bx, brick_4y
	call checkBrick
	mov flagB4, cx
	
	mov cx, flagB5
	mov ax, brick_5x
	mov bx, brick_5y
	call checkBrick
	mov flagB5, cx
	
	mov cx, flagB6
	mov ax, brick_6x
	mov bx, brick_6y
	call checkBrick
	mov flagB6, cx
	
	mov cx, flagB7
	mov ax, brick_7x
	mov bx, brick_7y
	call checkBrick
	mov flagB7, cx
	
	mov cx, flagB8
	mov ax, brick_8x
	mov bx, brick_8y
	call checkBrick
	mov flagB8, cx
	
	mov cx, flagB9
	mov ax, brick_9x
	mov bx, brick_9y
	call checkBrick
	mov flagB9, cx
	
	mov cx, flagB10
	mov ax, brick_10x
	mov bx, brick_10y
	call checkBrick
	mov flagB10, cx
	
	mov cx, flagB11
	mov ax, brick_11x
	mov bx, brick_11y
	call checkBrick
	mov flagB11, cx

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 00h			;set row
	mov dl, 2				;set column
	int 10h	

	
	mov ah, 09h
	mov dx, offset livesStr
	int 21h

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 00h			;set row
	mov dl, 20		;set column
	int 10h	

	mov ah, 09h
	mov dx, offset scoreStr
	int 21h
ret
checkCol endp

drawLives proc

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 00h			;set row
	mov dl, 10		;set column
	int 10h	
	mov ah, 09h
	
	.if lives == 3
		lea dx, heart3
	.elseif lives == 2
		lea dx, heart2
	.elseif lives == 1
		lea dx, heart1
	.elseif lives == 0
		lea dx, heart0
	.endif

	int 21h
ret
drawLives endp

drawScore proc
	
	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 00h			;set row
	mov dl, 28		;set column
	int 10h	
	mov ah, 02h
	
	.if score <= 9
		mov dx, score
		add dx, 48
		
		int 21h
	.else
		mov ax, 0
		mov ax, score ; Moving number to AX

		mov dx,0 ; As dividend is stored in DX:AX, so moving 0 to DX
	
		mov bx,10 ; We want to Perform DX:AX/BX

		div bx ; Dividing by 10 to get Remainder and Quotient
		
		push ax

		mov ah, 02h			;set cursor position
		mov bx, pageNum			;set page number
		mov dh, 00h			;set row
		mov dl, 28		;set column
		int 10h	

		pop cx
		mov dl, cl
		add dl, 48
		int 21h
		
		mov ah, 02h			;set cursor position
		mov bx, pageNum			;set page number
		mov dh, 00h			;set row
		mov dl, 29		;set column
		int 10h	
		mov ah, 02h
		
		mov dl, ch
		add dl, 48
		int 21h

		
	.endif
ret
drawScore endp

checkBrick proc
	
	.if levels == 1
		cmp cx, 1				;check if the brick is there or not
		je doNothing			;if it is already broken, check next brick
	.elseif levels == 2
		cmp cx, 2
		je doNothing
	.endif
	
	.if ball_x >= ax 				;when ball approaches brick from below
		add ax, brick_width
		.if ball_x <= ax			;check if ball is touching wiht brick from its left & right 
			.if ball_y >= bx
				add bx, brick_height
				.if ball_y <= bx		;check if ball is touching with brick from its top & bottom
					inc cx
					inc score
					jmp neg_velocityY1
				.endif
			.endif
		.endif
	.endif

	jmp doNothing
	neg_velocityX1:
		NEG velocityX	;will be equal to its inverse
	ret

	neg_velocityY1:
		NEG velocityY	;will be equal to its inverse
	
	doNothing:
ret
checkBrick endp

changeColour proc				;to change colour of brick if collided
	.if levels == 1
		.if cx == 1
			mov brick_colour, 0
		.else 
			mov brick_colour, dl
		.endif
	.elseif levels == 2
		.if cx == 1
			mov brick_colour, 0Ah
		.elseif cx == 2
			mov brick_colour, 0
		.else
			mov brick_colour, 02
		.endif
	.endif
ret
changeColour endp

moveBall proc

	mov ax,ball_x
	mov temp_x,ax
	mov ax,ball_y
	mov temp_y,ax

	call drawball
	mov ax,0
	mov ax,velocityX		;deciding on the velocity of the ball
	add ball_x,ax		;move the ball horizontally

	call drawball2

	mov ax,0
	mov ax,velocityX		;deciding on the velocity of the ball
	add ball_x,ax		;move the ball horizontally

	mov ax,window_bounds
	add ax, 2
	cmp ball_x,ax		;if x<window bounds there is collision with left boundary
	jl neg_velocityX

	mov ax,0
	mov ax,window_w
	sub ax,ball_size		; so the ball will not go inside the boundary
	sub ax,window_bounds
	sub ax, 2
	cmp ball_x,ax    	;if x>0 there is collision with right boundary
	jg neg_velocityX
				
	mov ax,0
	mov ax,velocityY		;move the ball vertically
	add ball_y,ax
	
	mov ax, window_bounds
	add ax, 6
	cmp ball_y,ax		;if y<bound there is collision with upper boundary
	jl neg_velocityY

	mov ax,0
	mov ax,window_h
	sub ax,ball_size		;so the ball will not go inside the boundary
	sub ax,window_bounds
	cmp ball_y,ax    	
	jg restartDef		;if y>0 there is collision with lower boundary
	;jg neg_velocityY
	

	;mov ah,00h  	;set video
	;mov al,13h
	;int 10h

	;mov ah,0bh  	;set configuration to bg color
	;mov bh,00h
	;mov bl,01   	;black as bg
	;int 10h
	
	call drawball2

	dec ball_y		;moving the ball
	dec ball_x
	
ret

restartDef:
	dec lives
	mov ball_x, 7Ah		;x axis
	mov ball_y, 5Fh		;y axis
	ret

neg_velocityX:
	NEG velocityX	;will be equal to its inverse
	ret

neg_velocityY:
	NEG velocityY	;will be equal to its inverse

ret
moveBall endp

drawball2 proc

mov cx,temp_x
mov dx,temp_y

	ballHorizontal:

		mov ah,0Ch	 			;write pixel
		mov al,00h  			;chose black as colour
		mov bx, pageNum
		int 10h

		inc cx
		mov ax,cx
		sub ax,temp_x
		cmp ax,new_ball
		jng ballHorizontal
	
		mov cx,temp_x  			;to go to initial col
		inc dx	    			;next line
	
							;when dx - ball_y is greater than ballsize, we exit
		mov ax,dx
		sub ax,temp_y
		cmp ax,new_ball
		jng ballHorizontal

ret
drawball2 endp

clrscreen proc

	mov ah,00h  	;set video
	mov al,13h
	int 10h
	mov ah,0bh  	;set configuration to bg color
	mov bh,00h
	mov bl,01   	;black as bg
	int 10h

ret
clrscreen endp

drawslate proc

mov cx,0
mov dx,0

mov cx,slatex
mov dx, slatey

	horizontalS:

		mov ah,0Ch	 			;write pixel
		mov al,00h  			;chose white as colour
		mov bh, 00h
		int 10h

		inc cx
		mov ax,cx
		sub ax,slatex
		cmp ax, slate_width
		jng horizontalS

		mov cx,slatex
		inc dx

		mov ax,dx
		sub ax,slatey
		cmp ax,slate_height
		jng horizontalS



ret
drawslate endp

drawslate2 proc

mov cx,slatex
mov dx, slatey

mov temp_slate_y, dx
mov temp_slate_x, cx


	horizontalS:

		mov ah,0Ch	 			;write pixel
		mov al,00h  			;chose white as colour
		mov bh,00h
		int 10h

		inc cx
		mov ax,cx
		sub ax,slatex
		cmp ax, slate_width
		jng horizontalS

		mov cx,slatex
		inc dx

		mov ax,dx
		sub ax,slatey
		cmp ax,slate_height
		jng horizontalS

ret
drawslate2 endp

moveslate proc

	;call drawslate
	
	mov ah,01h
	int 16h
	jz exit
	mov ah,00h
	int 16h

	cmp ah,77
	je move_left_slate

	cmp ah,75
	je move_right_slate
	cmp ah,28
	JE done

	jmp exit
	
	move_left_slate:
		call drawslate
		mov ax,slate_velocity
		add slatex,ax
		;add ax,80
		;mov slatex,ax
		call drawslate2
		cmp slatex,320
		je move_left_slate

		jmp exit

	move_right_slate:
		call drawslate
		mov ax,slate_velocity
		sub slatex,ax
		call drawslate2
		cmp slatex,32

		je move_right_slate
		
		jmp exit



	exit:
		call drawslate

	ret 
done:

moveslate endp

instruc Proc				

	mov ah, 02h			;set cursor position
	mov bx, pageNum		;set page number
	mov dh, 02h			;set row
	mov dl, 0Fh			;set column
	int 10h	

	
	mov ah, 09h
	mov dx, offset line_1
	int 21h

	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 05h			
	mov dl, 00h			
	int 10h
	
	mov ah, 09h
	mov dx, offset line_2
	int 21h


	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 08h			
	mov dl, 04h			
	int 10h
	
	mov ah, 09h
	mov dx, offset line_3
	int 21h


	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 0Ch			
	mov dl, 04h			
	int 10h
	
	mov ah, 09h
	mov dx, offset line_4
	int 21h

	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 0Fh
	mov dl, 04h			
	int 10h
	
	mov ah, 09h
	mov dx, offset line_5
	int 21h

	mov ah, 02h			
	mov bx, pageNum			
	mov dh, 19
	mov dl, 04h			
	int 10h
	
	mov ah, 09h
	mov dx, offset line_6
	int 21h
	
ret
instruc endp

nameLines Proc				

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 06h			;set row
	mov dl, 0Ah			;set column
	int 10h	
	
	mov ah, 09h
	mov dx, offset name_line1
	int 21h

	mov ah, 02h			
	mov bx, pageNum			;set page number			
	mov dh, 0Ah			
	mov dl, 06h			
	int 10h

	mov ah, 09h
	mov dx, offset name_line2
	int 21h

	mov dx,13
	mov ah,02                ;carriage feed and line return
	int 21h
	mov dx,10
	mov ah,02
	int 21h

	mov ah, 02h			
	mov bx, pageNum			;set page number			
	mov dh, 0eh			
	mov dl, 06h			
	int 10h
	
	mov si,offset playerName
l1:
	mov ah,01
	int 21h
	cmp al,13
	je prog
	mov [si],al
	inc si
	jmp l1

prog:
	mov ah, 02h			
	mov bx, pageNum			;set page number			
	mov dh, 18			
	mov dl, 04h			
	int 10h
	
	mov ah, 09h
	mov dx, offset name_line4
	int 21h

	mov ah, 09h
	mov dx, offset playerName
	int 21h
	
ret
nameLines endp

g_screen Proc				

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 0Ch			;set row
	mov dl, 0Ch			;set column
	int 10h
	
	mov ah, 09h
	mov dx, offset gameover_line1
	int 21h

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 0Eh			;set row
	mov dl, 0Ch			;set column
	int 10h
	
	mov ah, 09h
	mov dx, offset playerName
	int 21h
	
	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 16			;set row
	mov dl, 0Ch			;set column
	int 10h	

	mov ah, 2h
	.if score <= 9
		mov dx, score
		add dx, 48
		
		int 21h
	.else
		mov ax, 0
		mov ax, score ; Moving number to AX

		mov dx,0 ; As dividend is stored in DX:AX, so moving 0 to DX
	
		mov bx,10 ; We want to Perform DX:AX/BX

		div bx ; Dividing by 10 to get Remainder and Quotient
		
		push ax

		mov ah, 02h			;set cursor position
		mov bx, pageNum			;set page number
		mov dh, 16			;set row
		mov dl, 0Dh			;set column
		int 10h

		pop cx
		mov dl, cl
		add dl, 48
		int 21h
		
		mov ah, 02h			;set cursor position
		mov bx, pageNum			;set page number
		mov dh, 16			;set row
		mov dl, 0Eh			;set column
		int 10h
		mov ah, 02h
		
		mov dl, ch
		add dl, 48
		int 21h
	.endif

ret
g_screen endp

pause_screen Proc				

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 08h			;set row
	mov dl, 0Ah			;set column
	int 10h
	
	mov ah, 09h
	mov dx, offset pscreen_line1
	int 21h

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 0Ah			;set row
	mov dl, 0Ah			;set column
	int 10h
	
	mov ah, 09h
	mov dx, offset pscreen_line2
	int 21h

	mov ah, 02h			;set cursor position
	mov bx, pageNum			;set page number
	mov dh, 0Ch			;set row
	mov dl, 0Ah			;set column
	int 10h

	mov ah, 09h
	mov dx, offset pscreen_line3
	int 21h
	
ret
pause_screen endp

WriteFile proc

;if score<10
	
mov dx,offset fname
mov al,1
mov ah,3dh
int 21h

mov bx,ax
mov cx,0
mov ah,42h
mov al,02h
int 21h
 
mov ah, 40h
	
	mov dx, offset playerName
	mov cx,5  
	int 21h

mov bx,ax
mov cx,0
mov ah,42h
mov al,02h
int 21h

	mov cx,2
	mov dx,offset score
	mov ah, 40h
	
    int 21h

mov bx,ax
mov cx,0
mov ah,42h
mov al,02h
int 21h

	mov cx,2
	mov dx,offset levels
	mov ah, 40h
	
    int 21h
   

mov ah,3eh		;closing file
int 21h


ret
WriteFile endp

main proc				;MAIN PROC

	mov ax, @data
	mov ds, ax

	mov ah, 00h 			;setting video mode
	mov al, 13h 			;choosing video mode
	int 10h
	
	top:
	startPage

	mov ah, 0			;taking user input
	int 16h
	cmp al, 13			;ASCII of enter
	jne top
	
	backToMenu:
	mainMenu

	again:
	mov ah, 0
	int 16h
	.if al == '1'
		namePage
		levelOne
	.elseif al == '3'
		instructions
		mov ah, 0
		int 16h
		.if al == 13
			jmp backToMenu
		.endif
	.elseif al == '4'
		jmp exit
	.else
		jmp again
	.endif
	exit:
		mov ah, 4ch
		int 21h
main endp

end main