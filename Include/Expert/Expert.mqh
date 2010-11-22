//+------------------------------------------------------------------+
//|                                                       Expert.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.08 |
//+------------------------------------------------------------------+
#include <Expert\ExpertTrade.mqh>
#include <Expert\ExpertSignal.mqh>
#include <Expert\ExpertMoney.mqh>
#include <Expert\ExpertTrailing.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Indicators\Indicators.mqh>
//---
enum ENUM_TRADE_EVENTS
  {
   TRADE_EVENT_NO_EVENT          =0,
   TRADE_EVENT_POSITION_OPEN     =0x1,
   TRADE_EVENT_POSITION_ADD      =0x2,
   TRADE_EVENT_POSITION_MODIFY   =0x4,
   TRADE_EVENT_POSITION_CLOSE    =0x8,
   TRADE_EVENT_POSITION_STOP_TAKE=0x10,
   TRADE_EVENT_ORDER_PLACE       =0x20,
   TRADE_EVENT_ORDER_MODIFY      =0x40,
   TRADE_EVENT_ORDER_DELETE      =0x80,
   TRADE_EVENT_ORDER_TRIGGER     =0x100
  };
//+------------------------------------------------------------------+
//| Class CExpert.                                                   |
//| Appointment: Base class expert advisor.                          |
//+------------------------------------------------------------------+
class CExpert
  {
protected:
   double            m_adjusted_point;           // point value adjusted for 3 or 5 points
   ENUM_TIMEFRAMES   m_period;                   // timeframe for work
   int               m_period_flags;             // timeframe flags (as visible flags)
   int               m_max_orders;               // max number of orders (include position)
   MqlDateTime       m_last_tick_time;           // time of last tick
   datetime          m_expiration;               // time expiration order
   //--- history info
   int               m_pos_tot;
   int               m_deal_tot;
   int               m_ord_tot;
   int               m_hist_ord_tot;
   datetime          m_beg_date;
   //---
   int               m_waiting_event;
   //---
   CExpertTrade     *m_trade;                    // trading object
   CExpertSignal    *m_signal;                   // trading signals object
   CExpertMoney     *m_money;                    // money manager object
   CExpertTrailing  *m_trailing;                 // trailing stops object
   //--- indicators
   CIndicators      *m_indicators;               // indicator collection to fast recalculations
   //--- symbol info
   CSymbolInfo       m_symbol;                   // symbol info object
   CAccountInfo      m_account;                  // account info wrapper
   CPositionInfo     m_position;                 // position info object
   COrderInfo        m_order;                    // order info object

public:
                     CExpert();
                    ~CExpert()                            { Deinit();                                               }
   bool              Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,long magic=0);
   //---
   virtual bool      InitSignal(CExpertSignal* signal=NULL);
   virtual bool      InitTrailing(CExpertTrailing* trailing=NULL);
   virtual bool      InitMoney(CExpertMoney* money=NULL);
   //---
   virtual void      Deinit();
   //---
   int               MaxOrders()                    const { return(m_max_orders);                                   }
   void              MaxOrders(int max_orders)            { m_max_orders=max_orders;                                }
   //--- event handlers
   virtual void      OnTick();
   virtual void      OnTrade();
   virtual void      OnTimer();

