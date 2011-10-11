//+------------------------------------------------------------------+
//|                                                       Socket.mqh |
//|                                                     GreyCardinal |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "GreyCardinal"
#property link      "http://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#define SOCKET_CONNECT_STATUS_OK				0
#define SOCKET_CONNECT_STATUS__ERROR		1000

#define SOCKET_CLIENT_STATUS_CONNECTED		1
#define SOCKET_CLIENT_STATUS_DISCONNECTED	2

struct SOCKET_CLIENT
  {
   uchar             status;   // код состояния подключения 
   ushort            sequence; // счетчик последовательности 
   uint              sock;     // номер сокета
  };

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
#import "socket_mql5_x32.dll"
//+------------------------------------------------------------------+   
uint SocketOpen(
                SOCKET_CLIENT &cl,// переменная для хранения данных о подключении
                string host,      // имя сервера
                ushort port       // порт сервера
                );

void SocketClose(
                 SOCKET_CLIENT &cl // переменная для хранения данных о подключении
                 );

//uint SocketWriteData(
//                     SOCKET_CLIENT &cl,// переменная для хранения данных о подключении 
//                     string symbol,    // валютная пара
//                     datetime dt,      // время прихода тика
//                     double bid,       // Bid
//                     double ask        // Ask
//                     );

uint SocketWriteString(
                       SOCKET_CLIENT &cl,// переменная для хранения данных о подключении 
                       string str        // строка
                       );
uint SocketReadString(
                       SOCKET_CLIENT &cl,// переменная для хранения данных о подключении 
                       string str        // строка
                       );
uint SocketSendReceive(
                       SOCKET_CLIENT &cl,// переменная для хранения данных о подключении 
                       string send_str,        // строка
                       string &recv_str);        // строка

#import
