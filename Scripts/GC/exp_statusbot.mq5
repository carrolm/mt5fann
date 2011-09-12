//+------------------------------------------------------------------+
//|                                                exp_statusbot.mq5 |
//|                               Leonid Salavatov [MUSTADDON]� 2010 |
//+------------------------------------------------------------------+
#property copyright "Leonid Salavatov [MUSTADDON]� 2010"
#property link      "mustaddon@gmail.com"
#property version   "1.2"
//---- inputs
input string statusfilename = "status.txt";
input string spamfilename   = "notify.txt";
input string reportfilename = "report.txt";
//---- vars
string expname="statusbot";
string ar_sSTATUScur[];
string ar_sSTATUSpast[];
string ar_sSPAM[];
int    codepage=CP_ACP;
int    pospast=0;
string Abzac="------------------";
double curbalance=0.0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   WriteStatus();
   WriteReport();
//---
   ResetLastError();
   string filename=expname+"\\"+spamfilename;
   int filehandle=FileOpen(filename,FILE_WRITE|FILE_TXT|FILE_ANSI,'\t',codepage);
   if(filehandle!=INVALID_HANDLE)
     {
      FileWrite(filehandle,"Starting expert '"+expname+"'");
      FileClose(filehandle);
     }
   else Print("�� ������� ������� ���� ",spamfilename,", ������",GetLastError());
   return(0);
//---
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   FileDelete(expname+"\\"+statusfilename);
   FileDelete(expname+"\\"+spamfilename);
   FileDelete(expname+"\\"+reportfilename);
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   WriteStatus();
   WriteNotify();
   WriteReport();
  }