protected:
   //--- initialization
   virtual bool      InitParameters()                     { return(true);                                           }
   virtual bool      InitIndicators();
   virtual bool      InitTrade(long magic);
   //--- deinitialization
   virtual void      DeinitTrade();
   virtual void      DeinitSignal();
   virtual void      DeinitTrailing();
   virtual void      DeinitMoney();
   virtual void      DeinitIndicators();
   //--- refreshing 
   virtual bool      Refresh();
   //--- processing (main method)
   virtual bool      Processing();
   //--- trade open positions check
   virtual bool      CheckOpen();
   virtual bool      CheckOpenShort();
   virtual bool      CheckOpenLong();
   //--- trade open positions processing
   virtual bool      OpenLong(double price,double sl,double tp);
   virtual bool      OpenShort(double price,double sl,double tp);
   //--- trade close positions check
   virtual bool      CheckClose();
   virtual bool      CheckCloseLong();
   virtual bool      CheckCloseShort();
   //--- trade close positions processing
   virtual bool      CloseAll(double lot);
   virtual bool      Close();
   virtual bool      CloseLong(double price);
   virtual bool      CloseShort(double price);
   //--- trailing stop check
   virtual bool      CheckTrailingStop();
   virtual bool      CheckTrailingStopLong();
   virtual bool      CheckTrailingStopShort();
   //--- trailing stop processing
   virtual bool      TrailingStopLong(double sl,double tp);
   virtual bool      TrailingStopShort(double sl,double tp);
   //--- trailing order check
   virtual bool      CheckTrailingOrderLong();
   virtual bool      CheckTrailingOrderShort();
   //--- trailing order processing
   virtual bool      TrailingOrderLong(double delta);
   virtual bool      TrailingOrderShort(double delta);
   //--- delete order check
   virtual bool      CheckDeleteOrderLong();
   virtual bool      CheckDeleteOrderShort();
   //--- delete order processing
   virtual bool      DeleteOrders();
   virtual bool      DeleteOrder();
   virtual bool      DeleteOrderLong();
   virtual bool      DeleteOrderShort();
   //--- lot for trade
   double            LotOpenLong(double price,double sl);
   double            LotOpenShort(double price,double sl);
   //---
   void              PrepareHistoryDate();
   void              HistoryPoint(bool from_check_trade=false);
   bool              CheckTradeState();
   //--- set/reset waiting events
   void              WaitEvent(ENUM_TRADE_EVENTS event)   { m_waiting_event|=event;                                 }
   void              NoWaitEvent(ENUM_TRADE_EVENTS event) { m_waiting_event&=~event;                                }
   //--- check waiting events
   bool              IsWaitingPositionOpen()        const { return(m_waiting_event&TRADE_EVENT_POSITION_OPEN);      }
   bool              IsWaitingPositionAddSub()      const { return(m_waiting_event&TRADE_EVENT_POSITION_ADD);       }
   bool              IsWaitingPositionModify()      const { return(m_waiting_event&TRADE_EVENT_POSITION_MODIFY);    }
   bool              IsWaitingPositionClose()       const { return(m_waiting_event&TRADE_EVENT_POSITION_CLOSE);     }
   bool              IsWaitingPositionStopTake()    const { return(m_waiting_event&TRADE_EVENT_POSITION_STOP_TAKE); }
   bool              IsWaitingOrderPlace()          const { return(m_waiting_event&TRADE_EVENT_ORDER_PLACE);        }
   bool              IsWaitingOrderModify()         const { return(m_waiting_event&TRADE_EVENT_ORDER_MODIFY);       }
   bool              IsWaitingOrderDelete()         const { return(m_waiting_event&TRADE_EVENT_ORDER_DELETE);       }
   bool              IsWaitingOrderTrigger()        const { return(m_waiting_event&TRADE_EVENT_ORDER_TRIGGER);      }
   //--- trade events
   virtual bool      TradeEventStopTakeTrigger()          { return(true);                                           }
   virtual bool      TradeEventOrderTrigger()             { return(true);                                           }
   virtual bool      TradeEventPositionOpen()             { return(true);                                           }
   virtual bool      TradeEventPositionAddSub()           { return(true);                                           }
   virtual bool      TradeEventPositionModify()           { return(true);                                           }
   virtual bool      TradeEventPositionClose()            { return(true);                                           }
   virtual bool      TradeEventOrderPlace()               { return(true);                                           }
   virtual bool      TradeEventOrderModify()              { return(true);                                           }
   virtual bool      TradeEventOrderDelete()              { return(true);                                           }
   virtual bool      TradeEventNotIdentified()            { return(true);                                           }
   //--- timeframe functions
   void              TimeframeAdd(ENUM_TIMEFRAMES period);
   int               TimeframesFlags(MqlDateTime& time);
  };
//+------------------------------------------------------------------+
//| Constructor CExpert.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CExpert::CExpert()
  {
//---
   m_adjusted_point     =0;
   m_period             =WRONG_VALUE;
   m_period_flags       =0;
   m_max_orders         =1;
   m_last_tick_time.min =-1;
   m_expiration         =0;
//---
   m_pos_tot            =0;
   m_deal_tot           =0;
   m_ord_tot            =0;
   m_hist_ord_tot       =0;
   m_beg_date           =0;
//---
   m_indicators         =NULL;
   m_trade              =NULL;
   m_signal             =NULL;
   m_money              =NULL;
   m_trailing           =NULL;
  }
