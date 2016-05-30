%ifndef __NETWORK_H
%define __NETWORK_H

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

extern socket
extern bind
extern connect
extern listen
extern accept
extern recv
extern send

%endif ; __NETWORK_H
