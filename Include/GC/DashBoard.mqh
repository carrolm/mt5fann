//+------------------------------------------------------------------+
//|                                                    DashBoard.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#include <Object.mqh>
//#include <ChartObjects\ChartObjectsTxtControls.mqh>

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
input bool _ShowInAllChart_=true;//Показать данные на всех окнах
input bool _TrailingPosition_=true;//Разрешить следить за ордерами
input bool _OpenNewPosition_=false;//Разрешить входить в рынок
int TrailingStop=3;
input bool _EURUSD_=true;//Euro vs US Dollar
input bool _GBPUSD_=true;//Great Britain Pound vs US Dollar
input bool _USDCHF_=true;//US Dollar vs Swiss Franc
input bool _USDJPY_=true;//US Dollar vs Japanese Yen
input bool _USDCAD_=true;//US Dollar vs Canadian Dollar
input bool _AUDUSD_=true;//Australian Dollar vs US Dollar
input bool _NZDUSD_=true;//New Zealand Dollar vs US Dollar
input bool _USDSEK_=false;//US Dollar vs Sweden Kronor
                          // crosses
input bool _AUDNZD_=false;//Australian Dollar vs New Zealand Dollar
input bool _AUDCAD_=false;//Australian Dollar vs Canadian Dollar
input bool _AUDCHF_=false;//Australian Dollar vs Swiss Franc
input bool _AUDJPY_=false;//Australian Dollar vs Japanese Yen
input bool _CHFJPY_=false;//Swiss Frank vs Japanese Yen
input bool _EURGBP_=true;//Euro vs Great Britain Pound 
input bool _EURAUD_=false;//Euro vs Australian Dollar
input bool _EURCHF_=true;//Euro vs Swiss Franc
input bool _EURJPY_=true;//Euro vs Japanese Yen
input bool _EURNZD_=false;//Euro vs New Zealand Dollar
input bool _EURCAD_=false;//Euro vs Canadian Dollar
input bool _GBPCHF_=false;//Great Britain Pound vs Swiss Franc
input bool _GBPJPY_=false;//Great Britain Pound vs Japanese Yen
input bool _CADCHF_=false;//Canadian Dollar vs Swiss Franc

input int MaxPeriod=12; // Количество периодов

input color _Header=OrangeRed;
input color _Text=RoyalBlue;
input color _TextCurr=Yellow;
input color _Data=CadetBlue;
input color _DataPlus=Lime;
input color _DataMinus = Pink;
input color _Separator = MediumPurple;
input color Bg_Color=Gray;
input color Btn_Color=Gold;
input int FontSize=7;
input string _DashBoard_="ДашБорда";
input string FontName ="Tahoma";
input string _Symbol_="Пара";//"Symbol";
input string _ValueName_ = "Результат";//"Value";
input string _CurrentName_ = "Текущий";//"Value";
input string _TotalName_="Всего";//"Total";

input string InpPathFirstSound="alert.wav"; // Первый сигнал / First signal
input string InpPathSecondSound="news.wav"; // Второй сигнал / Second signal

ENUM_TIMEFRAMES PeriodNumber[21]=
  {
   PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H2
      ,PERIOD_H4,PERIOD_H6,PERIOD_H8,PERIOD_H12,PERIOD_D1,PERIOD_W1,PERIOD_MN1
  };
//{PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
string PeriodName[21]={"M1","M5","M15","M30","H1","H2","H4","H6","H8","H12","D1","W1","MN"};
int MaxSymbols=0;
string SymbolsArray[30];//={"","USDCHF","GBPUSD","EURUSD","USDJPY","AUDUSD","USDCAD","EURGBP","EURAUD","EURCHF","EURJPY","GBPJPY","GBPCHF"};

