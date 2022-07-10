;Liel - good job. You used procedures very nicely and split your code. What you didn't do is use the stack to pass parameters, which you should fix for the
; last work of the year. Also - the division function did not work, it printed garbage output. Last thing - you should add more documentation to your code so it's 
; easier to understand. Please see other comments in code. Your grade is 90.
IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
firstmaes db "If you want to calu enter 1,to exit enter something else",10,13,"$"
message db  "please enter you exercise",10,13,"$"
arr db  22,?, 22 dup (?)
Lennum1 db (?)
opp db 2
Lennum2 db (?)
num1 dw (?)
num2 dw (?)
schom dw (?)
to_mul db 1
message1 db  10, 13,'$'
serit dw (0)
temp dw 1
mes_schom db "The result of the division"
mes_serit db "rest"

;in num1 we have number 1
;in num2 we have number 2
CODESEG

;	Author:Liel
;	Date:27.2.16
proc plus
	mov [schom],0
	mov ax,[word ptr num1]
	add ax,[word ptr num2]
	mov [word ptr schom],ax
	call print_number
	ret
endp plus
proc minos
	;YANAI: It looks like it should be called "result" instead of schom
	mov [schom],0
	mov ax, [word ptr num2]
	cmp ax,	[word ptr num1]
	jg nsmall
	jl normal
	nsmall:
		mov ax, [word ptr num2]	
		sub ax,[word ptr num1]
		mov [word ptr schom],ax
		mov dl, '-' 
		mov ah, 2h
		int 21h
		call print_number
		jmp con
	normal:
		mov ax,[word ptr num1] 
		sub ax,[word ptr num2]
		mov [word ptr schom],ax
		call print_number
		jmp con
	con:
	ret
endp minos
proc cefel
mov [schom],0
		mov ax, [word ptr num1]
		mul [word ptr num2]
		mov [word ptr schom], ax
		mov [word ptr serit], dx
		call print_number
	ret
endp cefel
proc hilok
		mov [schom],0
		mov dx,0
		mov ax, [word ptr num1]
		div [word ptr num2]
		mov ah,0
		mov [word ptr schom],ax
		mov dh,0
		mov [word ptr serit],dx
		mov dx, offset mes_schom
		mov ah, 9h 
		int 21h
		mov dx, offset message1
		mov ah, 9h 
		int 21h
		call print_number
		mov dx, offset message1
		mov ah, 9h 
		int 21h
		mov dx, offset mes_serit
		mov ah, 9h 
		int 21h
		mov dx, offset message1
		mov ah, 9h 
		int 21h
		mov ax,[word ptr serit]
		mov [word ptr schom],ax
		call print_number
	ret
endp hilok
proc print_number
	mov ax, [word ptr schom]
	mov bx, 0
	mov cx, 0
	mov dx, 0
	mov bl, 10
	split_for_printing:
		div bl
		mov dl, ah
		mov dh,0
		push dx
		inc cx
		mov ah, 0
		cmp al, 0
		jne split_for_printing
		print:
			pop dx 
			add dl, '0'
			mov ah, 2h
			int 21h
			loop print
	ret 
endp print_number
proc input ;getting the exercise
	mov cx,24
	mov si,0
	initloop:
		mov [word ptr arr+si ],	0
		inc si
		loop initloop
	mov dx, offset message
	mov ah, 9h
	int 21h;printting message
	mov dx, offset message1
	mov ah, 9h 
	int 21h
	mov dx, offset arr
	mov bx, dx
	mov [byte ptr bx], 19
	mov ah, 0Ah
	int 21h;getting exercise
	mov dx, offset message1
	mov ah, 9h
	int 21h;printting message
	call parse
	ret
endp input
proc loop_for_num
	add bl, [byte ptr lennum1]
	dec bx
	mov dx,	1
	loop_forNum1:
		mov ax, [temp]
		mov dh,0
		mov dl, [byte ptr bx]
		sub dx,	'0'
		mul dx
		add [word ptr num1], ax
		mov ax,	[temp]
		mul [to_mul]
		mov [temp],	ax
		dec bx
		loop loop_forNum1
	mov dx,	1
	
	ret
