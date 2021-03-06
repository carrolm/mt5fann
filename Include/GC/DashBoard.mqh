//+------------------------------------------------------------------+
//|                                                    DashBoard.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <GC\CurrPairs.mqh>
#include <GC\GetVectors.mqh>
#include <GC\CommonFunctions.mqh>
#include <GC\Watcher.mqh>

#define KEY_NUMPAD_5       12
#define KEY_LEFT           37
#define KEY_UP             38
#define KEY_RIGHT          39
#define KEY_DOWN           40
#define KEY_NUMLOCK_DOWN   98
#define KEY_NUMLOCK_LEFT  100
#define KEY_NUMLOCK_5     101
#define KEY_NUMLOCK_RIGHT 102
#define KEY_NUMLOCK_UP    104
#define KEY_NUMLOCK_PLUS  107
#define KEY_NUMLOCK_MINUS 109


// Major

input bool _Wather_=false;//��������� �������� (�������� � ������)
                         //input bool _TrailingPosition_=true;//��������� ������� �� ��������
//input bool _OpenNewPosition_=false;//��������� ������� � �����
//int TrailingStop=3;

input int MaxPeriod=12; // ���������� ��������

input color _Header=OrangeRed;
input color _Text=RoyalBlue;
input color _TextCurr=Yellow;
input color _Data=CadetBlue;
input color _DataPlus=Lime;
input color _DataMinus = Pink;
input color _Separator = MediumPurple;


input string _DashBoard_="��������";
input string FontName="Tahoma";
input string _Symbol_="����";//"Symbol";
input string _ValueName_ = "���������";//"Value";
input string _CurrentName_ = "�������";//"Value";
input string _TotalName_="�����";//"Total";

string InpPathFirstSound="alert.wav"; // ������ ������ / First signal
string InpPathSecondSound="news.wav"; // ������ ������ / Second signal

ENUM_TIMEFRAMES PeriodNumber[21]=
  {
   PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H2
      ,PERIOD_H4,PERIOD_H6,PERIOD_H8,PERIOD_H12,PERIOD_D1,PERIOD_W1,PERIOD_MN1
  };
string PeriodName[21]={"M1","M5","M15","M30","H1","H2","H4","H6","H8","H12","D1","W1","MN"};

int Experts=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

struct prediction
  {
   string            symbol;// ����� ����
   int               way;// ���������� ������� �� ������ ���� ������
   datetime          BestBefore;// ����� �� 
   int               shift;// �� ������� �������� 
  };
//+==================================================================+
//| CDashBoard                                                                 |
//+==================================================================+
class CDashBoard
  {
protected:
   bool              ShowDashBoard; // �������� ��������
   bool              ShowExperts; // �������� ������
   bool              ShowTable; // �������� �������
   bool              UseSymbol[30];
   int               ChartScale;
   int               TableDataT[50][50];
   int               TableDataV[50][50];
   int               TypeResult;
   string            TableDataG[50];
   int               window;
   string            prefix;
   datetime          LastRefresh;
   //CWatcher          Watcher;
   //CMT5FANN          fannExperts[30];
public:
                     CDashBoard();
                    ~CDashBoard(){DeInit();}
   void              OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //void              Trailing();
   bool              Init();
   bool              DeInit();
   bool              Refresh();
   bool              Calc(int SymbolIdx,int iperiod,int shift_seconds=0);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashBoard::Calc(int SymbolIdx,int PeriodIdx,int shift_seconds=0)
  {
// 
   return(true);

   double BufferO[],BufferC[],BufferL[],BufferH[];
   ArraySetAsSeries(BufferO,true); ArraySetAsSeries(BufferC,true);
   ArraySetAsSeries(BufferL,true); ArraySetAsSeries(BufferH,true);

   int needcopy=11;
   if(CopyOpen(SymbolsArray[SymbolIdx],PeriodNumber[PeriodIdx],0,needcopy,BufferO)!=needcopy)
     {
      return(false);
     }
   if(CopyClose(SymbolsArray[SymbolIdx],PeriodNumber[PeriodIdx],0,needcopy,BufferC)!=needcopy)
     {
      return(false);
     }
   if(CopyLow(SymbolsArray[SymbolIdx],PeriodNumber[PeriodIdx],0,needcopy,BufferL)!=needcopy)
     {
      return(false);
     }
   if(CopyHigh(SymbolsArray[SymbolIdx],PeriodNumber[PeriodIdx],0,needcopy,BufferH)!=needcopy)
     {
      return(false);
     }
   double pw=pow(10,SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_DIGITS));
   TableDataT[SymbolIdx][PeriodIdx]=(int)((BufferC[1]-BufferO[needcopy-1])*pw);
   TableDataV[SymbolIdx][PeriodIdx]=(int)((BufferH[1]-BufferL[needcopy-1])*pw);
   if(PeriodNumber[PeriodIdx]<PERIOD_H1) return(true);

   string graph="----------"; double level=0.0001;
   for(int i=0;i<10;i++)
     {
      if((BufferO[i]-BufferC[i])>level) StringSetCharacter(graph,10-i,'\\');
      else if((BufferC[i]-BufferO[i])>level) StringSetCharacter(graph,10-i,'/');
      //     else graph[i]="-";
     }
   TableDataG[SymbolIdx]=graph;
//Print(SymbolsArray[SymbolIdx]," ",PeriodName[PeriodIdx]," ",graph);
   return(true);
  }