int Experts=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| СОЗДАЁТ СПИСОК ДОСТУПНЫХ ВАЛЮТНЫХ СИМВОЛОВ |
//+------------------------------------------------------------------+
int CreateSymbolList() // QC
  {
   MaxSymbols=0;
   if(_EURUSD_) SymbolsArray[MaxSymbols++]="EURUSD";//Euro vs US Dollar
   if(_GBPUSD_) SymbolsArray[MaxSymbols++]="GBPUSD";//Euro vs US Dollar
   if(_AUDUSD_) SymbolsArray[MaxSymbols++]="AUDUSD";//Euro vs US Dollar
   if(_NZDUSD_) SymbolsArray[MaxSymbols++]="NZDUSD";//Euro vs US Dollar
   if(_USDCHF_) SymbolsArray[MaxSymbols++]="USDCHF";//Euro vs US Dollar
   if(_USDJPY_) SymbolsArray[MaxSymbols++]="USDJPY";//Euro vs US Dollar
   if(_USDCAD_) SymbolsArray[MaxSymbols++]="USDCAD";//Euro vs US Dollar
   if(_USDSEK_) SymbolsArray[MaxSymbols++]="USDSEK";//Euro vs US Dollar
   if(_AUDNZD_) SymbolsArray[MaxSymbols++]="AUDNZD";//Euro vs US Dollar
   if(_AUDCAD_) SymbolsArray[MaxSymbols++]="AUDCAD";//Euro vs US Dollar
   if(_AUDCHF_) SymbolsArray[MaxSymbols++]="AUDCHF";//Euro vs US Dollar
   if(_AUDJPY_) SymbolsArray[MaxSymbols++]="AUDJPY";//Euro vs US Dollar
   if(_CHFJPY_) SymbolsArray[MaxSymbols++]="CHFJPY";//Euro vs US Dollar
   if(_EURGBP_) SymbolsArray[MaxSymbols++]="EURGBP";//Euro vs US Dollar
   if(_EURAUD_) SymbolsArray[MaxSymbols++]="EURAUD";//Euro vs US Dollar
   if(_EURCHF_) SymbolsArray[MaxSymbols++]="EURCHF";//Euro vs US Dollar
   if(_EURJPY_) SymbolsArray[MaxSymbols++]="EURJPY";//Euro vs US Dollar
   if(_EURNZD_) SymbolsArray[MaxSymbols++]="EURNZD";//Euro vs US Dollar
   if(_EURCAD_) SymbolsArray[MaxSymbols++]="EURCAD";//Euro vs US Dollar
   if(_GBPCHF_) SymbolsArray[MaxSymbols++]="GBPCHF";//Euro vs US Dollar
   if(_GBPJPY_) SymbolsArray[MaxSymbols++]="GBPJPY";//Euro vs US Dollar
   if(_CADCHF_) SymbolsArray[MaxSymbols++]="CADCHF";//Euro vs US Dollar

   return(MaxSymbols);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct prediction
  {
   string            symbol;// какая пара
   int               way;// колчиество пунктов со знаком куда пойдет
   datetime          BestBefore;// время до 
   int               shift;// на сколько сдвинуть 
  };
//+------------------------------------------------------------------+
//| Class CTimer                                                     |
//+------------------------------------------------------------------+
class CTimer :public CObject
  {
private:
   ENUM_TIMEFRAMES   _TimePeriod;
   // Для вывода значения таймера | For an output of value of the timer
   string            oname;
   // Для вывода подложки таймера | For an output of a substrate of the timer
   //CChartObjectLabel *TimerSubstrate;
   // Клавиша включения звукового сигнала | Key of inclusion of beep
   //   CChartObjectButton *TimerSignalButton;

   color             _Color,_Substrate;
   ENUM_BASE_CORNER  _Corner;
   bool              InitTimer;
   bool              SoundFlag;
   string            SignalName;
public:
                     CTimer();
                    ~CTimer();
   //--- метод создания объекта / method of creation of object
   bool              Create(long chart_id,string name,int window,int X,int Y,int FontSize);
   //--- метод изменения цвета текста / method of change of colour of the text
   bool              Color(color col);
   color             Color(){return(_Color);}
   //--- метод изменения цвета фона / method of change of colour of a background
   bool              ColorBackground(color col);
   color             ColorBackground(){return(_Substrate);}
   //--- метод изменения угла привязки / method of change of a corner of a binding
   bool              Corner(ENUM_BASE_CORNER corner);
   ENUM_BASE_CORNER  Corner();
   //--- метод установки звукового файла / method of installation of a sound file
   void              SignalFile(string pach){SignalName=pach;StringTrimLeft(SignalName);StringTrimRight(SignalName);SignalOn();}
   string            SignalFile(){return(SignalName);}
   //--- метод включения сигнала / method of inclusion of a signal
   bool              SignalOn();
   //--- метод отключения сигнала / method of switching-off of a signal
   bool              SignalOff();
   //--- метод обработки события OnTimer() / method of processing of event OnTimer()
   void              OnTimer();
   //--- метод обработки событий мыши / method of event processing of the mouse
   void              OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- метод изменения периода таймера / method of change of the period of the timer
   void              TimePeriod(ENUM_TIMEFRAMES period){_TimePeriod=period; OnTimer();}
   ENUM_TIMEFRAMES   TimePeriod(){return(_TimePeriod);}
private:
   datetime          TimeEndOfPeriod();
  };
//+------------------------------------------------------------------+
//| Конструктор / Сonstructor                                        |
//+------------------------------------------------------------------+
CTimer::CTimer()
  {
//   TimerSubstrate=NULL;
//   TimerText=NULL;
//   TimerSignalButton=NULL;
   _TimePeriod=_Period;
   _Color=White;
   _Substrate=Green;
   _Corner=CORNER_RIGHT_LOWER;
   InitTimer=false;
   SoundFlag=false;
   SignalName="";
  }
//+------------------------------------------------------------------+
//| Диструктор / Destructor                                          |
//+------------------------------------------------------------------+
CTimer::~CTimer()
  {
   InitTimer=false;
//   if(TimerSubstrate!=NULL) delete TimerSubstrate;
//   if(TimerText!=NULL) delete TimerText;
//   if(TimerSignalButton!=NULL) delete TimerSignalButton;
  }
//+------------------------------------------------------------------+
//| Метод создания объекта / Method of creation of object            |
//+------------------------------------------------------------------+
bool CTimer::Create(long chart_id,string name,int window,int X,int Y,int FontSize)
  {
   bool result;
   if(_TimePeriod>PERIOD_D1) return(false);
   if(ObjectFind(0,name)==-1)
     {
      ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
      ObjectSetString(0,name,OBJPROP_TEXT,"Wait...");
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
      result=true;
     }
   oname=name;
//TimerSubstrate=new CChartObjectLabel();
//if(ObjectFind(0,"Substrate"+name)==-1)
//   result=TimerSubstrate.Create(0,"Substrate"+name,0,X,Y);
//else
//  {
//   result=TimerSubstrate.Attach(0,"Substrate"+name,0,2);
//   TimerSubstrate.X_Distance(X);
//   TimerSubstrate.Y_Distance(Y);
//  }
//result&=TimerSubstrate.Anchor(ANCHOR_CENTER);
//result&=TimerSubstrate.Font("Webdings");
//result&=TimerSubstrate.FontSize(13);
//result&=TimerSubstrate.Color(_Substrate);
//result&=TimerSubstrate.Corner(_Corner);
//result&=TimerSubstrate.Description("gggg");
//result&=TimerSubstrate.Background(true);
//TimerText=new CChartObjectLabel();
//if(ObjectFind(0,name)==-1)
//   result&=TimerText.Create(0,name,0,X,Y);
//else
//  {
//   result&=TimerText.Attach(0,name,0,2);
//   TimerText.X_Distance(X);
//   TimerText.Y_Distance(Y);
//  }
//result&=TimerText.Anchor(ANCHOR_CENTER);
//result&=TimerText.Font("Arial Black");
//result&=TimerText.FontSize(10);
//result&=TimerText.Color(_Color);
//result&=TimerText.Corner(_Corner);
//result&=TimerText.Background(false);
//result&=TimerText.Description(TimeToString(TimeEndOfPeriod(),TIME_SECONDS));
   SignalOn();
   if(result) InitTimer=true;
   return(result);
  }
//+------------------------------------------------------------------+
//| метод включения сигнала / method of inclusion of a signal        |
//+------------------------------------------------------------------+
bool CTimer::SignalOn()
  {
   int      X,Y;
   string   name_obj;

   return(true);
  }
//+------------------------------------------------------------------+
//| метод отключения сигнала / method of switching-off of a signal   |
//+------------------------------------------------------------------+
bool CTimer::SignalOff()
  {
   int      X,Y;
   string   name_obj;
   bool     result=true;

//   if(TimerSignalButton==NULL) return(false);
//   if(!TimerSignalButton.State()) TimerSignalButton.State(true);
//   TimerSignalButton.Color(Red);
//   TimerSignalButton.Description("V");
//   TimerSignalButton.State(false);
   SoundFlag=false;
   return(result);
  }
//+-----------------------------------------------------------------------------+
//| Метод обработки события OnTimer() / Method of processing of event OnTimer() |
//+-----------------------------------------------------------------------------+
void CTimer::OnTimer()
  {
   static bool BlinkFlag=true;
   if(InitTimer)
     {
      if(_TimePeriod>PERIOD_D1) return;
      datetime tmpTime=TimeEndOfPeriod();
      //      TimerText.Description(TimeToString(tmpTime,TIME_SECONDS));
      if(ObjectFind(0,oname)!=-1)
        {
         ObjectSetString(0,oname,OBJPROP_TEXT,TimeToString(tmpTime,TIME_SECONDS));
        }

      //if(tmpTime<=10)
      //  {
      //   if(SoundFlag && tmpTime<=1)
      //     {
      //      if(!PlaySound(SignalName)) Print("Signal error "+SignalName);
      //     }
      //   if(BlinkFlag)
      //     {
      //      TimerSubstrate.Color(Red);
      //      BlinkFlag=false;
      //     }
      //   else
      //     {
      //      TimerSubstrate.Color(_Substrate);
      //      BlinkFlag=true;
      //     }
      //  }
      //else
      //   TimerSubstrate.Color(_Substrate);
      ChartRedraw();
     }
  }
//+------------------------------------------------------------------------+
//| Метод обработки событий мыши / Method of event processing of the mouse |
//+------------------------------------------------------------------------+
void CTimer::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id==(int)CHARTEVENT_OBJECT_CLICK)
     {
     }
  }
