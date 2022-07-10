IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
firstmaes db "If you want to calu enter 1,to exit enter something else",10,13,"$"
message db  "please enter you exercise",10,13,"$"
arr db  22,?, 22 dup (?) ;the arrey
Lennum1 db (?) ;the length of number 1
opp db 2
Lennum2 db (?) ;the length of number 2
num1 dw (?) 
num2 dw (?) 
answer dw (?) ;the answer
special_memory dw (?) ;the answer in the memory
to_mul db 1 
message1 db  10, 13,'$' ;get one line down
serit dw (0) ;the rest of the divertion
temp dw 1 
mes_schom db "The result of the division","$"
mes_serit db "rest","$"
;in num1 we have number 1
;in num2 we have number 2
CODESEG

;	Author:Liel
;	Date:27.2.16
proc plus
	mov [answer],0
	mov ax,[word ptr num1]
	add ax,[word ptr num2] ;add to num1, num2
	mov [word ptr answer],ax ;move to memory
	call print_number
	ret
endp plus
proc minos
	mov [answer],0
	mov ax, [word ptr num2]
	cmp ax,	[word ptr num1];check if the result is Positive or negative
	jg nsmall ;negative
	jmp normal ;Positive 
	nsmall:
		mov ax, [word ptr num2]	
		sub ax,[word ptr num1]
		mov [word ptr answer],ax
		mov dl, '-' ;put minus before the result 
		mov ah, 2h
		int 21h
		call print_number
		jmp con
	normal:
		mov ax,[word ptr num1] 
		sub ax,[word ptr num2]  ;subtract num2 from num1
		mov [word ptr answer],ax
		call print_number
		jmp con
	con:
	ret
endp minos
proc cefel
mov [answer],0
		mov ax, [word ptr num1]
		mul [word ptr num2]
		mov [word ptr answer], ax
		mov [word ptr serit], dx
		call print_number
	ret
endp cefel
proc hilok
		cmp [word ptr num2], 0
		jle hilok_with_0
		jmp normal_hilok
		hilok_with_0: 
			jmp end_hilok
		normal_hilok:
			mov [answer],0
			mov dx,0
			mov ax, [word ptr num1]
			div [word ptr num2]
			mov ah,0
			mov [word ptr answer],ax ;put the result of the division completion
			mov dh,0
			mov [word ptr serit],dx ;put the rest
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
			mov [word ptr answer],ax
			call print_number
		end_hilok:
	ret
endp hilok
proc hesca
	mov ax, [ word ptr num1]
	mov [word ptr answer],	ax
	mov cx, [word ptr num2]
	dec cx
	hesca1:
		mov [answer], ax
		mul [num1]
		mov [word ptr answer], ax
		loop hesca1
	call print_number
	ret
endp hesca
proc print_number
	mov ax, [word ptr answer]
	mov bx, 0
	mov cx, 0
	mov dx, 0
	mov bl, 10
	split_for_printing: ;spilt to print digit by digit
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
	initloop: ;reset the array
		mov [word ptr arr+si ],	0
		inc si
		loop initloop
	mov dx, offset message
	mov ah, 9h
	int 21h;printting message
	mov dx, offset message1
	mov ah, 9h 
	int 21h
	mov dx, offset arr ;get the array
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
	;start to calculate the number.from the lowest digit to the highest
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
	cmp cl,1 ;check the length of num1
	jne more_than1
	je only1
	more_than1:
		call loop_for_num
		jmp after
	only1:
		mov dl, [byte ptr bx] ;putting  sif in ax
		mov dh,0
		sub dx,'0'
		mov [word ptr num1],dx ;putting the digit in number 1
	after:
	ret 
endp piroc_num1
proc loop_for_num2
	;start to calculate the number.from the lowest digit to the highest
	mov bx, offset arr
	add bl, [byte ptr lennum1]
	add bx,	2 
	add bl ,[byte ptr lennum2]
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
	cmp cl,1 ;check the length of number 2
	jne more_than_1
	je only_1
	more_than_1:
		mov bx, offset arr
		add bl,	3 ;2 for the first places and 1  more for the bigest place in num2 
		add bl, [byte ptr lennum1] 
		cmp [byte ptr bx], 'A' ;check case of answer 
		je num2_answer_case
		cmp [byte ptr bx], 'a' ;check case of answer 
		je num2_answer_case
		jne normal2
		num2_answer_case:
			mov ax,	[word ptr answer]
			mov [word ptr num2], ax ;put answer in number 2
			jmp after_
		normal2:
			call loop_for_num2
			jmp after_
	only_1:
		mov dl, [byte ptr bx] ;putting  sif in ax
		mov dh,0
		sub dx,'0'
		mov [word ptr num2],dx ;put the digit in num2
	after_:
		mov [temp],1
	ret
