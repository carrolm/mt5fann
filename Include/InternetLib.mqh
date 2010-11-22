//+------------------------------------------------------------------+
//|                                                  InternetLib.mqh |
//|                                 Copyright © 2010 www.fxmaster.de |
//|                                         Coding by Sergeev Alexey |
//+------------------------------------------------------------------+
#property copyright   "www.fxmaster.de  © 2010"
#property link        "www.fxmaster.de"
#property version     "1.00"
#property description "Liblary for work with wininet.dll"
#property library

#import "wininet.dll"
int InternetAttemptConnect(int x);
int InternetOpenW(string &sAgent,int lAccessType,string &sProxyName,string &sProxyBypass,int lFlags);
int InternetConnectW(int hInternet,string &lpszServerName,int nServerPort,string &lpszUsername,string &lpszPassword,int dwService,int dwFlags,int dwContext);
int HttpOpenRequestW(int hConnect,string &lpszVerb,string &lpszObjectName,string &lpszVersion,string &lpszReferer,string &lplpszAcceptTypes,uint dwFlags,int dwContext);
int HttpSendRequestW(int hRequest,string &lpszHeaders,int dwHeadersLength,uchar &lpOptional[],int dwOptionalLength);
int HttpQueryInfoW(int hRequest,int dwInfoLevel,uchar &lpvBuffer[],int &lpdwBufferLength,int &lpdwIndex);
int InternetOpenUrlW(int hInternet,string &lpszUrl,string &lpszHeaders,int dwHeadersLength,int dwFlags,int dwContext);
int InternetReadFile(int hFile,uchar &sBuffer[],int lNumBytesToRead,int &lNumberOfBytesRead);
int InternetCloseHandle(int hInet);
#import

#define OPEN_TYPE_PRECONFIG           0  // использовать конфигурацию по умолчанию
#define FLAG_KEEP_CONNECTION 0x00400000  // не разрывать соединение
#define FLAG_PRAGMA_NOCACHE  0x00000100  // не кешировать страницу
#define FLAG_RELOAD          0x80000000  // получать страницу с сервера при обращении к ней
#define SERVICE_HTTP                  3  // сервис Http 
#define HTTP_QUERY_CONTENT_LENGTH     5
//+------------------------------------------------------------------+
class MqlNet
  {

   string            Host;       // имя хоста
   int               Port;       // порт
   int               Session;    // дескриптор сессии
   int               Connect;    // дескриптор соединения
public:
                     MqlNet();   // конструктор класса
                    ~MqlNet();   // деструктор
   bool              Open(string aHost,int aPort); // создаем сессию и открываем соединение
   void              Close();    // закрываем сессию и соединение
   bool              Request(string Verb,string Request,string &Out,bool toFile=false,string addData="",bool fromFile=false); // отправляем запрос
   bool              OpenURL(string URL,string &Out,bool toFile); // просто читаем страницу в файл или в переменную
   void              ReadPage(int hRequest,string &Out,bool toFile); // читаем страницу
   long              GetContentSize(int hURL); //получения информации о размере скачиваемой  страницы
   int               FileToArray(string FileName,uchar &data[]); // копируем файл в массив для отправки
  };
//------------------------------------------------------------------ MqlNet
void MqlNet::MqlNet()
  {
   // обнуляем параметры
   Session=-1;
   Connect=-1;
   Host="";
  }
//------------------------------------------------------------------ ~MqlNet
void MqlNet::~MqlNet()
  {
   // закрываем все дескрипторы
   Close();
  }
//------------------------------------------------------------------ Open
bool MqlNet::Open(string aHost,int aPort)
  {
   if(aHost=="")
     {
      Print("-Host is not specified");
      return(false);
     }
   // проверка разрешения DLL в терминале  
   if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED))
     {
      Print("-DLL is not allowed");
      return(false);
     }
   // если сессия была опеределена, то закрываем
   if(Session>0 || Connect>0) Close();
   // сообщение про попытку открытия в журнал
   Print("+Open Inet...");
   // если не удалось проверить имеющееся соединение с интернетом, то выходим
   if(InternetAttemptConnect(0)!=0)
     {
      Print("-Err AttemptConnect");
      return(false);
     }
   string UserAgent="Mozilla"; string nill="";
   // открываем сессию
   Session=InternetOpenW(UserAgent,OPEN_TYPE_PRECONFIG,nill,nill,0);
   // если не смогли открыть сессию, то выходим
   if(Session<=0)
     {
      Print("-Err create Session");
      Close();
      return(false);
     }
   Connect=InternetConnectW(Session,aHost,aPort,nill,nill,SERVICE_HTTP,0,0);
   if(Connect<=0)
     {
      Print("-Err create Connect");
      Close();
      return(false);
     }
   Host=aHost; Port=aPort;
   // иначе все проверки завершились успешно
   return(true);
  }