//+------------------------------------------------------------------+
void WriteStatus()
  {
   double sumprofit=AccountInfoDouble(ACCOUNT_PROFIT);
   double balance  =AccountInfoDouble(ACCOUNT_BALANCE);
   double equity   =AccountInfoDouble(ACCOUNT_EQUITY);
   string symset,order_type;
   int    tp,sl;
   double vol,open,profit;
//--- ����� ���� � status.txt 
   ArrayResize(ar_sSTATUScur,PositionsTotal());
   ResetLastError();
   string filename=expname+"\\"+statusfilename;
   int    filehandle=FileOpen(filename,FILE_WRITE|FILE_TXT|FILE_ANSI,'\t',codepage);
   FileWrite(filehandle,"Balance = "+DoubleToString(balance,2)+" "+AccountInfoString(ACCOUNT_CURRENCY));
   for(int i=0;i<PositionsTotal() && filehandle!=INVALID_HANDLE;i++)
     {
      if(i==0)FileWrite(filehandle,Abzac);
      PositionGetSymbol(i);
      if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY) order_type="buy";
      if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL)order_type="sell";
      sl    =(int)PositionGetDouble(POSITION_SL);
      tp    =(int)PositionGetDouble(POSITION_TP);
      vol   =PositionGetDouble(POSITION_VOLUME);
      open  =PositionGetDouble(POSITION_PRICE_OPEN);
      profit=PositionGetDouble(POSITION_PROFIT);
      symset=PositionGetSymbol(i)+"  "+order_type+" "+DoubleToString(vol,2)+"  "+DoubleToString(profit,2)+" "+AccountInfoString(ACCOUNT_CURRENCY);
      FileWrite(filehandle,symset);
      ar_sSTATUScur[i]=symset;
      if(i==PositionsTotal()-1)
        {
         FileWrite(filehandle,"summa = "+DoubleToString(sumprofit,2)+" "+AccountInfoString(ACCOUNT_CURRENCY));
         FileWrite(filehandle,Abzac);
         FileWrite(filehandle,"Equity = "+DoubleToString(equity,2)+" "+AccountInfoString(ACCOUNT_CURRENCY));
        }
     }
   FileClose(filehandle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteNotify()
  {
   if(pospast==0 && PositionsTotal()==0) return;
//--- ���� ��������� � ��������
   ArrayResize(ar_sSPAM,PositionsTotal()+pospast);
   int j,changing=0;
   for(int i=0;i<PositionsTotal();i++)
     {
      for(j=0;j<pospast;j++) {if(StringSubstr(ar_sSTATUScur[i],0,6)==StringSubstr(ar_sSTATUSpast[j],0,6))break;}
      if(j==pospast)
        {
//         ar_sSPAM[changing]="[position added] "+ar_sSTATUScur[i];
         ar_sSPAM[changing]="[position open] ";//+ar_sSTATUScur[i];
         changing++;
        }
     }
   for(int i=0;i<pospast;i++)
     {
      for(j=0;j<PositionsTotal();j++){if(StringSubstr(ar_sSTATUScur[j],0,6)==StringSubstr(ar_sSTATUSpast[i],0,6))break;}
      if(j==PositionsTotal())
        {
         ar_sSPAM[changing]="[position closed] "+ar_sSTATUSpast[i];
         changing++;
        }
     }
//---
   ArrayResize(ar_sSTATUSpast,ArraySize(ar_sSTATUScur));
   if(ArraySize(ar_sSTATUScur)>0) ArrayCopy(ar_sSTATUSpast,ar_sSTATUScur,0,0,WHOLE_ARRAY);
   pospast=PositionsTotal();
   if(changing==0) return;
//--- ���� ��������� ���� �� ����� ���� notify.txt
   ResetLastError();
   string filename=expname+"\\"+spamfilename;
   int filehandle=FileOpen(filename,FILE_WRITE|FILE_TXT|FILE_ANSI,'\t',codepage);
   if(filehandle!=INVALID_HANDLE)
     {
      for(int i=0;i<changing;i++)
        {FileWrite(filehandle,ar_sSPAM[i]);}
      FileClose(filehandle);
     }
   else Print("�� ������� ������� ���� ",spamfilename,", ������",GetLastError());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteReport()
  {
   if(AccountInfoDouble(ACCOUNT_BALANCE)==curbalance) return;
//--- request trade history
   HistorySelect(0,TimeCurrent());
   if(HistoryDealsTotal()<=0) return;
   string report_buffer[];
   //string report_buffer_sorted[];
   ArrayResize(report_buffer,HistoryDealsTotal());
   int report_size=0,dig;
   string rts="|";
   string opentime,type,size,item,openprice,loss_lim,profit_lim,closetime,closeprice,commision,swap,profit;
   double opendeallots = 0;
   double opendealcomm = 0;
   //datetime opendealtime;
   //string opendealtype;
   double opendealprice=0;
   uint     total=HistoryDealsTotal();
   ulong    ticket=0;
//--- for all deals
   for(uint i=0;i<total;i++)
     {
      if((bool)(ticket=HistoryDealGetTicket(i)))
        {
         if(HistoryDealGetInteger(ticket,DEAL_ENTRY)!=DEAL_ENTRY_OUT) continue;
         if(HistoryDealGetInteger(ticket,DEAL_TYPE)!=DEAL_TYPE_BUY && HistoryDealGetInteger(ticket,DEAL_TYPE)!=DEAL_TYPE_SELL) continue;
         if(HistoryDealGetInteger(ticket,DEAL_TYPE)==DEAL_TYPE_BUY) type="sell";
         if(HistoryDealGetInteger(ticket,DEAL_TYPE)==DEAL_TYPE_SELL)type="buy";
         item       = HistoryDealGetString(ticket,DEAL_SYMBOL);
         opentime   = TimeToString(HistoryDealGetInteger(ticket,DEAL_TIME),TIME_DATE|TIME_MINUTES);
         dig        = (int)SymbolInfoInteger(item,SYMBOL_DIGITS);
         openprice  = DoubleToString(HistoryDealGetDouble(ticket,DEAL_PRICE),dig);
         size       = DoubleToString(HistoryDealGetDouble(ticket,DEAL_VOLUME),2);
         loss_lim   = "";
         profit_lim = "";
         closetime  = TimeToString(HistoryDealGetInteger(ticket,DEAL_TIME),TIME_DATE|TIME_MINUTES);
         closeprice = DoubleToString(HistoryDealGetDouble(ticket,DEAL_PRICE),dig);
         commision  = DoubleToString(HistoryDealGetDouble(ticket,DEAL_COMMISSION),2);
         swap       = DoubleToString(HistoryDealGetDouble(ticket,DEAL_SWAP),2);
         profit     = DoubleToString(HistoryDealGetDouble(ticket,DEAL_PROFIT),2);

         report_buffer[report_size]=opentime+rts+type+rts+size+rts+item+rts+openprice+rts+loss_lim+rts+profit_lim+rts+closetime+rts+closeprice+rts+commision+rts+swap+rts+profit;
         report_size++;
         opendealprice=0;
         opendeallots=0;
         opendealcomm=0;
        }
     }
//--- ���� ��������� ���� �� ����� ���� report.txt
   ResetLastError();
   string filename=expname+"\\"+reportfilename;
   int filehandle=FileOpen(filename,FILE_WRITE|FILE_CSV|FILE_ANSI,rts,codepage);
   if(filehandle!=INVALID_HANDLE)
     {
      for(int i=0;i<report_size;i++)
        {
         FileWrite(filehandle,"@",report_buffer[i]);
        }
      FileWrite(filehandle,"#",DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2),AccountInfoString(ACCOUNT_CURRENCY));
      FileClose(filehandle);
     }
   else Print("�� ������� ������� ���� ",reportfilename,", ������",GetLastError());
//---
  }
//+------------------------------------------------------------------+
