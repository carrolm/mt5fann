//+------------------------------------------------------------------+
//|                                                   WatcherICQ.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <gc\Watcher.mqh>
#include <gc\icq_mql5.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CWatcherICQ:public  CWatcher
  {
   COscarClient      client;
public:
                     CWatcherICQ();
                    ~CWatcherICQ();
   bool              Run();
   bool              SendNotify(string UIN="");
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CWatcherICQ::~CWatcherICQ(void)
  {
   client.Disconnect();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CWatcherICQ::CWatcherICQ(void)
  {
   CWatcher::Init();SendNotify();
   int filehandle=FileOpen("MustWatcher\data\set_bot",FILE_READ|FILE_CSV|FILE_ANSI,':',CP_ACP);
   if(filehandle!=INVALID_HANDLE)
     {
      client.login=StringSubstr(FileReadString(filehandle),3);//"645990858";
      client.password=FileReadString(filehandle);//"Forex7";
      client.Connect();
      FileClose(filehandle);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              CWatcherICQ::Run()
  {
   CWatcher::Run();
   SendNotify();

   return(true);
  }
//+------------------------------------------------------------------+
bool   CWatcherICQ::SendNotify(string UIN)
  {
   bool ret=true;
   if(changing==0) return(true);
//--- если изменения есть то пишем файл notify.txt
   ResetLastError();
   for(int i=0;i<changing;i++)
     {
      client.SendMessage("36770049",ar_sSPAM[i]);
     }
   changing=0;

   return(true);
  }
//+------------------------------------------------------------------+
