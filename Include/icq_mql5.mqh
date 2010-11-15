//+------------------------------------------------------------------+
//|                                                     icq_mql5.mqh |
//|              Copyright Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

// возвращаемое значение дл€ функции ICQConnect 
#define ICQ_CONNECT_STATUS_OK					   0xFFFFFFFF
#define ICQ_CONNECT_STATUS_RECV_ERROR			0xFFFFFFFE
#define ICQ_CONNECT_STATUS_SEND_ERROR			0xFFFFFFFD
#define ICQ_CONNECT_STATUS_CONNECT_ERROR		0xFFFFFFFC
#define ICQ_CONNECT_STATUS_AUTH_ERROR			0xFFFFFFFB

// значени€ дл€ ICQ_CLIENT.status
#define ICQ_CLIENT_STATUS_CONNECTED		      1
#define ICQ_CLIENT_STATUS_DISCONNECTED	      2

struct ICQ_CLIENT
    {
        uchar  status;   // код состо€ни€ подключени€ 
        ushort sequence; // счетчик последовательности 
        uint   sock;     // номер сокета
    };
//+------------------------------------------------------------------+
#import "icq_mql5.dll"
//+------------------------------------------------------------------+   
   uint ICQConnect (
      ICQ_CLIENT &cl,   // переменна€ дл€ хранени€ данных о подключении
          string host,  // им€ сервера, например login.icq.com
          ushort port,  // порт сервера, например 5190
          string login, // номер учетной записи (UIN)
          string pass   // пароль дл€ учетной записи
                    );
                    
   void ICQClose (
      ICQ_CLIENT &cl    // переменна€ дл€ хранени€ данных о подключении
                 );
                 
   
                
   uint ICQSendMsg (
    ICQ_CLIENT &cl,     // переменна€ дл€ хранени€ данных о подключении.
         string uin,    // номер учетной записи получател€
         string msg     // текст сообщени€
                );
                
   uint ICQReadMsg (
      ICQ_CLIENT &cl,   // переменна€ дл€ хранени€ данных о подключении 
          string &uin,  // номер учетной записи отправител€ 
          string &msg,  // текст сообщени€ 
            uint &len   // количество прин€тых символов в сообщении
                );
   
#import

//+------------------------------------------------------------------+
class COscarClient
//+------------------------------------------------------------------+
{
private:
  ICQ_CLIENT  client;        // хранение данных о подключении
          uint connect;      // флаг состо€ни€ подключени€
      datetime timesave;     // хранение последнего времени подключени€ к серверу
      datetime time_in;      // хранение последнего времени чтени€ сообщений

public:
      string uin;            // буффер дл€ хранени€ uin отпавител€ дл€ прин€того сообщени€
      string msg;            // буффер дл€ хранени€ текста прин€того сообщени€
        uint len;            // количество символов в прин€том сообщении
     
      string login;          // номер учетной записи отправител€ (UIN)
      string password;       // пароль дл€ UIN 
      string server;         // им€ сервера    
        uint port;           // сетевой порт  
        uint timeout;        // заданеи таймаута(в секундах) между попытками подключени€ к сервру
        bool autocon;        // автоматическое восстановление соединени€
        
           COscarClient();   // конструктор дл€ инициализации переменных класса
      bool Connect(void);    // ”становка соединени€ с сервером
      void Disconnect(void); // –азрыв соединени€ с сервером
      bool SendMessage(string  UIN, string  msg); // ќтсылка сообщени€  
      bool ReadMessage(string &UIN, string &msg, uint &len); // ѕрием сообщени€
};

//+------------------------------------------------------------------+
bool COscarClient::ReadMessage(string &uin, string &msg, uint &len)
//+------------------------------------------------------------------+
{
   bool res = false; 

   if (ICQReadMsg(client, uin, msg, len)) res = true;
   else if (client.status != ICQ_CLIENT_STATUS_CONNECTED)
            if (autocon) Connect();

   Sleep(100);
   return(res);
};

//+------------------------------------------------------------------+
bool COscarClient::SendMessage(string UIN, string message)
//+------------------------------------------------------------------+
{
   bool ret = true;
   if (!ICQSendMsg(client,UIN,message))
   {
      ret = false;
      if (autocon) Connect();
   }
   return(ret);
};

//+------------------------------------------------------------------+
bool COscarClient::Connect()
//+------------------------------------------------------------------+
{
  
   if  ((TimeLocal() - timesave) >= timeout)
   { 
      timesave = TimeLocal();
      connect = ICQConnect(client, server, port, login, password);
      
      PrintError(connect);
   }
   
   if (connect == ICQ_CONNECT_STATUS_OK) return(true);
   else return(false); 
                 
};

//+------------------------------------------------------------------+
COscarClient::Disconnect()
//+------------------------------------------------------------------+
{
   connect = ICQ_CLIENT_STATUS_DISCONNECTED;
   ICQClose(client);
}

//+------------------------------------------------------------------+
COscarClient::COscarClient(void)//  онструктор
//+------------------------------------------------------------------+
{
   StringInit(uin,10,0);
   StringInit(msg,4096,0);  
   timeout = 20;
   autocon = true;
}

//+------------------------------------------------------------------+
void PrintError(uint status)
//+------------------------------------------------------------------+
{
   string errstr;
   
   switch(status)
   {
      case ICQ_CONNECT_STATUS_OK:            errstr = "Status_OK";            break;
      case ICQ_CONNECT_STATUS_AUTH_ERROR:    errstr = "Status_AUTH_ERROR";    break;
      case ICQ_CONNECT_STATUS_CONNECT_ERROR: errstr = "Status_CONNECT_ERROR"; break; 
      case ICQ_CONNECT_STATUS_RECV_ERROR:    errstr = "Status_RECV_ERROR";    break;                                    
      case ICQ_CONNECT_STATUS_SEND_ERROR:    errstr = "Status_SEND_ERROR";    break;
      case 0:                                errstr = "PARAMETER_INCORRECT";  break; 
      default:                        errstr = IntegerToString(status,8,' '); break;
   }
   printf("%s",errstr);
}