//+------------------------------------------------------------------+
//| Initialization and checking for input parameters                 |
//| INPUT:  symbol     - symbol name,                                |
//|         period     - period,                                     |
//|         every_tick - every tick flag,                            |
//|         magic      - magic number for trade.                     |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,long magic)
  {
//--- initialize common information
   m_symbol.Name(symbol);                   // symbol
   m_period=period;                         // period
   if(every_tick)
      TimeframeAdd(WRONG_VALUE);            // add all periods
   else
      TimeframeAdd(period);                 // add specified period
//--- tuning for 3 or 5 digits
   int digits_adjust=1;
   if(m_symbol.Digits()==3 || m_symbol.Digits()==5) digits_adjust=10;
   m_adjusted_point=m_symbol.Point()*digits_adjust;
//--- initializing objects expert
   if(!InitTrade(magic))  return(false);
   if(!InitSignal())      return(false);
   if(!InitTrailing())    return(false);
   if(!InitMoney())       return(false);
   if(!InitParameters())  return(false);
//---
   PrepareHistoryDate();
   HistoryPoint();
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization trade object                                      |
//| INPUT:  magic  -magic number for trade.                          |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::InitTrade(long magic)
  {
   if(m_trade==NULL)
     {
      if((m_trade=new CExpertTrade)==NULL) return(false);
      m_trade.SetSymbol(GetPointer(m_symbol)); // symbol for trade
      m_trade.SetExpertMagicNumber(magic);     // magic
      //--- set default deviation for trading in adjusted points
      m_trade.SetDeviationInPoints((ulong)(3*m_adjusted_point/m_symbol.Point()));
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization signal object                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::InitSignal(CExpertSignal *signal)
  {
   if(m_signal!=NULL) delete m_signal;
//---
   if(signal==NULL)
     {
      if((m_signal=new CExpertSignal)==NULL) return(false);
     }
   else
      m_signal=signal;
//--- initializing signal object
   if(!m_signal.Init(GetPointer(m_symbol),m_period,m_adjusted_point)) return(false);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization trailing object                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::InitTrailing(CExpertTrailing *trailing)
  {
   if(m_trailing!=NULL) delete m_trailing;
//---
   if(trailing==NULL)
     {
      if((m_trailing=new CExpertTrailing)==NULL) return(false);
     }
   else
      m_trailing=trailing;
//--- initializing trailing object
   if(!m_trailing.Init(GetPointer(m_symbol),m_period,m_adjusted_point)) return(false);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization money object                                      |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::InitMoney(CExpertMoney *money)
  {
   if(m_money!=NULL) delete m_money;
//---
   if(money==NULL)
     {
      if((m_money=new CExpertMoney)==NULL) return(false);
     }
   else
      m_money=money;
//--- initializing money object
   if(!m_money.Init(GetPointer(m_symbol),m_period,m_adjusted_point)) return(false);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization indicators                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::InitIndicators()
  {
//--- create indicators collection
   if(m_indicators==NULL)
      if((m_indicators=new CIndicators)==NULL)
        {
         printf("CExpert::InitIndicators: Error creating indicators collection");
         return(false);
        }
   if(!m_signal.InitIndicators(m_indicators))   return(false);
   if(!m_trailing.InitIndicators(m_indicators)) return(false);
   if(!m_money.InitIndicators(m_indicators))    return(false);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Deinitialization expert                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::Deinit()
  {
//--- delete trade class
   DeinitTrade();
//--- delete signal class
   DeinitSignal();
//--- delete trailing class
   DeinitTrailing();
//--- delete money class
   DeinitMoney();
//--- delete indicators collection
   DeinitIndicators();
//---
  }
//+------------------------------------------------------------------+
//| Deinitialization trade object                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::DeinitTrade()
  {
   if(m_trade!=NULL)
     {
      delete m_trade;
      m_trade=NULL;
     }
  }
//+------------------------------------------------------------------+
//| Deinitialization signal object                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::DeinitSignal()
  {
   if(m_signal!=NULL)
     {
      delete m_signal;
      m_signal=NULL;
     }
  }
//+------------------------------------------------------------------+
//| Deinitialization trailing object                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::DeinitTrailing()
  {
   if(m_trailing!=NULL)
     {
      delete m_trailing;
      m_trailing=NULL;
     }
  }
//+------------------------------------------------------------------+
//| Deinitialization money object                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::DeinitMoney()
  {
   if(m_money!=NULL)
     {
      delete m_money;
      m_money=NULL;
     }
  }
//+------------------------------------------------------------------+
//| Deinitialization indicators                                      |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::DeinitIndicators()
  {
   if(m_indicators!=NULL)
     {
      delete m_indicators;
      m_indicators=NULL;
     }
  }
//+------------------------------------------------------------------+
//| Refreshing data for processing                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::Refresh()
  {
   MqlDateTime time;
//--- check need processing
   TimeCurrent(time);
   if(m_period_flags!=WRONG_VALUE && m_period_flags!=0)
      if((m_period_flags & TimeframesFlags(time))==0) return(false);

   m_last_tick_time=time;
//--- refresh rates
   if(!m_symbol.RefreshRates()) return(false);
//--- refresh indicators
   m_indicators.Refresh();
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Main function                                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if any trade operation processed, false otherwise.  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::Processing()
  {
//--- check if open positions
   if(m_position.Select(m_symbol.Name()))
     {
      //--- open position is available
      //--- check the possibility of closing the position/delete pending orders
      if(!CheckClose())
        {
         //--- check the possibility of modifying the position
         if(CheckTrailingStop()) return(true);
        }
     }
//--- check the possibility of opening a position/setting pending order
   if(CheckOpen()) return(true);
//--- check if plased pending orders
   int total=OrdersTotal();
   if(total!=0)
     {
      for(int i=total-1;i>=0;i--)
        {
         m_order.Select(OrderGetTicket(i));
         if(m_order.Symbol()!=m_symbol.Name()) continue;
         if(m_order.Type()==ORDER_TYPE_BUY_LIMIT || m_order.Type()==ORDER_TYPE_BUY_STOP)
           {
            //--- check the ability to delete a pending order to buy
            if(CheckDeleteOrderLong()) return(true);
            //--- check the possibility of modifying a pending order to buy
            if(CheckTrailingOrderLong()) return(true);
           }
         else
           {
            //--- check the ability to delete a pending order to sell
            if(CheckDeleteOrderShort()) return(true);
            //--- check the possibility of modifying a pending order to sell
            if(CheckTrailingOrderShort()) return(true);
           }
        }
     }
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| OnTick handler                                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::OnTick()
  {
//--- updated quotes and indicators
   if(!Refresh()) return;
//--- expert processing
   Processing();
  }
//+------------------------------------------------------------------+
//| OnTrade handler                                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::OnTrade()
  {
   CheckTradeState();
  }
//+------------------------------------------------------------------+
//| OnTimer handler                                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::OnTimer()
  {
  }
//+------------------------------------------------------------------+
//| Check for position open or limit/stop order set                  |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckOpen()
  {
   if(CheckOpenLong())  return(true);
   if(CheckOpenShort()) return(true);
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for long position open or limit/stop order set             |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckOpenLong()
  {
   double   price,sl,tp;
   datetime expiration=TimeCurrent();
//--- check signal for long enter operations
   if(m_signal.CheckOpenLong(price,sl,tp,expiration))
     {
      if(!m_trade.SetOrderExpiration(expiration))
        {
         m_expiration=expiration;
        }
      return(OpenLong(price,sl,tp));
     }
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for short position open or limit/stop order set            |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckOpenShort()
  {
   double   price,sl,tp;
   datetime expiration=TimeCurrent();
//--- check signal for short enter operations
   if(m_signal.CheckOpenShort(price,sl,tp,expiration))
     {
      if(!m_trade.SetOrderExpiration(expiration))
        {
         m_expiration=expiration;
        }
      return(OpenShort(price,sl,tp));
     }
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Long position open or limit/stop order set                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::OpenLong(double price,double sl,double tp)
  {
//--- get lot for open
   double lot=LotOpenLong(price,sl);
//--- check lot for open
   if(lot==0.0) return(false);
//---
   return(m_trade.Buy(lot,price,sl,tp));
  }
//+------------------------------------------------------------------+
//| Short position open or limit/stop order set                      |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::OpenShort(double price,double sl,double tp)
  {
//--- get lot for open
   double lot=LotOpenShort(price,sl);
//--- check lot for open
   if(lot==0.0) return(false);
//---
   return(m_trade.Sell(lot,price,sl,tp));
  }
//+------------------------------------------------------------------+
//| Check for position close or limit/stop order delete              |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckClose()
  {
   double lot;
//--- position must be selected before call
   if((lot=m_money.CheckClose(GetPointer(m_position)))!=0.0)
      return(CloseAll(lot));
//--- check for position type
   if(m_position.Type()==POSITION_TYPE_BUY)
     {
      //--- check the possibility of closing the long position / delete pending orders to buy
      if(CheckCloseLong())
        {
         DeleteOrders();
         return(true);
        }
     }
   else
     {
      //--- check the possibility of closing the short position / delete pending orders to sell
      if(CheckCloseShort())
        {
         DeleteOrders();
         return(true);
        }
     }
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for long position close or limit/stop order delete         |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckCloseLong()
  {
   double price;
//--- check for long close operations
   if(m_signal.CheckCloseLong(price))
      return(CloseLong(price));
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for short position close or limit/stop order delete        |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckCloseShort()
  {
   double price;
//--- check for short close operations
   if(m_signal.CheckCloseShort(price))
      return(CloseShort(price));
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Position close and orders delete                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CloseAll(double lot)
  {
   bool result;
//--- check for close operations
   if(m_position.Type()==POSITION_TYPE_BUY) result=m_trade.Sell(lot,0,0,0);
   else                                     result=m_trade.Buy(lot,0,0,0);
   result|=DeleteOrders();
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Position close                                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::Close()
  {
   return(m_trade.PositionClose(m_symbol.Name()));
  }
//+------------------------------------------------------------------+
//| Long position close                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CloseLong(double price)
  {
   return(m_trade.Sell(m_position.Volume(),price,0,0));
  }
//+------------------------------------------------------------------+
//| Short position close                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CloseShort(double price)
  {
   return(m_trade.Buy(m_position.Volume(),price,0,0));
  }
//+------------------------------------------------------------------+
//| Check for trailing stop/profit position                          |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckTrailingStop()
  {
//--- position must be selected before call
   if(m_position.Type()==POSITION_TYPE_BUY)
     {
      //--- check the possibility of modifying the long position
      if(CheckTrailingStopLong()) return(true);
     }
   else
     {
      //--- check the possibility of modifying the short position
      if(CheckTrailingStopShort()) return(true);
     }
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for trailing stop/profit long position                     |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckTrailingStopLong()
  {
   double sl=EMPTY_VALUE;
   double tp=EMPTY_VALUE;
//--- check for long trailing stop operations
   if(m_trailing.CheckTrailingStopLong(GetPointer(m_position),sl,tp))
     {
      if(sl==EMPTY_VALUE) sl=m_position.StopLoss();
      if(tp==EMPTY_VALUE) tp=m_position.TakeProfit();
      //--- long trailing stop operations
      return(TrailingStopLong(sl,tp));
     }
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for trailing stop/profit short position                    |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckTrailingStopShort()
  {
   double sl=EMPTY_VALUE;
   double tp=EMPTY_VALUE;
//--- check for short trailing stop operations
   if(m_trailing.CheckTrailingStopShort(GetPointer(m_position),sl,tp))
     {
      if(sl==EMPTY_VALUE) sl=m_position.StopLoss();
      if(tp==EMPTY_VALUE) tp=m_position.TakeProfit();
      //--- short trailing stop operations
      return(TrailingStopShort(sl,tp));
     }
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Trailing stop/profit long position                               |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::TrailingStopLong(double sl,double tp)
  {
   return(m_trade.PositionModify(m_symbol.Name(),sl,tp));
  }
//+------------------------------------------------------------------+
//| Trailing stop/profit short position                              |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::TrailingStopShort(double sl,double tp)
  {
   return(m_trade.PositionModify(m_symbol.Name(),sl,tp));
  }
//+------------------------------------------------------------------+
//| Check for trailing long limit/stop order                         |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckTrailingOrderLong()
  {
   double price;
//--- check the possibility of modifying the long order
   if(m_signal.CheckTrailingOrderLong(GetPointer(m_order),price))
      return(TrailingOrderLong(price));
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for trailing short limit/stop order                        |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckTrailingOrderShort()
  {
   double price;
//--- check the possibility of modifying the short order
   if(m_signal.CheckTrailingOrderShort(GetPointer(m_order),price))
      return(TrailingOrderShort(price));
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Trailing long limit/stop order                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::TrailingOrderLong(double delta)
  {
   ulong  ticket=m_order.Ticket();
   double price =m_order.PriceOpen()-delta;
   double sl    =m_order.StopLoss()-delta;
   double tp    =m_order.TakeProfit()-delta;
//--- modifying the long order
   return(m_trade.OrderModify(ticket,price,sl,tp,m_order.TypeTime(),m_order.TimeExpiration()));
  }
//+------------------------------------------------------------------+
//| Trailing short limit/stop order                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::TrailingOrderShort(double delta)
  {
   ulong  ticket=m_order.Ticket();
   double price =m_order.PriceOpen()-delta;
   double sl    =m_order.StopLoss()-delta;
   double tp    =m_order.TakeProfit()-delta;
//--- modifying the short order
   return(m_trade.OrderModify(ticket,price,sl,tp,m_order.TypeTime(),m_order.TimeExpiration()));
  }
//+------------------------------------------------------------------+
//| Check for delete long limit/stop order                           |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckDeleteOrderLong()
  {
   double price;
//--- check the possibility of deleting the long order
   if(m_expiration!=0 && TimeCurrent()>m_expiration)
     {
      m_expiration=0;
      return(DeleteOrderLong());
     }
   if(m_signal.CheckCloseLong(price))
      return(DeleteOrderLong());
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for delete short limit/stop order                          |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation processed, false otherwise.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckDeleteOrderShort()
  {
   double price;
//--- check the possibility of deleting the short order
   if(m_expiration!=0 && TimeCurrent()>m_expiration)
     {
      m_expiration=0;
      return(DeleteOrderShort());
     }
   if(m_signal.CheckCloseShort(price))
      return(DeleteOrderShort());
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Delete all limit/stop orders                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::DeleteOrders()
  {
   bool result=false;
   int  total=OrdersTotal();
//---
   for(int i=total-1;i>=0;i--)
     {
      if(m_order.Select(OrderGetTicket(i)))
        {
         if(m_order.Symbol()!=m_symbol.Name()) continue;
         result|=DeleteOrder();
        }
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Delete limit/stop order                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::DeleteOrder()
  {
   return(m_trade.OrderDelete(m_order.Ticket()));
  }
//+------------------------------------------------------------------+
//| Delete long limit/stop order                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::DeleteOrderLong()
  {
   return(m_trade.OrderDelete(m_order.Ticket()));
  }
//+------------------------------------------------------------------+
//| Delete short limit/stop order                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if trade operation successful, false otherwise.     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::DeleteOrderShort()
  {
   return(m_trade.OrderDelete(m_order.Ticket()));
  }
//+------------------------------------------------------------------+
//| Method of getting the lot for open long position.                |
//| INPUT:  no.                                                      |
//| OUTPUT: lot for open.                                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CExpert::LotOpenLong(double price,double sl)
  {
   double lot=m_money.CheckOpenLong(price,sl);
//---
   return(lot);
  }
//+------------------------------------------------------------------+
//| Method of getting the lot for open short position.               |
//| INPUT:  no.                                                      |
//| OUTPUT: lot for open.                                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CExpert::LotOpenShort(double price,double sl)
  {
   double lot=m_money.CheckOpenShort(price,sl);
//---
   return(lot);
  }
//+------------------------------------------------------------------+
//| Method of setting the start date for the history.                |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::PrepareHistoryDate()
  {
   MqlDateTime dts;
//---
   TimeCurrent(dts);
//--- set up a date at the beginning of the month (but not less than one day)
   if(dts.day==1)
     {
      if(dts.mon==1)
        {
         dts.mon=12;
         dts.year--;
        }
      else
         dts.mon--;
     }
   dts.day =1;
   dts.hour=0;
   dts.min =0;
   dts.sec =0;
//---
   m_beg_date=StructToTime(dts);
  }
//+------------------------------------------------------------------+
//| Method of establishing the checkpoint history.                   |
//| INPUT:  from_check_trade-flag to avoid recursive.                |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::HistoryPoint(bool from_check_trade)
  {
//--- check possible recursion
   if(!from_check_trade) CheckTradeState();
//--- select history point
   if(HistorySelect(m_beg_date,TimeCurrent()))
     {
      m_hist_ord_tot=HistoryOrdersTotal();
      m_deal_tot    =HistoryDealsTotal();
     }
   else
     {
      m_hist_ord_tot=0;
      m_deal_tot    =0;
     }
   m_ord_tot=OrdersTotal();
   m_pos_tot=PositionsTotal();
  }
//+------------------------------------------------------------------+
//| Method of verification of trade events.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if the event is handled, false otherwise.           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpert::CheckTradeState()
  {
   bool res=false;
//--- select current history point
   HistorySelect(m_beg_date,INT_MAX);
   int hist_ord_tot=HistoryOrdersTotal();
   int ord_tot     =OrdersTotal();
   int deal_tot    =HistoryDealsTotal();
   int pos_tot     =PositionsTotal();
//--- check for quantitative changes
   if(hist_ord_tot==m_hist_ord_tot && ord_tot==m_ord_tot && deal_tot==m_deal_tot && pos_tot==m_pos_tot)
     {
      //--- no quantitative changes
      if(IsWaitingPositionModify())
        {
         res=TradeEventPositionModify();
         NoWaitEvent(TRADE_EVENT_POSITION_MODIFY);
        }
      if(IsWaitingPositionModify())
        {
         res=TradeEventOrderModify();
         NoWaitEvent(TRADE_EVENT_ORDER_MODIFY);
        }
      return(true);
     }
//--- check added a pending order
   if(hist_ord_tot==m_hist_ord_tot && ord_tot==m_ord_tot+1 && deal_tot==m_deal_tot && pos_tot==m_pos_tot)
     {
      //--- was added a pending order
      res=TradeEventOrderPlace();
      //--- establishment of the checkpoint history of the trade
      HistoryPoint(true);
      return(true);
     }
//--- check make a deal "with the market"
   if(hist_ord_tot==m_hist_ord_tot+1 && ord_tot==m_ord_tot)
     {
      //--- was an attempt to make a deal "with the market"
      if(deal_tot==m_deal_tot+1)
        {
         //--- operation successfull
         //--- check position update/subtracting
         if(pos_tot==m_pos_tot)
           {
            //--- position update/subtracting
            if(IsWaitingPositionAddSub())
              {
               res=TradeEventPositionAddSub();
               NoWaitEvent(TRADE_EVENT_POSITION_ADD);
              }
            //--- establishment of the checkpoint history of the trade
            HistoryPoint(true);
            return(res);
           }
         //--- check position open
         if(pos_tot==m_pos_tot+1)
           {
            //--- position open
            if(IsWaitingPositionOpen())
              {
               res=TradeEventPositionOpen();
               NoWaitEvent(TRADE_EVENT_POSITION_OPEN);
              }
            //--- establishment of the checkpoint history of the trade
            HistoryPoint(true);
            //---
            return(res);
           }
         //--- check position is closed (including the stoploss/takeprofit)
         if(pos_tot==m_pos_tot-1)
           {
            //--- position is closed (including the stoploss/takeprofit)
            if(IsWaitingPositionClose())
              {
               res=TradeEventPositionClose();
               NoWaitEvent(TRADE_EVENT_POSITION_CLOSE);
              }
            else
               res=TradeEventStopTakeTrigger();
            //--- establishment of the checkpoint history of the trade
            HistoryPoint(true);
            //---
            return(res);
           }
        }
      else
        {
         //--- operation failed
         //--- establishment of the checkpoint history of the trade
         HistoryPoint(true);
         return(false);
        }
     }
//--- check delete pending order
   if(hist_ord_tot==m_hist_ord_tot+1 && ord_tot==m_ord_tot-1 && deal_tot==m_deal_tot && pos_tot==m_pos_tot)
     {
      //--- delete pending order
      res=TradeEventOrderDelete();
      //--- establishment of the checkpoint history of the trade
      HistoryPoint(true);
      //---
      return(res);
     }
//--- check triggering of a pending order
   if(hist_ord_tot==m_hist_ord_tot+1 && ord_tot==m_ord_tot-1)
     {
      //--- triggering of a pending order
      if(deal_tot==m_deal_tot+1)
        {
         //--- operation successfull
         //--- check position update/subtracting
         if(pos_tot==m_pos_tot)
           {
            //--- position update/subtracting
            res=TradeEventOrderTrigger();
            //--- establishment of the checkpoint history of the trade
            HistoryPoint(true);
            //---
            return(res);
           }
         //--- check position open
         if(pos_tot==m_pos_tot+1)
           {
            //--- position open
            res=TradeEventOrderTrigger();
            //--- establishment of the checkpoint history of the trade
            HistoryPoint(true);
            //---
            return(res);
           }
         //--- check position is closed
         if(pos_tot==m_pos_tot-1)
           {
            //--- position is closed
            res=TradeEventOrderTrigger();
            //--- establishment of the checkpoint history of the trade
            HistoryPoint(true);
            //---
            return(res);
           }
        }
      else
        {
         //--- operation failed
         //--- establishment of the checkpoint history of the trade
         HistoryPoint(true);
         return(false);
        }
     }
//--- trade event non identifical
   res=TradeEventNotIdentified();
//--- establishment of the checkpoint history of the trade
   HistoryPoint(true);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Add timeframe for checked                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpert::TimeframeAdd(ENUM_TIMEFRAMES period)
  {
   switch(period)
     {
      case PERIOD_M1:  m_period_flags|=OBJ_PERIOD_M1;  break;
      case PERIOD_M2:  m_period_flags|=OBJ_PERIOD_M2;  break;
      case PERIOD_M3:  m_period_flags|=OBJ_PERIOD_M3;  break;
      case PERIOD_M4:  m_period_flags|=OBJ_PERIOD_M4;  break;
      case PERIOD_M5:  m_period_flags|=OBJ_PERIOD_M5;  break;
      case PERIOD_M6:  m_period_flags|=OBJ_PERIOD_M6;  break;
      case PERIOD_M10: m_period_flags|=OBJ_PERIOD_M10; break;
      case PERIOD_M12: m_period_flags|=OBJ_PERIOD_M12; break;
      case PERIOD_M15: m_period_flags|=OBJ_PERIOD_M15; break;
      case PERIOD_M20: m_period_flags|=OBJ_PERIOD_M20; break;
      case PERIOD_M30: m_period_flags|=OBJ_PERIOD_M30; break;
      case PERIOD_H1:  m_period_flags|=OBJ_PERIOD_H1;  break;
      case PERIOD_H2:  m_period_flags|=OBJ_PERIOD_H2;  break;
      case PERIOD_H3:  m_period_flags|=OBJ_PERIOD_H3;  break;
      case PERIOD_H4:  m_period_flags|=OBJ_PERIOD_H4;  break;
      case PERIOD_H6:  m_period_flags|=OBJ_PERIOD_H6;  break;
      case PERIOD_H8:  m_period_flags|=OBJ_PERIOD_H8;  break;
      case PERIOD_H12: m_period_flags|=OBJ_PERIOD_H12; break;
      case PERIOD_D1:  m_period_flags|=OBJ_PERIOD_D1;  break;
      case PERIOD_W1:  m_period_flags|=OBJ_PERIOD_W1;  break;
      case PERIOD_MN1: m_period_flags|=OBJ_PERIOD_MN1; break;
      default:         m_period_flags=OBJ_ALL_PERIODS; break;
     }
  }
//+------------------------------------------------------------------+
//| Forms timeframes flags                                           |
//| INPUT:  time - reference.                                        |
//| OUTPUT: timeframes flags.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CExpert::TimeframesFlags(MqlDateTime &time)
  {
   int   result=OBJ_PERIOD_M1;
//--- check change time
   if(time.min==m_last_tick_time.min && 
      time.hour==m_last_tick_time.hour && 
      time.day==m_last_tick_time.day &&
      time.mon==m_last_tick_time.mon) return(0);
//--- if first check, then setting flags all timeframes
   if(m_last_tick_time.min==-1) result=0x1FFFFF;
//--- new minute
   if(time.min%2==0)       result|=OBJ_PERIOD_M2;
   if(time.min%3==0)       result|=OBJ_PERIOD_M3;
   if(time.min%4==0)       result|=OBJ_PERIOD_M4;
   if(time.min%5==0)       result|=OBJ_PERIOD_M5;
   if(time.min%6==0)       result|=OBJ_PERIOD_M6;
   if(time.min%10==0)      result|=OBJ_PERIOD_M10;
   if(time.min%12==0)      result|=OBJ_PERIOD_M12;
   if(time.min%15==0)      result|=OBJ_PERIOD_M15;
   if(time.min%20==0)      result|=OBJ_PERIOD_M20;
   if(time.min%30==0)      result|=OBJ_PERIOD_M30;
   if(time.min!=0) return(result);
//--- new hour
   result|=OBJ_PERIOD_H1;
   if(time.hour%2==0)      result|=OBJ_PERIOD_H2;
   if(time.hour%3==0)      result|=OBJ_PERIOD_H3;
   if(time.hour%4==0)      result|=OBJ_PERIOD_H4;
   if(time.hour%6==0)      result|=OBJ_PERIOD_H6;
   if(time.hour%8==0)      result|=OBJ_PERIOD_H8;
   if(time.hour%12==0) result|=OBJ_PERIOD_H12;
   if(time.hour!=0) return(result);
//--- new day
   result|=OBJ_PERIOD_D1;
//--- new week
   if(time.day_of_week==1) result|=OBJ_PERIOD_W1;
//--- new month
   if(time.day==1) result|=OBJ_PERIOD_MN1;
//---
   return(result);
  }
//+------------------------------------------------------------------+