//+-------------------------------------------------------------------+
//| Получение времени оставшееся до закрытия периода                  |
//| Time reception remained before period closing                     |
//+-------------------------------------------------------------------+
datetime CTimer::TimeEndOfPeriod()
  {
   datetime tmpDateTime;
   int tmp;
   MqlDateTime last_time;
   TimeToStruct(TimeTradeServer(),last_time);
   last_time.sec=0;
   if(Period()<=PERIOD_H1)
     {
      tmp=(PeriodSeconds(_TimePeriod)/PeriodSeconds(PERIOD_M1));
      tmp=last_time.min/tmp;
      last_time.min=(tmp+1)*PeriodSeconds(_TimePeriod)/PeriodSeconds(PERIOD_M1);
     }
   else
   if(Period()>PERIOD_H1 && Period()<=PERIOD_D1)
     {
      tmp=(PeriodSeconds(_TimePeriod)/PeriodSeconds(PERIOD_H1));
      tmp=last_time.hour/tmp;
      last_time.hour=(tmp+1)*PeriodSeconds(_TimePeriod)/PeriodSeconds(PERIOD_H1);
      last_time.min=0;
     }
   tmpDateTime=StructToTime(last_time);
   tmpDateTime=tmpDateTime-TimeTradeServer();
   return(tmpDateTime);
  }