//      /\\\/////\
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDashBoard::CDashBoard()
  {
   prefix="gc_db_";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashBoard::Init(void)
  {
//if (_MustWather_) MustWatcher = new CMustWatcher();
   TypeResult=0;
   ChartScale=1;
   window=ChartWindowOnDropped();
   if(window==0 && ChartGetInteger(0,CHART_WINDOWS_TOTAL)>1) window=1;
   string name;
   LastRefresh=TimeCurrent();
   name=prefix+"ShowDashBoard";
   if(ObjectFind(0,name)==-1)
     {
      ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,0);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,0);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
      ObjectSetString(0,name,OBJPROP_TEXT,"��������");
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
     }
//name=prefix+"ShowExpert";
//if(ObjectFind(0,name)==-1)
//  {
//   ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
//   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,FontSize*10);
//   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,0);
//   ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
//   ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
//   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
//   ObjectSetString(0,name,OBJPROP_TEXT,"��������");
//   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
//  }
//name=prefix+"ShowTable";
//if(ObjectFind(0,name)==-1)
//  {
//   ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
//   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,FontSize*20);
//   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,0);
//   ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
//   ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
//   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
//   ObjectSetString(0,name,OBJPROP_TEXT,"�������");
//   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
//  }
//  ShowTable=ObjectGetInteger(0,prefix+"ShowTable",OBJPROP_STATE);
   ObjectSetInteger(0,prefix+"ShowDashBoard",OBJPROP_STATE,true);
   ShowDashBoard=ObjectGetInteger(0,prefix+"ShowDashBoard",OBJPROP_STATE);

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

   ObjectSetString(0,prefix+"ShowTable",OBJPROP_TEXT,"�����...");
   ChartRedraw();
   CPInit();
//MaxSymbols=CreateSymbolList();
   for(int SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
     {
      UseSymbol[SymbolIdx]=false;
      //fannExperts[SymbolIdx].Init("DashBoard",SymbolsArray[SymbolIdx]);
      //for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // �� ��������
      // Calc(SymbolIdx,iperiod);
     }
   ObjectSetString(0,prefix+"ShowTable",OBJPROP_TEXT,"����������");
   Refresh();
//ObjectSetString(0,prefix+"ShowTable",OBJPROP_TEXT,"�������");
   ChartRedraw();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashBoard::DeInit(void)
  {
   long currChart,prevChart=0;//ChartFirst();
   int i=0,j=0;
   while(j<100)// � ��� ��������� �� ������ 100 �������� ��������
     {
      currChart=ChartNext(prevChart); // �� ��������� ����������� ������� ����� ������
      if(currChart<0) break;          // �������� ����� ������ ��������
                                      //Print(ChartSymbol(currChart),ObjectsTotal(currChart));
      for(i=ObjectsTotal(currChart);i>=0;i--)
         if(StringSubstr(ObjectName(currChart,i),0,6)==prefix) ObjectDelete(currChart,ObjectName(currChart,i));
      prevChart=currChart;// �������� ������������� �������� ������� ��� ChartNext()
      j++;// �� ������� ��������� �������
     }
//  if(Timer1!=NULL) {delete Timer1; Timer1=NULL;}
   EventKillTimer();

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashBoard::Refresh(void)
  {
   //if(_Wather_) Watcher.Run();
//Trailing();

   string name; int SymbolIdx,RowPos;
   double BufferO[],BufferC[],BufferL[],BufferH[];
   ArraySetAsSeries(BufferO,true); ArraySetAsSeries(BufferC,true);
   ArraySetAsSeries(BufferL,true); ArraySetAsSeries(BufferH,true);

   int i,ColPos;
   ulong ticket;
   double   profit;
   //long currChart,prevChart=0;//ChartFirst();
   int limit=10;i=0;
//Print("ChartFirst =",ChartSymbol(prevChart)," ID =",prevChart);
   MqlDateTime str1,str2;

   TimeToStruct(LastRefresh,str1);
   TimeToStruct(TimeCurrent(),str2);
   for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
     {
      for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // �� ��������
        {
         //�������� ��������� ������
         bool selected=ObjectGetInteger(0,prefix+"t_"+SymbolsArray[SymbolIdx]+"_"+PeriodName[iperiod],OBJPROP_STATE);//�������� ��������� ������
                                                                                                                     //���� ������
         if(selected)
           {
            ChartSetSymbolPeriod(0,SymbolsArray[SymbolIdx],PeriodNumber[iperiod]);
            ObjectSetInteger(0,prefix+"t_"+SymbolsArray[SymbolIdx]+"_"+PeriodName[iperiod],OBJPROP_STATE,false);         ChartRedraw();
           }
         else
           {
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(str1.min!=str2.min)
     {
      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
         for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // �� ��������
           {
            if((3599<PeriodSeconds(PeriodNumber[iperiod]) && str1.hour!=str2.hour)
               || (3599>PeriodSeconds(PeriodNumber[iperiod])))
               Calc(SymbolIdx,iperiod);
           }
     }

   HistorySelect(0,TimeCurrent());
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//--- create objects
   ShowDashBoard=ObjectGetInteger(0,prefix+"ShowDashBoard",OBJPROP_STATE);
   if(!ShowDashBoard)
     {
      ShowExperts=false;ObjectSetInteger(0,prefix+"ShowExpert",OBJPROP_STATE,false);
      ShowTable=false;ObjectSetInteger(0,prefix+"ShowTable",OBJPROP_STATE,false);
     }
   if(!ShowTable)
     {
      for(i=ObjectsTotal(0)-1;i>=0;i--)
         if(StringSubstr(ObjectName(0,i),0,5)==prefix+"t_") ObjectDelete(0,ObjectName(0,i));
     }
   if(!ShowDashBoard)
     {
      for(i=ObjectsTotal(0,-1,-1)-1;i>=0;i--)
         if(StringSubstr(ObjectName(0,i),0,5)==prefix+"m_") ObjectDelete(0,ObjectName(0,i));
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      name=prefix+"m_symbols";
      if(ObjectFind(0,name)==-1)
        {
         ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,0);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,FontSize*2);
         ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
         ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
         ObjectSetString(0,name,OBJPROP_TEXT,_Symbol_);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
         ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
        }
      if(ObjectGetInteger(0,name,OBJPROP_STATE))
        {
         int newstate = (ObjectGetInteger(0,prefix+"m_"+SymbolsArray[0],OBJPROP_STATE))?0:1;
         for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
           {
            ObjectSetInteger(0,prefix+"m_"+SymbolsArray[SymbolIdx],OBJPROP_STATE,newstate);
            UseSymbol[SymbolIdx]=newstate;
           }
         ObjectSetInteger(0,name,OBJPROP_STATE,0);
        }
      name=prefix+"m_equity";
      if(ObjectFind(0,name)==-1)
        {
         ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,0*FontSize*10);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,FontSize*4);
         ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
         ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
         ObjectSetInteger(0,name,OBJPROP_SELECTABLE,1);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
        }
      name=prefix+"m_buy";
      if(ObjectFind(0,name)==-1)
        {
         ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,0*FontSize*10);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,FontSize*6);
         ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
         ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
         ObjectSetInteger(0,name,OBJPROP_SELECTABLE,1);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
         ObjectSetString(0,name,OBJPROP_TEXT,"������");
        }
      name=prefix+"m_sell";
      if(ObjectFind(0,name)==-1)
        {
         ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,0*FontSize*10);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,FontSize*8);
         ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
         ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
         ObjectSetInteger(0,name,OBJPROP_SELECTABLE,1);
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
         ObjectSetString(0,name,OBJPROP_TEXT,"�������");
        }
      double ptotal=0;
      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         // if (SymbolSL[SymbolIdx]==0 ) SymbolSL[SymbolIdx] = CalkSL(SymbolIdx);
         long spread=SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD);//MarketInfo(SymbolsArray[SymbolIdx],MODE_SPREAD);
         RowPos=FontSize*2;//+(SymbolIdx+1)*FontSize*2;
         ColPos=(SymbolIdx+1)*FontSize*10;
         name=prefix+"m_tot_"+SymbolsArray[SymbolIdx];
         if(ObjectFind(0,name)==-1)
           {
            ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
            ObjectSetInteger(0,name,OBJPROP_XDISTANCE,ColPos);
            ObjectSetInteger(0,name,OBJPROP_YDISTANCE,RowPos+FontSize*2);
            ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
            ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
            ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
            ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Bg_Color);
            ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
           }
         if(ObjectGetInteger(0,name,OBJPROP_STATE))
           {
            if(_Symbol!=SymbolsArray[SymbolIdx])ChartSetSymbolPeriod(0,SymbolsArray[SymbolIdx],_Period);
            ObjectSetInteger(0,name,OBJPROP_STATE,false);
           }

         // QC
         profit=0;int p_type=-1;
         if(PositionSelect(SymbolsArray[SymbolIdx]))
           {
            p_type=(int)PositionGetInteger(POSITION_TYPE);
           }
         if(TypeResult==0)
           {
            if(PositionSelect(SymbolsArray[SymbolIdx]))
              {
               profit=PositionGetDouble(POSITION_PROFIT);
              }
           }
         else
           {
            int DealsTotal=HistoryDealsTotal();
             datetime dtstart=TimeCurrent();// ����� ��������!
            TimeToStruct(dtstart,str1);
            str1.hour=0; str1.min=0;str1.sec=0;
            if(TypeResult>1) str1.day=1;
            if(TypeResult>2) str1.mon=1;
            if(TypeResult>2) str1.year=2005;

            dtstart=StructToTime(str1);
            for(int idt=0;idt<DealsTotal;idt++)
              {
               if((bool)(ticket=HistoryDealGetTicket(idt)))
                 {
                  if(HistoryDealGetString(ticket,DEAL_SYMBOL)==SymbolsArray[SymbolIdx]&&HistoryDealGetInteger(ticket,DEAL_TIME)>dtstart)
                    {
                     profit+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
                    }
                 }
              }
           }
         ptotal+=profit;
         if(p_type==POSITION_TYPE_BUY || p_type==POSITION_TYPE_SELL) ObjectSetString(0,name,OBJPROP_TEXT,"������� "+(string)(int)profit);
         else {ObjectSetString(0,name,OBJPROP_TEXT,(string)(int)profit);ObjectSetInteger(0,name,OBJPROP_STATE,false);}
         ObjectSetInteger(0,name,OBJPROP_COLOR,_Data);
         if(profit>0)
           {
            ObjectSetInteger(0,name,OBJPROP_COLOR,_DataPlus);
           }
         if(profit<0)
           {
            ObjectSetInteger(0,name,OBJPROP_COLOR,_DataMinus);
           }
         if(ObjectGetInteger(0,name,OBJPROP_STATE))
           {
            //if(p_type==POSITION_TYPE_BUY && sell_price[SymbolIdx]==0)
            //  {
            //   if(PositionGetDouble(POSITION_PROFIT)>0) sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_CURRENT)-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
            //   else sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_OPEN)-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
            //  }
            //if(p_type==POSITION_TYPE_SELL && buy_price[SymbolIdx]==0)
            //  {
            //   if(PositionGetDouble(POSITION_PROFIT)>0) sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_CURRENT)+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
            //   else buy_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_OPEN)+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
            //  }
            ObjectSetInteger(0,name,OBJPROP_STATE,false);
           }
         //      else {sell_price[SymbolIdx]=0; buy_price[SymbolIdx]=0;}
         //\ QC 
         name=prefix+"m_"+SymbolsArray[SymbolIdx];
         if(ObjectFind(0,name)==-1)
           {
            ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
            ObjectSetInteger(0,name,OBJPROP_XDISTANCE,ColPos);
            ObjectSetInteger(0,name,OBJPROP_YDISTANCE,RowPos);
            ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
            ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
            ObjectSetString(0,name,OBJPROP_TEXT,SymbolsArray[SymbolIdx]+"("+DoubleToString(spread,0)+")");
            ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
            ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Bg_Color);
            ObjectSetInteger(0,name,OBJPROP_COLOR,Btn_Color);
            ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
            ObjectSetInteger(0,name,OBJPROP_STATE,UseSymbol[SymbolIdx]);
            ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
           }
         if(Symbol()==SymbolsArray[SymbolIdx]) ObjectSetInteger(0,name,OBJPROP_COLOR,_TextCurr);
         else         ObjectSetInteger(0,name,OBJPROP_COLOR,Btn_Color);
         if(ObjectGetInteger(0,name,OBJPROP_STATE))
           {
            UseSymbol[SymbolIdx]=true;
           }
         else
           {
           }
         name=prefix+"m_buy_"+SymbolsArray[SymbolIdx];
         if(ObjectFind(0,name)==-1)
           {
            ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
            ObjectSetInteger(0,name,OBJPROP_XDISTANCE,ColPos);
            ObjectSetInteger(0,name,OBJPROP_YDISTANCE,RowPos+4*FontSize);
            ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
            ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
            ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
            ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Bg_Color);
            ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
           }
         ulong buy_order=0;
         ulong sell_order=0;
         for(int io=0;io<OrdersTotal();io++)
           {
            OrderGetTicket(io);
            if(OrderGetString(ORDER_SYMBOL)==SymbolsArray[SymbolIdx]&&OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)      sell_order=OrderGetTicket(io);
            if(OrderGetString(ORDER_SYMBOL)==SymbolsArray[SymbolIdx]&&OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT)       buy_order=OrderGetTicket(io);
           }
         if(buy_order>0) ObjectSetString(0,name,OBJPROP_TEXT,"����������");
         else if(p_type==POSITION_TYPE_BUY) ObjectSetString(0,name,OBJPROP_TEXT,"���  +0.1 ���");
         else if(p_type==POSITION_TYPE_SELL) ObjectSetString(0,name,OBJPROP_TEXT,"�������");
         else ObjectSetString(0,name,OBJPROP_TEXT,"+ 0.1");
         if(ObjectGetInteger(0,name,OBJPROP_STATE))
           {
            NewOrder(SymbolsArray[SymbolIdx],NewOrderBuy,"Press DB");
            ObjectSetInteger(0,name,OBJPROP_STATE,false);
           }
         name=prefix+"m_sell_"+SymbolsArray[SymbolIdx];
         if(ObjectFind(0,name)==-1)
           {
            ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
            ObjectSetInteger(0,name,OBJPROP_XDISTANCE,ColPos);
            ObjectSetInteger(0,name,OBJPROP_YDISTANCE,RowPos+6*FontSize);
            ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
            ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
            ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
            ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Bg_Color);
            ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
           }
         if(ObjectGetInteger(0,name,OBJPROP_STATE))
           {// �������
            NewOrder(SymbolsArray[SymbolIdx],NewOrderSell,"Press DB");
            ObjectSetInteger(0,name,OBJPROP_STATE,false);
           }
         if(sell_order>0) ObjectSetString(0,name,OBJPROP_TEXT,"����������");
         else if(p_type==POSITION_TYPE_BUY) ObjectSetString(0,name,OBJPROP_TEXT,"�������");
         else if(p_type==POSITION_TYPE_SELL) ObjectSetString(0,name,OBJPROP_TEXT,"��� -0.1 ���");
         else ObjectSetString(0,name,OBJPROP_TEXT,"- 0.1");
         int ColShift=0;
         if(ShowExperts)
           {
           }
         if(ShowTable)
           {
            for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // �� ��������
              {
               //           ColPos=ColShift+FontSize*50+(iperiod*FontSize*6);
               // int timeframe = PeriodNumber[iperiod];
               RowPos=(iperiod+5)*FontSize*2;
               name=prefix+"t_period_"+PeriodName[iperiod];
               if(ObjectFind(0,name)==-1)
                 {
                  ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
                  ObjectSetString(0,name,OBJPROP_TEXT,PeriodName[iperiod]);
                  ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
                  ObjectSetInteger(0,name,OBJPROP_XDISTANCE,0);
                  ObjectSetInteger(0,name,OBJPROP_YDISTANCE,RowPos);
                  ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
                  ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
                  ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
                  ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Bg_Color);
                  ObjectSetInteger(0,name,OBJPROP_COLOR,Btn_Color);
                  ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
                  // if (Period() == PeriodNumber[iperiod]) ObjectSet(name,OBJPROP_COLOR,_TextCurr );
                 }
               name=prefix+"t_"+SymbolsArray[SymbolIdx]+"_"+PeriodName[iperiod];
               if(ObjectFind(0,name)==-1)
                 {
                  ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
                  ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
                  ObjectSetInteger(0,name,OBJPROP_XDISTANCE,ColPos);
                  ObjectSetInteger(0,name,OBJPROP_YDISTANCE,RowPos);
                  ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
                  ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
                  ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
                  ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Bg_Color);
                  ObjectSetInteger(0,name,OBJPROP_COLOR,Btn_Color);
                  ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
                  // if (Period() == PeriodNumber[iperiod]) ObjectSet(name,OBJPROP_COLOR,_TextCurr );
                 }
               int diff=TableDataT[SymbolIdx][iperiod];
               ObjectSetInteger(0,name,OBJPROP_COLOR,_Data);
               if(diff>2*spread)
                 {
                  ObjectSetInteger(0,name,OBJPROP_COLOR,_DataPlus);
                 }
               if(diff<0-2*spread)
                 {
                  ObjectSetInteger(0,name,OBJPROP_COLOR,_DataMinus);
                 }
               ObjectSetString(0,name,OBJPROP_TEXT,(string)diff+"/"+(string)TableDataV[SymbolIdx][iperiod]);
               if(PeriodNumber[iperiod]>PERIOD_H1) ObjectSetString(0,name,OBJPROP_TEXT,TableDataG[SymbolIdx]);

              }
           }
        }
      if(TypeResult==0) ObjectSetString(0,prefix+"m_equity",OBJPROP_TEXT,"�������� "+(string)(int)ptotal);
      else if(TypeResult==1) ObjectSetString(0,prefix+"m_equity",OBJPROP_TEXT, "�� ���� "+(string)(int)ptotal);
      else if(TypeResult==2) ObjectSetString(0,prefix+"m_equity",OBJPROP_TEXT, "�� ����� "+(string)(int)ptotal);
      else if(TypeResult==3)  ObjectSetString(0,prefix+"m_equity",OBJPROP_TEXT, "����� "+(string)(int)ptotal);
      ObjectSetInteger(0,prefix+"m_equity",OBJPROP_COLOR,_Data);
      if(ptotal>0)
        {
         ObjectSetInteger(0,prefix+"m_equity",OBJPROP_COLOR,_DataPlus);
        }
      if(ptotal<0)
        {
         ObjectSetInteger(0,prefix+"m_equity",OBJPROP_COLOR,_DataMinus);
        }

     }
   return(true);

  }
//+------------------------------------------------------------------+
