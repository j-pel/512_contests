; LocOS:
; Least Optioned Candidate
; for an Operating System
; entry to 512b compo
; at 512.decard.net

; Copyleft 2004 by pelaillo

; How to install in a VirtualBox machine
; with a floppy raw image:

; $ fasm locos.asm
; $ sudo dd if=locos.bin of=/dev/fd0

format binary
org 07C00h
use16

TEXT_VIDEO_MEMORY = 0B800h
WORK_MEMORY = 80*26*2

ESC_KEY = 1Bh
PG_UP   = 49h
PG_DOWN = 51h
F1_KEY  = 3Bh
F2_KEY  = 3Ch
F3_KEY  = 3Dh
F4_KEY  = 3Eh
F5_KEY  = 3Fh

struc main
 {
	.title rb 80
	.pages dd 0
	.first dd 0
 }

struc page
 {
	.cursor_y db 1
	.cursor_x db 0
	.colors   db 87h
	.lines dw 0
 }

start:
	xor	ax,ax
	mov	es,ax
	mov	di,workspace
	mov	si,title
	mov	cx,title.size
  .fill_title:
	lodsb
	stosb
	loop	.fill_title
	call	echo_date
	call	echo_time
	call	paint
	mov	ah,02h
	mov	dx,0100h ;cursor position
	int	10h
	mov	di,workspace+80

idle:
	mov	ah,00h
	int	16h
	cmp	al,0Dh
	je	.newline
	cmp	ah,PG_UP
	je	.pg_up
	cmp	ah,PG_DOWN
	je	.pg_down
	cmp	ah,F5_KEY
	je	.f5_key
	cmp	al,ESC_KEY
	jne	.put_char
	jmp	0FFFFh:0
  .pg_up:
	mov	ax,0500h
	int	10h	
	jmp	.done
  .pg_down:
	mov	ax,0501h
	int	10h	
	jmp	.done
  .f5_key:
	jmp	.done
  .newline:
	mov	al,20h
	stosb
	add	di,80*2
	and	di,0FFE0h
	jmp	idle
  .put_char:
	stosb
  .done:
	call	echo_time
	call	paint
	jmp	idle

; By BogdanOntanu
echo_hex:
	rol   dx, 4
	mov   al, 0Fh
	and   al, dl
	add   al, 90h
	daa
	adc   al, 40h
	daa
	stosb
	loop  echo_hex
	ret

; By MATRIX
echo_dec:
	mov	bx,7
	mov	ecx,1000000000 
.sroll1: 
	cmp	eax,ecx 
	jae	.sskip2 
.divide:
	push	eax
	mov	eax,ecx 
	mov	ecx,10 
	xor	edx,edx 
	div	ecx 
	mov	ecx,eax 
	pop	eax 
	jecxz	.sskip 
	jmp	.sroll1
.rolldivide: 
	push	eax 
	mov	eax,ecx 
	mov	ecx,10 
	xor	edx,edx 
	div	ecx 
	mov	ecx,eax 
	pop	eax 
	jecxz	.extroll 
.sskip2: 
	xor	edx,edx 
	div	ecx 
.sskip: 
	add	al,30h 
	stosb
	mov	eax,edx 
	jecxz	.extroll 
	jmp	.rolldivide 
.extroll: 
	ret

echo_date:
	push	di
	mov	di,workspace+60
	mov	ah,04h
	int	1Ah
	push	cx
	mov	cx,2
	call	echo_hex
	mov	al,2Fh
	stosb
	mov	cx,2
	call	echo_hex
	mov	al,2Fh
	stosb
	pop	dx
	mov	cx,4
	call	echo_hex
	pop	di
	ret

echo_time:
	push	di
	mov	di,workspace+72
	mov	ah,02h
	int	1Ah
	push	dx
	mov	dx,cx
	mov	cx,2
	call	echo_hex
	mov	al,3Ah
	stosb
	mov	cx,2
	call	echo_hex
	pop	dx
	mov	al,3Ah
	stosb
	mov	cx,2
	call	echo_hex
	pop	di
	ret

paint:
	push	es di
	mov	ax,TEXT_VIDEO_MEMORY
	mov	es,ax
	mov	si,workspace
	xor	di,di
	mov	ah,87h
	mov	cx,80
  .paint_title:
	lodsb
	stosw
	loop	.paint_title
	mov	cx,80*24
  	mov	ah,19h
  .paint_body:
	lodsb
	stosw
	loop	.paint_body
	pop	di es
	ret
	
load_sectors:
;	mov	dl,0 ; passed by BIOS
	mov	ah,02h
	mov	al,76h
	mov	ch,0
	mov	cl,2
	mov	dh,0
	mov	bx,0800h   
	mov	es,bx
	mov	bx,0
	int	13h
	jmp	0800h:0000h ;Launch Fasm


title db 'HOLA LOCOS - Page 1 of 8 - [F1] Help - Memory [kB] '
title.size = $-title

signature:
	rb	7DFEh-$
	db	055h,0AAh

workspace:

