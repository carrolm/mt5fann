//--------------------------------------------------------------------------//
//	ICQ client DLL Library
//--------------------------------------------------------------------------//

#define _CRT_SECURE_NO_DEPRECATE

#include <windows.h>
#include "icq_mql5.h"

#pragma comment(lib, "ws2_32.lib")


//--------------------------------------------------------------------------//
int find_wcstr(wchar_t *src, const wchar_t *mask)
//--------------------------------------------------------------------------//
{
	int pos=-1;
	size_t srclen,masklen;
	
	srclen = wcslen(src);
	masklen = wcslen(mask);
	
	if (srclen < masklen) return(pos);

	for (size_t i=0; i <= srclen-masklen ; i++)
	{
		pos = i;
		for (size_t j = 0; j < wcslen(mask);j++)
		{
			if ( *(src+i+j)!=*(mask+j) ){pos =-1; break;}
		}
		if(pos >= 0) break;
	}
	
	return(pos);
}


//--------------------------------------------------------------------------//
void ParseHTML(wchar_t *text)
//--------------------------------------------------------------------------//
{
	size_t pos_begin, pos_end;
	
	for(int i=0;i<6;i++) if (find_wcstr(text,tag[i])<0) return;
	
	pos_begin = wcschr(text + find_wcstr(text,tag[4]) ,'>') - text + 1;
	pos_end = find_wcstr(text,tag[5]);
	if (pos_end < pos_begin)return;
	wcsncpy(text,text+pos_begin,pos_end-pos_begin);
	*(text + pos_end-pos_begin) = 0;
}

//--------------------------------------------------------------------------//
void ReverseWord(char * msg, int len)
//--------------------------------------------------------------------------//
{
	int x;
	BYTE b;

	for (x = 0; x < len; x+=2)
	{
		b = msg[x];
		msg[x] = msg[x+1];
		msg[x+1] = b;
	}
}

//--------------------------------------------------------------------------//
void ReverseWord2(wchar_t *msg, int len)
//--------------------------------------------------------------------------//
{
	int x;
	for (x = 0; x < len; x++)
	msg[x]= HTONS(msg[x]);
}

//--------------------------------------------------------------------------//
void * __cdecl my_memcpy ( void * dst, const void * src, size_t count )
//--------------------------------------------------------------------------//
{
	void * ret = dst;
	while (count--) 
	{
		*(char *)dst = *(char *)src;
		dst = (char *)dst + 1;
		src = (char *)src + 1;
	}
	return(ret);
}

//--------------------------------------------------------------------------//
ULONG Host2Ip(char * host)
//--------------------------------------------------------------------------//
{
	struct hostent * p;
	ULONG ret;
	p = gethostbyname(host);
	if (p)
	{
		ret = *(ULONG*)(p->h_addr);
	}
	else
	{
		ret = INADDR_NONE;
	}
	return ret;
}
//--------------------------------------------------------------------------//
ULONG my_rand()
//--------------------------------------------------------------------------//
{
	_asm
	{
		rdtsc
	}
}


//--------------------------------------------------------------------------//
void XorPass(char * buf, int len)
//--------------------------------------------------------------------------//
{
    int i;
	for (i = 0; i < len; i++)
	{
		buf[i] = key[i] ^ buf[i];
    }
}

//--------------------------------------------------------------------------//
ULONG GetTVL(char * buf, int buflen, USHORT type, char * data,  int* len)
//--------------------------------------------------------------------------//
{
	ULONG ret = 0;

	type = HTONS(type);
	while (buflen)
	{
		if (*(USHORT*)buf == type)
		{
			*len = HTONS(*(USHORT*)(buf+2));
			my_memcpy(data, buf+4, *len);
			ret = 1;
			break;
		}
		else
		{
			buflen -= (4 + HTONS(*(USHORT*)(buf+2)));
			buf += (4 + HTONS(*(USHORT*)(buf+2)));
		}
	}

	return ret;
}


//--------------------------------------------------------------------------//
ULONG ConnectToServer(char * host, USHORT port)
//--------------------------------------------------------------------------//
{
	struct sockaddr_in addr;
	
	ULONG ip;
	ULONG sock = INVALID_SOCKET;
	
	ip = Host2Ip(host);
	if (ip != INADDR_NONE)
	{
			addr.sin_addr.S_un.S_addr = ip;
			addr.sin_port = HTONS(port);
		
		if (addr.sin_addr.S_un.S_addr != INADDR_NONE)
		{
			addr.sin_family = AF_INET;
			sock = (ULONG)socket(AF_INET, SOCK_STREAM, 0);

			if (sock != INVALID_SOCKET)
			{
				if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)))
				{
					closesocket(sock);
					sock = INVALID_SOCKET;
				}
			}
		}
	}
	//delete ips;
	return sock;
}

//--------------------------------------------------------------------------//
ULONG GetFLAP(ULONG sock, PRAWPKT Pkt, ULONG timeout)
//--------------------------------------------------------------------------//
{
	ULONG ret = 0;
	USHORT RecvLen;
	SINGLE_FD_SET sfd_set;
	TIMEVAL tv;

	sfd_set.fd_count = 1;
	sfd_set.fd_sock = sock;
	tv.tv_usec = 0;
	tv.tv_sec = timeout;

	if (select(0, (fd_set *)&sfd_set, 0, 0, &tv) == 1)
	{
		if (recv(sock, Pkt->Data, sizeof(ICQ_HEADER), 0) == sizeof(ICQ_HEADER))
		{
			RecvLen = HTONS(((PICQ_HEADER)Pkt->Data)->datalen);
			if (recv(sock, Pkt->Data, RecvLen, 0) == RecvLen)
			{
				Pkt->Len = RecvLen;
				ret = 1;
			}
		}

		if (!ret)
		{
			closesocket(sock);
		}
	}
	else
	{
		ret = 0xFFFFFFFF;
	}
	
	return ret;
}

//--------------------------------------------------------------------------//
void PktMemCpy(void* desc, void* src, int len)
//--------------------------------------------------------------------------//
{
	my_memcpy(desc, src, len);
}
//--------------------------------------------------------------------------//
void PktInt(PRAWPKT Pkt, ULONG val, int len)
//--------------------------------------------------------------------------//
{
	PktMemCpy(Pkt->Data + Pkt->Len, &val, len);
	Pkt->Len += len;
}

//--------------------------------------------------------------------------//
void PktStrU(PRAWPKT Pkt, wchar_t * str, int len)
//--------------------------------------------------------------------------//
{
	my_memcpy(Pkt->Data + Pkt->Len, str,len*2);
	Pkt->Len += len*2;
}

//--------------------------------------------------------------------------//
void PktStr(PRAWPKT Pkt, char* str, int len)
//--------------------------------------------------------------------------//
{
	PktMemCpy(Pkt->Data + Pkt->Len, str, len);
	Pkt->Len += len;
}
//--------------------------------------------------------------------------//
void PktInit(PRAWPKT Pkt, BYTE Channel, USHORT Seq)
//--------------------------------------------------------------------------//
{
	Pkt->Len = 0;
	PktInt(Pkt, 0x2A, 1);
	PktInt(Pkt, Channel, 1);
	PktInt(Pkt, HTONS(Seq), 2);
	PktInt(Pkt, 0, 2);
}
//--------------------------------------------------------------------------//
void PktSnac(PRAWPKT Pkt, USHORT Family, USHORT SubType, ULONG ID, USHORT Flags)
//--------------------------------------------------------------------------//
{
	PktInt(Pkt, HTONS(Family), 2);
	PktInt(Pkt, HTONS(SubType), 2);
	PktInt(Pkt, HTONS(Flags), 2);
	PktInt(Pkt, HTOHL(ID), 4);
}

//--------------------------------------------------------------------------//
void PktTVL(PRAWPKT Pkt, USHORT type, USHORT len)
//--------------------------------------------------------------------------//
{
	PktInt(Pkt, type, 2);
	PktInt(Pkt, len, 2);
}
//--------------------------------------------------------------------------//
void PktFinish(PRAWPKT Pkt)
//--------------------------------------------------------------------------//
{
	*(USHORT*)(Pkt->Data + 4) = HTONS(Pkt->Len - 6);
}

//--------------------------------------------------------------------------//
void BuildQuery_SendMsg_Unicode(RAWPKT* Pkt, USHORT seq, wchar_t *UIN, wchar_t * msg)
//--------------------------------------------------------------------------//
{
	int len;
	
	RAWPKT pmsg;
	
	char *body1 = {"<HTML><BODY dir=\"ltr\"><FONT face=\"Arial\" color=\"#000000\" size=\"2\">"};
	char *body2 = {"</FONT></BODY></HTML>"};
	
	// malloc not working, using new
	wchar_t *bd1 = new wchar_t[strlen(body1)+1];		
	wchar_t *bd2 = new wchar_t[strlen(body2)+1];
	wchar_t *msg1 = new wchar_t[wcslen(msg)+1];
	char *uin1 = new char[wcslen(UIN)+1];
	

	mbstowcs(bd1, body1, strlen(body1)+1);
	mbstowcs(bd2, body2, strlen(body2)+1);
	wcstombs(uin1, UIN, wcslen(UIN) + 1);
	wcscpy(msg1,msg);

	ReverseWord2(bd1, (int)strlen(body1)+1);
	ReverseWord2(bd2, (int)strlen(body2)+1);
	ReverseWord2(msg1, (int)wcslen(msg1)+1);
	
	PktInit(Pkt, 2, seq);//2A 02 xx 00
	PktSnac(Pkt, 4, 6,(my_rand()&0xFF0000)|0x0006, 0);//0004 0006 0000 xxxx 0006
	
	PktInt(Pkt, HTOHL(my_rand() % 0xFFFFAA), 4); // xxxx
	PktInt(Pkt, HTOHL(my_rand() % 0xFFFFAA), 4); // xxxx
	PktInt(Pkt, HTONS(1), 2); //0001
	
	len = (int)strlen(uin1);
	PktInt(Pkt, len, 1); //09
	PktStr(Pkt, uin1, len);

	// msg
	pmsg.Len = 0;
	PktStrU(&pmsg, bd1, (int)wcslen(bd1)); // msg
	PktStrU(&pmsg, msg1, (int)wcslen(msg1)); // msg
	PktStrU(&pmsg, bd2, (int)wcslen(bd2)); // msg
	
	PktInt(Pkt, HTONS(2), 2); //0002
	PktInt(Pkt, HTONS(pmsg.Len + 14), 2); //len + 14

	PktInt(Pkt, 5, 1);	// 05
	PktInt(Pkt, 1, 2);	// 0100
	PktInt(Pkt, 258, 2);  // 0201
	PktInt(Pkt, 262, 2);  // 0601
	PktInt(Pkt, 1, 1);    // 01
	
	PktInt(Pkt, HTONS(pmsg.Len + 4), 2); //len + 4

	PktInt(Pkt, HTONS(2), 4);	//0002
	
	PktStr(Pkt, pmsg.Data, pmsg.Len);
	
	PktTVL(Pkt, HTONS(3), 0); // 00 03 00 00
	PktTVL(Pkt, HTONS(6), 0); // 00 06 00 00
	
	PktFinish(Pkt);	// set global len
	
	delete(bd1);
	delete(bd2);
	delete(msg1);
	delete(uin1);
}


//--------------------------------------------------------------------------//
void BuildQuery_Auth(RAWPKT* Pkt, USHORT seq, char * login, char * pass)
//--------------------------------------------------------------------------//
{
	int len;

	PktInit(Pkt, 1, seq);
	PktInt(Pkt, HTOHL(1), 4); //0001
	
	PktInt(Pkt, HTONS(ICQ_DATA_TYPE_UIN), 2); //01
	len = (int)strlen(login);
	PktInt(Pkt, HTONS(len), 2);//len UIN //09
	PktStr(Pkt, login, len);//UIN

	PktInt(Pkt, HTONS(ICQ_DATA_TYPE_DATA), 2);//0002
	len = (int)strlen(pass);
	PktInt(Pkt, HTONS(len), 2);// len pass //06
	PktStr(Pkt, pass, len);// pass
	XorPass(Pkt->Data + Pkt->Len - len, len);

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_CLIENT), HTONS(8));//0003 0008
	PktInt(Pkt, HTOHL('ICQB'), 4);
	PktInt(Pkt, HTOHL('asic'), 4);//ICQBasic

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_CLIENT_ID), HTONS(2));//00016 o0002
	PktInt(Pkt, HTONS(266), 2);// 100A

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_CLI_MAJOR_VER), HTONS(2));//0017 0002
	PktInt(Pkt, HTONS(20), 2);//0014

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_CLI_MINOR_VER), HTONS(2));//0018 0002
	PktInt(Pkt, HTONS(34), 2);//0022

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_CLI_LESSER_VER), HTONS(2));//0019 0002
	PktInt(Pkt, 0, 2);//0000

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_CLI_BUILD_NUMBER), HTONS(2));//001A 0002
	PktInt(Pkt, HTONS(2321), 2); //0911

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_DISTRIB_NUMBER), HTONS(4)); //0014 0004
	PktInt(Pkt, HTOHL(1085), 4); //00 00 04 3D

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_CLIENT_LNG), HTONS(2));// 000F 0002
	PktInt(Pkt, 'ne', 2);// ne

	PktTVL(Pkt, HTONS(ICQ_DATA_TYPE_CLIENT_COUNTRY), HTONS(2));//000E 0002
	PktInt(Pkt, 'su', 2);// su

	PktFinish(Pkt);
}

//--------------------------------------------------------------------------//
ULONG __stdcall ICQSendMsg(PICQ_CLIENT client, wchar_t * UIN, wchar_t * msg)
//--------------------------------------------------------------------------//
{
	ULONG ret = 0;
	RAWPKT Pkt;

	if (client->status == ICQ_CLIENT_STATUS_CONNECTED)
	{
		BuildQuery_SendMsg_Unicode(&Pkt, client->sequence++, UIN, msg);	
		if (send(client->sock, Pkt.Data, Pkt.Len, 0) != Pkt.Len)
		{
			client->status = ICQ_CLIENT_STATUS_DISCONNECTED;
			closesocket(client->sock);
		}
		else
		{
			ret = 1;
		}
	}
	return ret;
}

//--------------------------------------------------------------------------//
ULONG _stdcall ICQConnect(PICQ_CLIENT client, wchar_t * host1, USHORT port, wchar_t * login1, wchar_t * pass1)
//--------------------------------------------------------------------------//
{
	ULONG ret;
	RAWPKT Pkt;

	int len;
	char * tmp;
	int ServerLen;
	char Cookie[512];
	char NewServer[64];
	
	char *host  = new char[wcslen(host1)+1]; 
	char *login = new char[wcslen(login1)+1]; 
	char *pass  = new char[wcslen(pass1)+1];
	


	wcstombs(host, host1, wcslen(host1) + 1);
	wcstombs(login,login1,wcslen(login1)+ 1);
	wcstombs(pass, pass1, wcslen(pass1) + 1);

	client->status = ICQ_CLIENT_STATUS_DISCONNECTED;
	client->sequence = (USHORT)my_rand();
	
	client->sock = ConnectToServer(host, port);
	if (client->sock == INVALID_SOCKET)
	{
		ret = ICQ_CONNECT_STATUS_CONNECT_ERROR;
	}
	else if (GetFLAP(client->sock, &Pkt, 20000) != 1)
	{
		ret = ICQ_CONNECT_STATUS_RECV_ERROR;
	}
	else
	{
		
		BuildQuery_Auth(&Pkt, client->sequence++, login, pass);

		if (send(client->sock, Pkt.Data, Pkt.Len, 0) != Pkt.Len)
		{
			ret = ICQ_CONNECT_STATUS_SEND_ERROR;
		}
		else if (GetFLAP(client->sock, &Pkt, 20000) != 1)
		{
			ret = ICQ_CONNECT_STATUS_RECV_ERROR;
		}
		else if (!GetTVL(Pkt.Data, Pkt.Len, ICQ_DATA_TYPE_RECONECT_HERE, NewServer, &ServerLen) ||
				 !GetTVL(Pkt.Data, Pkt.Len, ICQ_DATA_TYPE_COOKIE, Cookie, &len))
		{
			ret = ICQ_CONNECT_STATUS_AUTH_ERROR;
		}
		else
		{
			PktInit(&Pkt, 4, client->sequence++);
			PktInt(&Pkt, 0x30, 1);
			PktFinish(&Pkt);
	
			send(client->sock, Pkt.Data, Pkt.Len, 0);
			closesocket(client->sock);

			NewServer[ServerLen] = 0x00;
			tmp = NewServer;

			while (tmp[0])
			{
				if (tmp[0] == ':')
				{
					tmp[0] = 0x00;
					break;
				}
				tmp++;
			}

			client->sock = ConnectToServer(NewServer, port);
			if (client->sock == INVALID_SOCKET)
			{
				ret = ICQ_CONNECT_STATUS_CONNECT_ERROR;
			}
			else if (GetFLAP(client->sock, &Pkt, 20000) != 1)
			{
				ret = ICQ_CONNECT_STATUS_RECV_ERROR;
			}
			else
			{
				PktInit(&Pkt, 1, client->sequence++);
				PktInt(&Pkt, HTOHL(1), 4); 
				
				PktTVL(&Pkt, HTONS(ICQ_DATA_TYPE_COOKIE), HTONS(len));
				PktStr(&Pkt, Cookie, len);
				PktFinish(&Pkt);

				if (send(client->sock, Pkt.Data, Pkt.Len, 0) != Pkt.Len)
				{
					ret = ICQ_CONNECT_STATUS_SEND_ERROR;
				}
				else if (GetFLAP(client->sock, &Pkt, 20000) != 1)
				{
					ret = ICQ_CONNECT_STATUS_RECV_ERROR;
				}
				else
				{
					PktInit(&Pkt, 2, client->sequence++);
					PktTVL(&Pkt, HTONS(1), HTONS(2));
					PktInt(&Pkt, 0, 2);
					PktInt(&Pkt, HTOHL(1), 4);
					PktStr(&Pkt, (char*)SNAC0102, 64);
					PktFinish(&Pkt);
	
					if (send(client->sock, Pkt.Data, Pkt.Len, 0) != Pkt.Len)
					{
						ret = ICQ_CONNECT_STATUS_SEND_ERROR;
					}
					else
					{
						client->status = ICQ_CLIENT_STATUS_CONNECTED;
						ret = ICQ_CONNECT_STATUS_OK;
					}
				}
			}
		} 
	}

	if (ret != ICQ_CONNECT_STATUS_OK &&
		client->sock != INVALID_SOCKET)
	{
		closesocket(client->sock);
	}
	
	delete(host);
	delete(login);
	delete(pass);
	
	return ret;
} 
//--------------------------------------------------------------------------//
 void  _stdcall ICQClose(PICQ_CLIENT client)
//--------------------------------------------------------------------------//
 {
	 //Disconnect 
	 //2A 04 seq(xx xx) 00 00
	 //------------------------------------------------------ 
		RAWPKT Pkt;
		PktInit(&Pkt, 4, client->sequence++);
		send(client->sock, Pkt.Data, Pkt.Len, 0);
	 //------------------------------------------------------
	 
	 // Close socket
	 if (client->status == ICQ_CLIENT_STATUS_CONNECTED)
		{
			closesocket(client->sock);
			client->status = ICQ_CLIENT_STATUS_DISCONNECTED;
		}
 }


//--------------------------------------------------------------------------//
ULONG _stdcall ICQReadMsg(PICQ_CLIENT client, wchar_t *UIN, wchar_t *msg, int* msglen)
//--------------------------------------------------------------------------//
{
	ULONG ret = 0;
	PICQ_MSG_HEADER MsgHdr;
	RAWPKT Pkt;
	USHORT TVL;
	char * data;
	int x, len;

		
	if (client->status == ICQ_CLIENT_STATUS_CONNECTED)
	{
		x = GetFLAP(client->sock, &Pkt, 0);
		if (x == 1)
		{
			MsgHdr = (PICQ_MSG_HEADER)Pkt.Data;
		
			if (MsgHdr->family == HTONS(4) && MsgHdr->subtype == HTONS(7) && MsgHdr->channel == HTONS(1))
			{
				
				data = Pkt.Data + sizeof(ICQ_MSG_HEADER);
				mbstowcs(UIN, data, MsgHdr->namesize);
				UIN[MsgHdr->namesize] = 0x00;
				
				
				data += MsgHdr->namesize;
				TVL = HTONS(*(USHORT*)(data + 2));
				data += 4;
				if (TVL)
				{
					for (x = 0; x <= TVL; x++)
					{
						if (*(USHORT*)data == HTONS(2))
						{
							TVL = HTONS(*(USHORT*)(data + 2));
							data += 4;
							while (TVL)
							{
								len = HTONS(*(USHORT*)(data + 2));
								if (data[0] == 1 && data[1] == 1) // id = 1  ver = 1
								{
									len -= 4;
									
									if (HTONS(*(USHORT*)(data + 4)) == 0002) // Unicode
									{
										ReverseWord(data+8, len);
										my_memcpy(msg,data+8,len);
										if (msglen) *msglen = len  >> 1;
										msg[*msglen]= 0x00;
										ParseHTML(msg);
									}
									
									else // Ansi
									{
										mbstowcs(msg, data+8, len);
										msg[len] = 0x00;
										if (msglen) *msglen = len;
										
									}
									ret = 1;
									break;
								}
								else
								{
									data += (len + 4);
									TVL -= (len + 4);
								}
							}
							break;
						}
						else
						{
							data += (4 + HTONS(*(USHORT*)(data + 2)));
						}
					}
				}
			}
		}
		else if (!x)
		{
			client->status = ICQ_CLIENT_STATUS_DISCONNECTED;
		}
	}

	return ret;
}


//--------------------------------------------------------------------------//
BOOL __stdcall DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
//--------------------------------------------------------------------------//
{	
	WSADATA ws;
	switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH: 
			WSAStartup(0x202, &ws);			
			break;
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
	}
	return 1;
}