endp piroc_num2
proc hacana1 
	;get ready for put the first number in num1
	mov di, 10d
	mov ch, 0
	mov si,	0
	mov bx, offset arr
	add bx, 2
	mov [to_mul],	10
	ret
endp hacana1
proc input_number
	call hacana1 
	call piroc_num1
	mov bx, offset arr
	add bl, [byte ptr lennum1]
	add bx,	2 
	add bl ,[byte ptr lennum2]
	mov [temp],	1
	call piroc_num2
endp input_number
proc sign
	mov bx, offset arr
	add bl, 2
	add bl, [byte ptr lennum1]
	;point the operation
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
	cmp [byte ptr bx], '^';<---
		jne no5
		call hesca
	no5:
	ret 
endp sign
proc answer_case
	mov ax,[word ptr answer]
	mov [word ptr num1],ax ;move answer in num1
	mov [word ptr lennum1],3 ;put 3 because a+n+s=3.need it to calculate number 2
	mov bx,offset arr
	inc bx
	mov al,[byte ptr bx]
	sub al,4 ;'a'+'n'+'s'+peola =4
	mov [lennum2],al ;calculate length of number 2
	call hacana1
	inc bx
	add bl, [byte ptr lennum1]
	call piroc_num2
	call sign
	ret
endp answer_case
proc memory_case
	mov bx, offset arr
	inc bx
	cmp [byte ptr bx], 	1 ;check if this case is to save,delete or use
	je just_m ;use 
	jne other_case ;save or delete
	just_m:
		mov ax,[word ptr special_memory]
		mov [word ptr answer],	ax ;move the save to answer
		jmp endMemory
	other_case:
		add bx,	2
		cmp [word ptr bx],'-' ;check if to save ot delete
		je minos_case ;delete
		jne plus_case ;save
		minos_case:
			mov [word ptr special_memory],	0 ;reset memory
			jmp endMemory
		plus_case:
			mov ax,	[word ptr answer]
			mov [word ptr special_memory],	ax ;put answer in memory
	endMemory:
	ret 
endp memory_case
proc parse
	mov al,0
	mov bx, offset arr
	mov bh,0
	add bx, 2
	cmp [byte ptr bx], 'A' ;check answer case
	je answer_case1
	cmp [byte ptr bx], 'a' ;check answer case
	je answer_case1
	cmp [byte ptr bx], 'm' ;check memory case
	je memory_case1
	cmp [byte ptr bx], 'M' ;check memory case
	je memory_case1
	jne lola
	answer_case1:
		call answer_case
		jmp end_diferent_case
	memory_case1:
		call memory_case
		jmp end_diferent_case
	lola:
		;check where is the operation to calculate the length of the numbers
		cmp [byte ptr bx], '+';<---
		je peola
		cmp [byte ptr bx], '-';<---
		je peola
		cmp [byte ptr bx], '*';<---
		je peola
		cmp [byte ptr bx], '/';<---
		je peola
		cmp [byte ptr bx], '^';<---
		je peola
		inc al
		inc bl
		jmp lola
	peola:
		mov [byte ptr Lennum1], al;put the length of the first number
		mov dl, [byte ptr arr + 1]
		mov dh, 0
		;sub bx, offset arr
		sub dl,[byte ptr lennum1];subtract from all the digit the length of number 1
		dec dl;subtract the operation
		mov [byte ptr Lennum2], dl ;put the length of num2 in lennum2
		mov bx, offset arr
		add bl, [byte ptr lennum1]
		add bl, 2
		mov al, [byte ptr bx];<---
		mov [byte ptr opp], al
	call input_number 
	end_diferent_case:
	ret 
endp parse
proc main
	;to Continuous calculation until the user will enter 1
	mov dx, offset message1
	mov ah, 9h 
	int 21h
	mov dx, offset firstmaes
	mov ah, 9h 
	int 21h
	mov ah, 1
	int 21h
	cmp al, '1' ;check if the user want to exit or stay
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