//+------------------------------------------------------------------------+
//| Метод изменения цвета текста / Method of change of colour of the text  |
//+------------------------------------------------------------------------+
bool CTimer::Color(color col)
  {
   _Color=col;
//if(TimerText!=NULL)
//   return(TimerText.Color(col));
//else
   return(false);
  }
//+-------------------------------------------------------------------------+
//| Метод изменения цвета фона / Method of change of colour of a background |
//+-------------------------------------------------------------------------+
bool CTimer::ColorBackground(color col)
  {
   _Substrate=col;
//   if(TimerSubstrate!=NULL)
//      return(TimerSubstrate.Color(col));
//   else
   return(false);
  }
//+---------------------------------------------------------------------------+
//| Метод изменения угла привязки / Method of change of a corner of a binding |
//+---------------------------------------------------------------------------+
bool CTimer::Corner(ENUM_BASE_CORNER corner)
  {
   bool result;
   _Corner=corner;
//result=TimerText.Corner(_Corner);
//result&=TimerSubstrate.Corner(_Corner);
//OnTimer();
   return(result);
  }
//+==================================================================+
//| CDashBoard                                                                 |
//+==================================================================+
class CDashBoard
  {
protected:
   bool              ShowDashBoard; // Рисовать Дашборду
   bool              ShowExperts; // Рисовать график
   bool              ShowTable; // Рисовать таблицу
   bool              UseSymbol[30];
   int               ChartScale;
   int               TableDataT[50][50];
   int               TableDataV[50][50];
   int               TypeResult;
   string            TableDataG[50];
   int               window;
   string            prefix;
   double            sell_price[50];
   double            buy_price[50];
   //  CTimer *Timer1;
   CTimer           *TimerH1;
   datetime          LastRefresh;
   MqlTradeRequest   trReq;
   MqlTradeResult    trRez;
public:
                     CDashBoard();
                    ~CDashBoard(){DeInit();}
   void              OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   void              Trailing();
   bool              Init();
   bool              DeInit();
   bool              Refresh();
   bool              Calc(int SymbolIdx,int iperiod,int shift_seconds=0);
   void              OnTimer();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashBoard::Calc(int SymbolIdx,int PeriodIdx,int shift_seconds=0)
  {
// 
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
void CDashBoard::OnTimer()
  {
//   if(Timer1!=NULL) Timer1.OnTimer();
   if(TimerH1!=NULL) TimerH1.OnTimer();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDashBoard::CDashBoard()
  {
   prefix="db_";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashBoard::Init(void)
  {
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
      ObjectSetString(0,name,OBJPROP_TEXT,"ДашБорда");
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
     }
   name=prefix+"ShowExpert";
   if(ObjectFind(0,name)==-1)
     {
      ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,FontSize*10);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,0);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
      ObjectSetString(0,name,OBJPROP_TEXT,"Эксперты");
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
     }
   name=prefix+"ShowTable";
   if(ObjectFind(0,name)==-1)
     {
      ObjectCreate(0,name,OBJ_BUTTON,window,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,FontSize*20);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,0);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
      ObjectSetString(0,name,OBJPROP_TEXT,"Таблица");
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
     }
   ShowDashBoard=ObjectGetInteger(0,prefix+"ShowDashBoard",OBJPROP_STATE);
   ShowTable=ObjectGetInteger(0,prefix+"ShowTable",OBJPROP_STATE);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(Period()<PERIOD_H1)
     {
      TimerH1=new CTimer();
      TimerH1.TimePeriod(PERIOD_H1);
      TimerH1.Create(0,prefix+"H1_Timer",window,FontSize*30,0,FontSize);
      TimerH1.SignalFile(InpPathSecondSound);
     }
   EventSetTimer(1);

   ObjectSetString(0,prefix+"ShowTable",OBJPROP_TEXT,"Расчет...");
   ChartRedraw();
   MaxSymbols=CreateSymbolList();
   for(int SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      UseSymbol[SymbolIdx]=false;
      for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // по периодам
         Calc(SymbolIdx,iperiod);
     }
   ObjectSetString(0,prefix+"ShowTable",OBJPROP_TEXT,"Обновление");
   Refresh();
   ObjectSetString(0,prefix+"ShowTable",OBJPROP_TEXT,"Таблица");
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
   while(j<100)// у нас наверняка не больше 100 открытых графиков
     {
      currChart=ChartNext(prevChart); // на основании предыдущего получим новый график
      if(currChart<0) break;          // достигли конца списка графиков
                                      //Print(ChartSymbol(currChart),ObjectsTotal(currChart));
      for(i=ObjectsTotal(currChart);i>=0;i--)
         if(StringSubstr(ObjectName(currChart,i),0,3)==prefix) ObjectDelete(currChart,ObjectName(currChart,i));
      prevChart=currChart;// запомним идентификатор текущего графика для ChartNext()
      j++;// не забудем увеличить счетчик
     }
//  if(Timer1!=NULL) {delete Timer1; Timer1=NULL;}
   if(TimerH1!=NULL) {delete TimerH1; TimerH1=NULL;}
   EventKillTimer();

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashBoard::Refresh(void)
  {
   string name; int SymbolIdx,RowPos;
   double BufferO[],BufferC[],BufferL[],BufferH[];
   ArraySetAsSeries(BufferO,true); ArraySetAsSeries(BufferC,true);
   ArraySetAsSeries(BufferL,true); ArraySetAsSeries(BufferH,true);

   int i,ColPos;
   ulong ticket;
   double   profit;
   long currChart,prevChart=0;//ChartFirst();
   int limit=100;i=0;
//Print("ChartFirst =",ChartSymbol(prevChart)," ID =",prevChart);
   MqlDateTime str1,str2;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(_ShowInAllChart_)
      while(i<limit)// у нас наверняка не больше 100 открытых графиков
        {
         currChart=ChartNext(prevChart); // на основании предыдущего получим новый график
         if(currChart<0) break;          // достигли конца списка графиков
                                         //       if(_Symbol!=ChartSymbol(currChart)|!ShowDashBoard)
         //        ChartSetInteger(currChart,CHART_SHIFT,true);
         ChartSetInteger(currChart,CHART_SHOW_ASK_LINE,true);
         ChartSetInteger(currChart,CHART_SHOW_BID_LINE,true);
         //        ChartSetInteger(currChart,CHART_SHOW_VOLUMES,CHART_VOLUME_TICK);
         //        ChartSetDouble(currChart,CHART_SHIFT_SIZE,10);
           {
            // выведем спред на график
            name=prefix+"chart_"+ChartSymbol(currChart);
            if(ObjectFind(currChart,name)==-1)
              {
               ObjectCreate(currChart,name,OBJ_LABEL,window,0,0);
               ObjectSetInteger(currChart,name,OBJPROP_XDISTANCE,FontSize*15);
               ObjectSetInteger(currChart,name,OBJPROP_YDISTANCE,FontSize*2);
               ObjectSetInteger(currChart,name,OBJPROP_XSIZE,FontSize*10);
               ObjectSetInteger(currChart,name,OBJPROP_YSIZE,FontSize*2);
               ObjectSetInteger(currChart,name,OBJPROP_FONTSIZE,FontSize*2);
               ObjectSetInteger(currChart,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
              }
           }
         profit=0;
         if(PositionSelect(ChartSymbol(currChart)))
           {
            profit=PositionGetDouble(POSITION_PROFIT);
                 name=prefix+"chart_pos_"+ChartSymbol(currChart);ObjectDelete(currChart,name);
                  if(profit>0)   ObjectCreate(currChart,name,OBJ_ARROW_THUMB_UP,0,PositionGetInteger(POSITION_TIME),PositionGetDouble(POSITION_PRICE_OPEN));
                  else ObjectCreate(currChart,name,OBJ_ARROW_THUMB_DOWN,0,PositionGetInteger(POSITION_TIME),PositionGetDouble(POSITION_PRICE_OPEN));
//                  name="db_closepos_"+ChartSymbol(currChart);
//                  if(ObjectFind(currChart,name)==-1)
//                   {
//                    ObjectCreate(currChart,name,OBJ_BUTTON,window,0,0);
//                    ObjectSetInteger(currChart,name,OBJPROP_XDISTANCE,FontSize*20);
//                    ObjectSetInteger(currChart,name,OBJPROP_YDISTANCE,FontSize*5);
//                    ObjectSetInteger(currChart,name,OBJPROP_XSIZE,FontSize*20);
//                    ObjectSetInteger(currChart,name,OBJPROP_YSIZE,FontSize*3);
//                    ObjectSetInteger(currChart,name,OBJPROP_FONTSIZE,FontSize*2);
//                    ObjectSetInteger(currChart,name,OBJPROP_SELECTABLE,0);
//                    ObjectSetInteger(currChart,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
//         
//                  }
//                 ObjectSetString(currChart,name,OBJPROP_TEXT,"Закрыть c "+(string)((int)profit));
//                 if(0>profit)  ObjectSetInteger(currChart,name,OBJPROP_COLOR,Red);
//                  else ObjectSetInteger(currChart,name,OBJPROP_COLOR,Green);
                 }
                else ObjectDelete(currChart,prefix+"closepos_"+ChartSymbol(currChart));

         if(0==profit)
           {
            ObjectSetInteger(currChart,prefix+"chart_"+ChartSymbol(currChart),OBJPROP_COLOR,Bg_Color);
            ObjectSetString(currChart,prefix+"chart_"+ChartSymbol(currChart),OBJPROP_TEXT,"Спред="+(string)SymbolInfoInteger(ChartSymbol(currChart),SYMBOL_SPREAD));
           }
         else
           {
            TrailingStop=3;
            TrailingStop=(int)(TrailingStop*SymbolInfoInteger(ChartSymbol(currChart),SYMBOL_SPREAD));
            //         ObjectSetString(currChart,prefix+"chart_"+ChartSymbol(currChart),OBJPROP_TEXT,"Спред="+(string)SymbolInfoInteger(ChartSymbol(currChart),SYMBOL_SPREAD)+" результат="+(string)((int)profit)+ " профит="+(string)TrailingStop);
            ObjectSetString(currChart,prefix+"chart_"+ChartSymbol(currChart),OBJPROP_TEXT,"Пока="+(string)((int)profit));
            if(0>profit) ObjectSetInteger(currChart,prefix+"chart_"+ChartSymbol(currChart),OBJPROP_COLOR,Red);
            else ObjectSetInteger(currChart,prefix+"chart_"+ChartSymbol(currChart),OBJPROP_COLOR,Green);
           }
         for(int SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
           {
            if(SymbolsArray[SymbolIdx]==ChartSymbol(currChart))
              {
               name=prefix+"sl_sell_"+SymbolsArray[SymbolIdx];
               if(sell_price[SymbolIdx]>0)
                 {
                  if(ObjectFind(currChart,name)==-1)
                    {// создаём линию
                     ObjectCreate(currChart,name,OBJ_HLINE,0,0,sell_price[SymbolIdx]);
                     ObjectSetInteger(currChart,name,OBJPROP_SELECTABLE,true);
                     //              ObjectSetInteger(currChart,name,OBJPROP_SELECTED,true);
                     ObjectSetInteger(currChart,name,OBJPROP_STYLE,STYLE_DASHDOTDOT);
                     ObjectSetInteger(currChart,name,OBJPROP_COLOR,Yellow);
                    }
                  if(ObjectGetInteger(currChart,name,OBJPROP_SELECTED)) sell_price[SymbolIdx]=ObjectGetDouble(currChart,name,OBJPROP_PRICE);
                  else
                    {
                     if(PositionSelect(SymbolsArray[SymbolIdx]))
                       {// есть открытая позиция
                        if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
                          {// допродажа
                          }
                        else if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
                          {// Закрытие покупки - паника или снятие сливок
                           if(PositionGetDouble(POSITION_PRICE_OPEN)>(PositionGetDouble(POSITION_PRICE_CURRENT)-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1))
                              // паника
                              sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_OPEN)+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.0;
                           else
                           // снятие сливок
                              if(CopyClose(SymbolsArray[SymbolIdx],_Period,0,2,BufferC)==2) sell_price[SymbolIdx]=BufferC[1]-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.1;
                          }
                       }
                     else
                       {  // нет открытой позиции
                        if(ObjectGetInteger(currChart,name,OBJPROP_SELECTED)) sell_price[SymbolIdx]=ObjectGetDouble(currChart,name,OBJPROP_PRICE);
                        else if(CopyClose(SymbolsArray[SymbolIdx],_Period,0,2,BufferC)==2) sell_price[SymbolIdx]=BufferC[1]-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.1;
                       }
                    }
                  ObjectSetDouble(currChart,name,OBJPROP_PRICE,sell_price[SymbolIdx]);
                 }
               else ObjectDelete(currChart,name);
               name=prefix+"sl_buy_"+SymbolsArray[SymbolIdx];
               if(buy_price[SymbolIdx]>0)
                 {
                  if(ObjectFind(currChart,name)==-1)
                    {
                     ObjectCreate(currChart,name,OBJ_HLINE,0,0,buy_price[SymbolIdx]);
                     ObjectSetInteger(currChart,name,OBJPROP_SELECTABLE,true);
                     //             ObjectSetInteger(currChart,name,OBJPROP_SELECTED,true);
                     ObjectSetInteger(currChart,name,OBJPROP_STYLE,STYLE_DASHDOTDOT);
                     ObjectSetInteger(currChart,name,OBJPROP_COLOR,Yellow);
                    }
                  if(ObjectGetInteger(currChart,name,OBJPROP_SELECTED)) buy_price[SymbolIdx]=ObjectGetDouble(currChart,name,OBJPROP_PRICE);
                  else
                    {
                     if(PositionSelect(SymbolsArray[SymbolIdx]))
                       { // есть отрытые позиции
                        if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
                          {// допокупка
                          }
                        else if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
                          {// Закрытие продажи
                           if(PositionGetDouble(POSITION_PRICE_OPEN)<(PositionGetDouble(POSITION_PRICE_CURRENT)+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1))
                              // паника
                              buy_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_OPEN)-+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1;
                           else // снятие сливок
                           if(CopyClose(SymbolsArray[SymbolIdx],_Period,0,2,BufferC)==2) buy_price[SymbolIdx]=BufferC[1]+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.1;
                          }
                       }
                     else
                       {
                        if(ObjectGetInteger(currChart,name,OBJPROP_SELECTED)) buy_price[SymbolIdx]=ObjectGetDouble(currChart,name,OBJPROP_PRICE);
                        else if(CopyClose(SymbolsArray[SymbolIdx],_Period,0,2,BufferC)==2) buy_price[SymbolIdx]=BufferC[1]+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.1;
                       }
                    }
                  ObjectSetDouble(currChart,name,OBJPROP_PRICE,buy_price[SymbolIdx]);
                 }
               else ObjectDelete(currChart,name);
              }
           }

         prevChart=currChart;// запомним идентификатор текущего графика для ChartNext()
         i++;// не забудем увеличить счетчик
        }
   TimeToStruct(LastRefresh,str1);
   TimeToStruct(TimeCurrent(),str2);
   for(int SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
     {
      for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // по периодам
        {
         //проверим состояние кнопки
         bool selected=ObjectGetInteger(0,prefix+"t_"+SymbolsArray[SymbolIdx]+"_"+PeriodName[iperiod],OBJPROP_STATE);//проверим состояние кнопки
                                                                                                                     //если нажата
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
      for(int SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
         for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // по периодам
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
         ObjectSetInteger(0,name,OBJPROP_SELECTABLE,1);
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
         ObjectSetString(0,name,OBJPROP_TEXT,"Купить");
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
         ObjectSetString(0,name,OBJPROP_TEXT,"Продать");
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
            //Print(SymbolsArray[SymbolIdx],p_type);
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
            MqlDateTime str1;
            datetime dtstart=TimeCurrent();// выбор периодов!
            TimeToStruct(dtstart,str1);
            str1.hour=0; str1.min=0;str1.sec=0;
            if(TypeResult>1) str1.day=1;
            if(TypeResult>2) str1.mon=1;
            if(TypeResult>2) str1.year=2005;

            dtstart=StructToTime(str1);
            for(int idt=0;idt<DealsTotal;idt++)
              {
               if(ticket=HistoryDealGetTicket(idt))
                 {
                  if(HistoryDealGetString(ticket,DEAL_SYMBOL)==SymbolsArray[SymbolIdx]&HistoryDealGetInteger(ticket,DEAL_TIME)>dtstart)
                    {
                     profit+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
                    }
                 }
              }
           }
         ptotal+=profit;
         if(p_type==POSITION_TYPE_BUY || p_type==POSITION_TYPE_SELL) ObjectSetString(0,name,OBJPROP_TEXT,"Закрыть "+(string)(int)profit);
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
            if(p_type==POSITION_TYPE_BUY && sell_price[SymbolIdx]==0)
              {
               if(PositionGetDouble(POSITION_PROFIT)>0) sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_CURRENT)-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
               else sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_OPEN)-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
              }
            if(p_type==POSITION_TYPE_SELL && buy_price[SymbolIdx]==0)
              {
               if(PositionGetDouble(POSITION_PROFIT)>0) sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_CURRENT)+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
               else buy_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_OPEN)+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
              }
            //ObjectSetInteger(0,name,OBJPROP_STATE,false);
           }
         //      else {sell_price[SymbolIdx]=0; buy_price[SymbolIdx]=0;}
         //\ QC 
         name=prefix+"m_"+SymbolsArray[SymbolIdx];
         //      ObjectDelete(0,name);
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
         if(buy_price[SymbolIdx]>0) ObjectSetString(0,name,OBJPROP_TEXT,"отказаться");
         else if(p_type==POSITION_TYPE_BUY) ObjectSetString(0,name,OBJPROP_TEXT,"ещё  +0.1 лот");
         else if(p_type==POSITION_TYPE_SELL) ObjectSetString(0,name,OBJPROP_TEXT,"закрыть");
         else ObjectSetString(0,name,OBJPROP_TEXT,"+ 0.1");
         if(ObjectGetInteger(0,name,OBJPROP_STATE))
           {
            if(buy_price[SymbolIdx]>0) buy_price[SymbolIdx]=0;
            else  if(p_type==POSITION_TYPE_SELL && buy_price[SymbolIdx]==0)
              {
               if(PositionGetDouble(POSITION_PROFIT)>0) buy_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_CURRENT)+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.0;
               else buy_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_OPEN)-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT);
              }
            else if(CopyClose(SymbolsArray[SymbolIdx],_Period,0,2,BufferC)==2) buy_price[SymbolIdx]=BufferC[1]+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.5;
            ObjectSetInteger(0,name,OBJPROP_STATE,false);
           }
         //else  buy_price[SymbolIdx]=0;
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
           {
            if(sell_price[SymbolIdx]>0) sell_price[SymbolIdx]=0;
            else  if(p_type==POSITION_TYPE_BUY && sell_price[SymbolIdx]==0)
              {
               if(PositionGetDouble(POSITION_PROFIT)>0) sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_CURRENT)-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.0;
               else sell_price[SymbolIdx]=PositionGetDouble(POSITION_PRICE_OPEN)+SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*2;
              }
            else if(CopyClose(SymbolsArray[SymbolIdx],_Period,0,2,BufferC)==2) sell_price[SymbolIdx]=BufferC[1]-SymbolInfoInteger(SymbolsArray[SymbolIdx],SYMBOL_SPREAD)*SymbolInfoDouble(SymbolsArray[SymbolIdx],SYMBOL_POINT)*1.5;
            Print("Sell ...",sell_price[SymbolIdx]);
            ObjectSetInteger(0,name,OBJPROP_STATE,false);
           }
         //       else  sell_price[SymbolIdx]=0;
         if(sell_price[SymbolIdx]>0) ObjectSetString(0,name,OBJPROP_TEXT,"отказаться");
         else if(p_type==POSITION_TYPE_BUY) ObjectSetString(0,name,OBJPROP_TEXT,"закрыть");
         else if(p_type==POSITION_TYPE_SELL) ObjectSetString(0,name,OBJPROP_TEXT,"ещё -0.1 лот");
         else ObjectSetString(0,name,OBJPROP_TEXT,"- 0.1");
         int ColShift=0;
         if(ShowExperts)
           {
           }
         if(ShowTable)
           {
            for(int iperiod=0; iperiod<MaxPeriod;iperiod++) // по периодам
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
      if(TypeResult==0) ObjectSetString(0,prefix+"m_equity",OBJPROP_TEXT,"Открытые "+(string)(int)ptotal);
      else if(TypeResult==1) ObjectSetString(0,prefix+"m_equity",OBJPROP_TEXT, "За день "+(string)(int)ptotal);
      else if(TypeResult==2) ObjectSetString(0,prefix+"m_equity",OBJPROP_TEXT, "За месяц "+(string)(int)ptotal);
      else if(TypeResult==3)  ObjectSetString(0,prefix+"m_equity",OBJPROP_TEXT, "Всего "+(string)(int)ptotal);

     }
   return(true);

  }
//+------------------------------------------------------------------+