//------------------------------------------------------------------ Close
void MqlNet::Close()
  {
   Print("-Close Inet...");
   if(Session>0) InternetCloseHandle(Session);
   Session=-1;
   if(Connect>0) InternetCloseHandle(Connect);
   Connect=-1;
  }
//------------------------------------------------------------------ Request
bool MqlNet::Request(string Verb,string Object,string &Out,bool toFile=false,string addData="",bool fromFile=false)
  {
   if(toFile && Out=="")
     {
      Print("-File is not specified ");
      return(false);
     }
   uchar data[];
   int hRequest,hSend,h;
   string Vers="HTTP/1.1";
   string nill="";
   if(fromFile)
     {
      if(FileToArray(addData,data)<0)
        {
         Print("-Err reading file "+addData);
         return(false);
        }
     } // прочитали файл в массив
   else StringToCharArray(addData,data);

   if(Session<=0 || Connect<=0)
     {
      Close();
      if(!Open(Host,Port))
        {
         Print("-Err Connect");
         Close();
         return(false);
        }
     }
   // создаем дескриптор запроса
   hRequest=HttpOpenRequestW(Connect,Verb,Object,Vers,nill,nill,FLAG_KEEP_CONNECTION|FLAG_RELOAD|FLAG_PRAGMA_NOCACHE,0);
   if(hRequest<=0)
     {
      Print("-Err OpenRequest");
      InternetCloseHandle(Connect);
      return(false);
     }
   // отправляем запрос
   // заголовок на отправку
   string head="Content-Type: application/x-www-form-urlencoded";
   // отправили файл
   hSend=HttpSendRequestW(hRequest,head,StringLen(head),data,ArraySize(data)-1);
   if(hSend<=0)
     {
      Print("-Err SendRequest");
      InternetCloseHandle(hRequest);
      Close();
     }
   // читаем страницу 
   ReadPage(hRequest,Out,toFile);
   // закрыли все хендлы
   InternetCloseHandle(hRequest);
   InternetCloseHandle(hSend);
   return(true);
  }
//------------------------------------------------------------------ OpenURL
bool MqlNet::OpenURL(string URL,string &Out,bool toFile)
  {
   string nill="";
   if(Session<=0 || Connect<=0)
     {
      Close();
      if(!Open(Host,Port))
        {
         Print("-Err Connect");
         Close();
         return(false);
        }
     }
   int hURL=InternetOpenUrlW(Session, URL, nill, 0, FLAG_RELOAD|FLAG_PRAGMA_NOCACHE, 0);
   if(hURL<=0)
     {
      Print("-Err OpenUrl");
      return(false);
     }
   // читаем в Out  
   ReadPage(hURL,Out,toFile);
   // закрыли 
   InternetCloseHandle(hURL);
   return(true);
  }
//------------------------------------------------------------------ ReadPage
void MqlNet::ReadPage(int hRequest,string &Out,bool toFile)
  {
   // читаем страницу 
   uchar ch[100];
   string toStr="";
   int dwBytes,h;
   while(InternetReadFile(hRequest,ch,100,dwBytes))
     {
      if(dwBytes<=0) break;
      toStr=toStr+CharArrayToString(ch,0,dwBytes);
     }
   if(toFile)
     {
      h=FileOpen(Out,FILE_BIN|FILE_WRITE);
      FileWriteString(h,toStr);
      FileClose(h);
     }
   else Out=toStr;
  }
//------------------------------------------------------------------ GetContentSize
long MqlNet::GetContentSize(int hRequest)
  {
   int len=2048,ind=0;
   uchar buf[2048];
   int Res=HttpQueryInfoW(hRequest, HTTP_QUERY_CONTENT_LENGTH, buf, len, ind);
   if(Res<=0)
     {
      Print("-Err QueryInfo");
      return(-1);
     }
   string s=CharArrayToString(buf,0,len);
   if(StringLen(s)<=0) return(0);
   return(StringToInteger(s));
  }
//----------------------------------------------------- FileToArray
int MqlNet::FileToArray(string FileName,uchar &data[])
  {
   int h,i,size;
   h=FileOpen(FileName,FILE_BIN|FILE_READ);
   if(h<0) return(-1);
   FileSeek(h,0,SEEK_SET);
   size=(int)FileSize(h);
   ArrayResize(data,(int)size);
   for(i=0; i<size; i++)
     {
      data[i]=(uchar)FileReadInteger(h,CHAR_VALUE);
     }
   FileClose(h); return(size);
  }
//+------------------------------------------------------------------+
