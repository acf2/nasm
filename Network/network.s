%include "smacro.mac"
%include "iomacro.mac"

struc sockaddr
	.address_family resw 1
	.port resw 1
	.address resd 1
	.nothing resd 2
endstruc
sockaddr_length equ 16

AF_INET equ 2
SOCK_STREAM equ 1
IPPROTO_TCP equ 6

;;;; Функции для работы с сетью
global socket
global bind
global connect
global listen
global accept
global recv
global send

;;; socket создаёт сокет для IPv4 | TCP
procedure socket
	;; По соглашению eax, ecx и edx должны быть сохранены вызывающей стороной
	push ebx

	push dword IPPROTO_TCP
	push dword SOCK_STREAM
	push dword AF_INET

	mov eax, 102
	mov ebx, 1 ; 1 is for socket
	mov ecx, esp
	int 0x80

	add esp, 12

	pop ebx
endproc

;;; Привязка сокета к адресу/порту
;;; Явно подразумевается использование sockaddr
procedure bind, socket, address
	push ebx

	mov eax, 102
	mov ebx, 2

	push sockaddr_length
	push %$address
	push %$socket
	mov ecx, esp
	int 0x80
	add esp, 12 ; XXX: check this twice

	pop ebx
endproc

;;; Подключиться с сокету
;;; Явно подразумевается использование sockaddr
procedure connect, socket, address
	push ebx

	mov eax, 102
	mov ebx, 3

	push sockaddr_length
	push %$address
	push %$socket
	mov ecx, esp
	int 0x80
	add esp, 12 ; XXX: check this twice

	pop ebx
endproc

;;; Сделать сокет слушающим
procedure listen, socket, backlog
	push ebx
	
	mov eax, 102
	mov ebx, 4

	push %$backlog
	push %$socket
	mov ecx, esp
	int 0x80
	add esp, 8 ; XXX: this is also doubtable

	pop ebx
endproc

;;; Принять соединение.
;;; Upon successful completion, accept() shall return the non-negative file descriptor of the accepted socket. 
;;; Otherwise, -1 shall be returned and errno set to indicate the error.
procedure accept, socket, address, address_len
	push %$address_len
	push %$address
	push %$socket

	mov eax, 102  
	mov ebx, 5    
	mov ecx, esp    
	int 80h

	add esp, 12
	; В eax дескриптор сокета
	; mov [worksocket_desc], eax
endproc

;;; recv - считывание из сокета
;;; Возвращает количество считанных байт
procedure recv, socket, str, bufsize
	push %$bufsize
	push %$str
	push %$socket

	mov eax, 102
	mov ebx, 10
	mov ecx, esp
	int 0x80

	add esp, 12
endproc

;;; send - запись в сокет
procedure send, socket, str, strlen
	push %$strlen
	push %$str
	push %$socket

	mov eax, 102
	mov ebx, 9
	mov ecx, esp
	int 0x80

	add esp, 12
endproc