endp loop_for_num
proc piroc_num1
	;making num1
	mov [word ptr num1], 0
	mov ch,0
	mov cl, [byte ptr lennum1]
	cmp cl,1
	jne more_than1
	je only1
	more_than1:
		call loop_for_num
		jmp after
	only1:
		mov dl, [byte ptr bx] ;putting  sif in ax
		mov dh,0
		sub dx,'0'
		mov [word ptr num1],dx
	after:
		mov bx, offset arr
		add bl, [byte ptr lennum1]
		add bx,	2 
		add bl ,[byte ptr lennum2]
		

	ret 
endp piroc_num1
proc loop_for_num2
	mov dx,	1
	loop_forNum2:
		mov ax, [temp]
		mov dh,0
		mov dl, [byte ptr bx]
		sub dx,	'0'
		mul dx
		add [word ptr num2], ax
		mov ax,	[temp]
		mul [to_mul]
		mov [temp],	ax
		dec bx
		dec [lennum2]
		cmp [byte ptr lennum2],0
		jne loop_forNum2
	ret
endp loop_for_num2
proc piroc_num2
;making num2
	mov [temp],1
	mov [word ptr num2], 0
	mov cl, [byte ptr lennum2]
	cmp cl,1
	jne more_than_1
	je only_1
	more_than_1:
		call loop_for_num2
		jmp after_
	only_1:
		mov dl, [byte ptr bx] ;putting  sif in ax
		mov dh,0
		sub dx,'0'
		mov [word ptr num2],dx
	after_:
		mov [temp],1
	ret
endp piroc_num2
proc hacana1 ;לבדוק
	mov di, 10d
	mov ch, 0
	mov si,	0
	mov bx, offset arr
	add bx, 2
	mov [to_mul],	10
	mov [word ptr num1],0
	mov [word ptr num2],0
	;inc bx;במקום להוסיף 2 לדלג על הראשונים וככה באמצם להגיע לאחדות
	;add bl, [byte ptr lennum1]
	ret
endp hacana1
proc input_number
	call hacana1 
	call piroc_num1
	mov [temp],	1
	call piroc_num2
	mov bx, offset arr
	add bl, 2
	add bl, [byte ptr lennum1]
	cmp [byte ptr bx], '+';<---
	jne no1
		call plus
	no1:
	cmp [byte ptr bx], '-';<--
	jne no2
		call minos
	no2:
	cmp [byte ptr bx], '*';<---
	jne no3
		call cefel
	no3:
	cmp [byte ptr bx], '/';<---
	jne no4
		call hilok
	no4:
	ret 
endp input_number
proc parse
	mov al,0
	mov bx, offset arr
	mov bh,0
	add bx, 2
	lola:
		cmp [byte ptr bx], '+';<---
		je peola
		cmp [byte ptr bx], '-';<---
		je peola
		cmp [byte ptr bx], '*';<---
		je peola
		cmp [byte ptr bx], '/';<---
		je peola
		inc al
		inc bl
		jmp lola
	peola:
		mov [byte ptr Lennum1], al;אורך מספר ראשון
		mov dl, [byte ptr arr + 1]
		mov dh, 0
		;sub bx, offset arr
		sub dl,[byte ptr lennum1];סך כל התווין המשומשים פחות ורך מספר 1
		dec dl;הורדת הפעולה
		mov [byte ptr Lennum2], dl ;putting the length of num2 in lennum2
		mov bx, offset arr
		add bl, [byte ptr lennum1]
		add bl, 2
		mov al, [byte ptr bx];<---
		mov [byte ptr opp], al
	call input_number 
	ret 
endp parse

proc main
	mov dx, offset message1
	mov ah, 9h 
	int 21h
	mov dx, offset firstmaes
	mov ah, 9h 
	int 21h
	mov ah, 1
	int 21h
	cmp al, '1'
	je mechsev
	jne hamsech
	mechsev:
		call input
		call main
	hamsech:
	ret 
endp main
start:
	mov ax, @data
	mov ds, ax
	call main
exit:
	mov ax, 4c00h
	int 21h
END start