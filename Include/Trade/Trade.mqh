//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//|                                              Revision 2010.02.08 |
//+------------------------------------------------------------------+
#include "SymbolInfo.mqh"
#include "OrderInfo.mqh"
#include "HistoryOrderInfo.mqh"
#include "PositionInfo.mqh"
#include "DealInfo.mqh"
//+------------------------------------------------------------------+
//| Class CTrade.                                                    |
//| Appointment: Class trade operations.                             |
//+------------------------------------------------------------------+
class CTrade
  {
protected:
   MqlTradeRequest   m_request;         // request data
   MqlTradeResult    m_result;          // result data
   MqlTradeCheckResult m_check_result;  // result check data
   ulong             m_magic;           // expert magic number
   ulong             m_deviation;       // deviation default
   ENUM_ORDER_TYPE_FILLING m_type_filling;

public:
                     CTrade();
   //--- methods of access to protected data
   void              Request(MqlTradeRequest &request) const;
   ENUM_TRADE_REQUEST_ACTIONS RequestAction() const        { return(m_request.action);            }
   string            RequestActionDescription() const;
   ulong             RequestMagic() const                  { return(m_request.magic);             }
   ulong             RequestOrder() const                  { return(m_request.order);             }
   string            RequestSymbol() const                 { return(m_request.symbol);            }
   double            RequestVolume() const                 { return(m_request.volume);            }
   double            RequestPrice() const                  { return(m_request.price);             }
   double            RequestStopLimit() const              { return(m_request.stoplimit);         }
   double            RequestSL() const                     { return(m_request.sl);                }
   double            RequestTP() const                     { return(m_request.tp);                }
   ulong             RequestDeviation() const              { return(m_request.deviation);         }
   ENUM_ORDER_TYPE   RequestType() const                   { return(m_request.type);              }
   string            RequestTypeDescription() const;
   ENUM_ORDER_TYPE_FILLING RequestTypeFilling() const      { return(m_request.type_filling);      }
   string            RequestTypeFillingDescription() const;
   ENUM_ORDER_TYPE_TIME RequestTypeTime() const            { return(m_request.type_time);         }
   string            RequestTypeTimeDescription() const;
   datetime          RequestExpiration() const             { return(m_request.expiration);        }
   string            RequestComment() const                { return(m_request.comment);           }
   //---
   void              Result(MqlTradeResult &result) const;
   uint              ResultRetcode() const                 { return(m_result.retcode);            }
   string            ResultRetcodeDescription() const;
   ulong             ResultDeal() const                    { return(m_result.deal);               }
   ulong             ResultOrder() const                   { return(m_result.order);              }
   double            ResultVolume() const                  { return(m_result.volume);             }
   double            ResultPrice() const                   { return(m_result.price);              }
   double            ResultBid() const                     { return(m_result.bid);                }
   double            ResultAsk() const                     { return(m_result.ask);                }
   string            ResultComment() const                 { return(m_result.comment);            }
   //---
   void              CheckResult(MqlTradeCheckResult &check_result) const;
   uint              CheckResultRetcode() const            { return(m_check_result.retcode);      }
   string            CheckResultRetcodeDescription() const;
   double            CheckResultBalance() const            { return(m_check_result.balance);      }
   double            CheckResultEquity() const             { return(m_check_result.equity);       }
   double            CheckResultProfit() const             { return(m_check_result.profit);       }
   double            CheckResultMargin() const             { return(m_check_result.margin);       }
   double            CheckResultMarginFree() const         { return(m_check_result.margin_free);  }
   double            CheckResultMarginLevel() const        { return(m_check_result.margin_level); }
   string            CheckResultComment() const            { return(m_check_result.comment);      }
   //--- trade methods
   void              SetExpertMagicNumber(ulong magic)     { m_magic=magic;                       }
   void              SetDeviationInPoints(ulong deviation) { m_deviation=deviation;               }
   void              SetTypeFilling(ENUM_ORDER_TYPE_FILLING filling) { m_type_filling=filling;    }
   //--- methods for working with positions
   bool              PositionOpen(const string symbol,ENUM_ORDER_TYPE order_type,double volume,
                                  double price,double sl,double tp,const string comment="");
   bool              PositionModify(const string symbol,double sl,double tp);
   bool              PositionClose(const string symbol,ulong deviation=ULONG_MAX);
   //--- methods for working with pending orders
   bool              OrderOpen(const string symbol,ENUM_ORDER_TYPE order_type,double volume,
                               double limit_price,double price,double sl,double tp,
                               ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,
                               const string comment="");
   bool              OrderModify(ulong ticket,double price,double sl,double tp,
                                 ENUM_ORDER_TYPE_TIME type_time,datetime expiration);
   bool              OrderDelete(ulong ticket);
   //--- additions methods
   bool              Buy(double volume,const string symbol=NULL,double price=0.0,double sl=0.0,double tp=0.0,const string comment="");
   bool              Sell(double volume,const string symbol=NULL,double price=0.0,double sl=0.0,double tp=0.0,const string comment="");
   bool              BuyLimit(double volume,double price,const string symbol=NULL,double sl=0.0,double tp=0.0,
                              ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,const string comment="");
   bool              BuyStop(double volume,double price,const string symbol=NULL,double sl=0.0,double tp=0.0,
                             ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,const string comment="");
   bool              SellLimit(double volume,double price,const string symbol=NULL,double sl=0.0,double tp=0.0,
                               ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,const string comment="");
   bool              SellStop(double volume,double price,const string symbol=NULL,double sl=0.0,double tp=0.0,
                              ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,const string comment="");
   //---
   void              PrintRequest() const;
   void              PrintResult() const;
   //--- позиции
   string            FormatPositionType(string &str,const uint type) const;
   string            FormatPosition(string &str,const CPositionInfo *position) const;
   //--- ордера
   string            FormatOrderType(string &str,const uint type) const;
   string            FormatOrderStatus(string &str,const uint status) const;
   string            FormatOrderTypeFilling(string &str,const uint type) const;
   string            FormatOrderTypeTime(string &str,const uint type) const;
   string            FormatOrder(string &str,const COrderInfo *order) const;
   string            FormatOrderPrice(string &str,const double price_order,const double price_trigger,const uint digits) const;
   //--- сделки
   string            FormatDealAction(string &str,const uint action) const;
   string            FormatDealEntry(string &str,const uint entry) const;
   string            FormatDeal(string &str,const CDealInfo *deal) const;
   //--- торговый запрос
   string            FormatRequest(string &str,const MqlTradeRequest &request) const;
   string            FormatRequestResult(string &str,const MqlTradeRequest &request,const MqlTradeResult &result) const;

protected:
   void              ClearStructures();
  };
//+------------------------------------------------------------------+
//| Constructor CTrade.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::CTrade()
  {
//--- initialize protected data
   ClearStructures();
   m_magic       =0;
   m_deviation   =10;
   m_type_filling=ORDER_FILLING_AON;
  }
//+------------------------------------------------------------------+
//| Get the request structure.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::Request(MqlTradeRequest &request) const
  {
   request.action      =m_request.action;
   request.magic       =m_request.magic;
   request.order       =m_request.order;
   request.symbol      =m_request.symbol;
   request.volume      =m_request.volume;
   request.price       =m_request.price;
   request.stoplimit   =m_request.stoplimit;
   request.sl          =m_request.sl;
   request.tp          =m_request.tp;
   request.deviation   =m_request.deviation;
   request.type        =m_request.type;
   request.type_filling=m_request.type_filling;
   request.type_time   =m_request.type_time;
   request.expiration  =m_request.expiration;
   request.comment     =m_request.comment;
  }
//+------------------------------------------------------------------+
//| Get the trade action as string.                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: the trade action as string.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::RequestActionDescription() const
  {
   string str;
//---
   FormatRequest(str,m_request);
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the order type as string.                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: the order type as string.                                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::RequestTypeDescription() const
  {
   string str;
//---
   FormatOrderType(str,(uint)m_request.order);
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the order type filling as string.                            |
//| INPUT:  no.                                                      |
//| OUTPUT: the order type filling as string.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::RequestTypeFillingDescription() const
  {
   string str;
//---
   FormatOrderTypeFilling(str,m_request.type_filling);
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the order type time as string.                               |
//| INPUT:  no.                                                      |
//| OUTPUT: the order type time as string.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::RequestTypeTimeDescription() const
  {
   string str;
//---
   FormatOrderTypeTime(str,m_request.type_time);
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the result structure.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::Result(MqlTradeResult &result) const
  {
   result.retcode=m_result.retcode;
   result.deal   =m_result.deal;
   result.order  =m_result.order;
   result.volume =m_result.volume;
   result.price  =m_result.price;
   result.bid    =m_result.bid;
   result.ask    =m_result.ask;
   result.comment=m_result.comment;
  }
//+------------------------------------------------------------------+
//| Get the retcode value as string.                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: the retcode value as string.                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::ResultRetcodeDescription() const
  {
   string str;
//---
   FormatRequestResult(str,m_request,m_result);
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the check result structure.                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::CheckResult(MqlTradeCheckResult &check_result) const
  {
//--- copy structure
   check_result.retcode     =m_check_result.retcode;
   check_result.balance     =m_check_result.balance;
   check_result.equity      =m_check_result.equity;
   check_result.profit      =m_check_result.profit;
   check_result.margin      =m_check_result.margin;
   check_result.margin_free =m_check_result.margin_free;
   check_result.margin_level=m_check_result.margin_level;
   check_result.comment     =m_check_result.comment;
  }
//+------------------------------------------------------------------+
//| Get the check retcode value as string.                           |
//| INPUT:  no.                                                      |
//| OUTPUT: the retcode value as string.                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::CheckResultRetcodeDescription() const
  {
   string str;
   MqlTradeResult result;
//---
   result.retcode=m_check_result.retcode;
   FormatRequestResult(str,m_request,result);
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Open position.                                                   |
//| INPUT:  symbol     -symbol for trade,                            |
//|         order_type -direct for open,                             |
//|         volume     -volume of position,                          |
//|         price      -price for open,                              |
//|         stop       -price of stop loss,                          |
//|         take       -price of take profit,                        |
//|         comment    -comment of position.                         |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::PositionOpen(const string symbol,ENUM_ORDER_TYPE order_type,double volume,
                          double price,double sl,double tp,const string comment)
  {
   string action,result;
//---
   ClearStructures();
//--- checking
   if(order_type!=ORDER_TYPE_BUY && order_type!=ORDER_TYPE_SELL)
     {
      m_result.retcode=TRADE_RETCODE_INVALID;
      m_result.comment="Invalid order type";
      return(false);
     }
//--- setting request
   m_request.action      =TRADE_ACTION_DEAL;
   m_request.symbol      =symbol;
   m_request.magic       =m_magic;
   m_request.volume      =volume;
   m_request.type        =order_type;
   m_request.price       =price;
   m_request.sl          =sl;
   m_request.tp          =tp;
   m_request.deviation   =m_deviation;
   m_request.type_filling=m_type_filling;
   m_request.comment     =comment;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      m_result.retcode=m_check_result.retcode;
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      //--- copy return code
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Modify specified opened position.                                |
//| INPUT:  symbol -symbol for trade,                                |
//|         stop   -new price of stop loss,                          |
//|         take   -new price of take profit,                        |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::PositionModify(const string symbol,double sl,double tp)
  {
   string action,result;
//---
   ClearStructures();
//--- setting request
   m_request.action=TRADE_ACTION_SLTP;
   m_request.symbol=symbol;
   m_request.sl    =sl;
   m_request.tp    =tp;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      //--- copy return code
      m_result.retcode=m_check_result.retcode;
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Close specified opened position.                                 |
//| INPUT:  symbol    -symbol for trade,                             |
//|         deviation -deviation for price close.                    |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::PositionClose(const string symbol,ulong deviation)
  {
   bool   partial_close=false;
   int    retry_count  =10;
   uint   retcode      =TRADE_RETCODE_REJECT;
   string action,result;
//---
   ClearStructures();
   do
     {
      //--- checking
      if(PositionSelect(symbol))
        {
         if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
            //--- prepare request for close BUY position
            m_request.type =ORDER_TYPE_SELL;
            m_request.price=SymbolInfoDouble(symbol,SYMBOL_BID);
           }
         else
           {
            //--- prepare request for close SELL position
            m_request.type =ORDER_TYPE_BUY;
            m_request.price=SymbolInfoDouble(symbol,SYMBOL_ASK);
           }
        }
      else
        {
         //--- position not found
         m_result.retcode=retcode;
         return(false);
        }
      //--- setting request
      m_request.action      =TRADE_ACTION_DEAL;
      m_request.symbol      =symbol;
      m_request.deviation   =(deviation==ULONG_MAX) ? m_deviation : deviation;
      m_request.type_filling=m_type_filling;
      m_request.volume      =PositionGetDouble(POSITION_VOLUME);
      //--- check volume
      double max_volume=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
      if(m_request.volume>max_volume)
        {
         m_request.volume=max_volume;
         partial_close=true;
        }
      else
         partial_close=false;
      //--- order check
      if(!OrderCheck(m_request,m_check_result))
        {
         //--- copy return code
         m_result.retcode=m_check_result.retcode;
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
         return(false);
        }
      //--- order send
      if(!OrderSend(m_request,m_result))
        {
         if(--retry_count!=0) continue;
         if(retcode==TRADE_RETCODE_DONE_PARTIAL)
            m_result.retcode=retcode;
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
         return(false);
        }
      retcode=TRADE_RETCODE_DONE_PARTIAL;
      if(partial_close) Sleep(1000);
     }
   while(partial_close);
   printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Installation pending order.                                      |
//| INPUT:  symbol     -symbol for trade,                            |
//|         order_type -type of order,                               |
//|         volume     -volume of order,                             |
//|         limit_price-limit price for activate order,              |
//|         price      -price for open,                              |
//|         sl         -price of stop loss,                          |
//|         tp         -price of take profit,                        |
//|         type_time  -type expiration,                             |
//|         expiration -time expiration,                             |
//|         comment    -comment of order.                            |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::OrderOpen(const string symbol,ENUM_ORDER_TYPE order_type,double volume,double limit_price,
                       double price,double sl,double tp,
                       ENUM_ORDER_TYPE_TIME type_time,datetime expiration,const string comment)
  {
   string action,result;
//---
   ClearStructures();
//--- checking
   if(order_type==ORDER_TYPE_BUY || order_type==ORDER_TYPE_SELL)
     {
      m_result.retcode=TRADE_RETCODE_INVALID;
      m_result.comment="Invalid order type";
      return(false);
     }
//--- setting request
   m_request.action      =TRADE_ACTION_PENDING;
   m_request.symbol      =symbol;
   m_request.magic       =m_magic;
   m_request.volume      =volume;
   m_request.type        =order_type;
   m_request.stoplimit   =limit_price;
   m_request.price       =price;
   m_request.sl          =sl;
   m_request.tp          =tp;
   m_request.type_filling=m_type_filling;
   m_request.type_time   =type_time;
   m_request.expiration  =expiration;
   m_request.comment     =comment;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      //--- copy return code
      m_result.retcode=m_check_result.retcode;
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Modify specified pending order.                                  |
//| INPUT:  ticket     -ticket for modify,                           |
//|         price      -new price for open,                          |
//|         sl         -new price of stop loss,                      |
//|         tp         -new price of take profit,                    |
//|         type_time  -new type expiration,                         |
//|         expiration -new time expiration.                         |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::OrderModify(ulong ticket,double price,double sl,double tp,ENUM_ORDER_TYPE_TIME type_time,datetime expiration)
  {
   string action,result;
//---
   ClearStructures();
//--- setting request
   m_request.action      =TRADE_ACTION_MODIFY;
   m_request.order       =ticket;
   m_request.price       =price;
   m_request.sl          =sl;
   m_request.tp          =tp;
   m_request.type_time   =type_time;
   m_request.expiration  =expiration;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      //--- copy return code
      m_result.retcode=m_check_result.retcode;
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete specified pending order.                                  |
//| INPUT:  ticket -ticket of order for delete.                      |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::OrderDelete(ulong ticket)
  {
   string action,result;
//---
   ClearStructures();
//--- setting request
   m_request.action    =TRADE_ACTION_REMOVE;
   m_request.order     =ticket;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      //--- copy return code
      m_result.retcode=m_check_result.retcode;
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Output full information of request to log.                       |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::PrintRequest() const
  {
   string str;
   printf("%s",FormatRequest(str,m_request));
  }
//+------------------------------------------------------------------+
//| Output full information of result to log.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::PrintResult(void) const
  {
   string str;
   printf("%s",FormatRequestResult(str,m_request,m_result));
  }
//+------------------------------------------------------------------+
//| Clear structures m_request,m_result and m_check_result.          |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::ClearStructures()
  {
   ZeroMemory(m_request);
   ZeroMemory(m_result);
   ZeroMemory(m_check_result);
  }
//+------------------------------------------------------------------+
//| Buy operation.                                                   |
//| INPUT:  volume  - volume of position,                            |
//|         symbol  - symbol for trade,                              |
//|         price   - price for open,                                |
//|         sl      - price of stop loss,                            |
//|         tp      - price of take profit,                          |
//|         comment - comment of position.                           |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::Buy(double volume,const string symbol=NULL,double price=0.0,double sl=0.0,double tp=0.0,const string comment="")
  {
   CSymbolInfo sym;
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price==0.0)
     {
      sym.Name((symbol==NULL)?Symbol():symbol);
      sym.RefreshRates();
      price=sym.Ask();
     }
//---
   return(PositionOpen(sym.Name(),ORDER_TYPE_BUY,volume,price,sl,tp,comment));
  }
//+------------------------------------------------------------------+
//| Sell operation.                                                  |
//| INPUT:  volume  - volume of position,                            |
//|         symbol  - symbol for trade,                              |
//|         price   - price for open,                                |
//|         sl      - price of stop loss,                            |
//|         tp      - price of take profit,                          |
//|         comment - comment of position.                           |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::Sell(double volume,const string symbol=NULL,double price=0.0,double sl=0.0,double tp=0.0,const string comment="")
  {
   CSymbolInfo sym;
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price==0.0)
     {
      sym.Name((symbol==NULL)?Symbol():symbol);
      sym.RefreshRates();
      price=sym.Bid();
     }
//---
   return(PositionOpen(sym.Name(),ORDER_TYPE_SELL,volume,price,sl,tp,comment));
  }
//+------------------------------------------------------------------+
//| Send BUY_LIMIT order.                                            |
//| INPUT:  volume     -volume of order,                             |
//|         price      -price for open,                              |
//|         symbol     -symbol for trade,                            |
//|         sl         -price of stop loss,                          |
//|         tp         -price of take profit,                        |
//|         type_time  -type expiration,                             |
//|         expiration -time expiration,                             |
//|         comment    -comment of order.                            |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::BuyLimit(double volume,double price,const string symbol=NULL,double sl=0.0,double tp=0.0,
                      ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,const string comment="")
  {
   string sym;
//--- check symbol
   sym=(symbol==NULL)?Symbol():symbol;
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price!=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_PRICE;
      return(false);
     }
//--- send "BUY_LIMIT" order
   return(OrderOpen(symbol,ORDER_TYPE_BUY_LIMIT,volume,0.0,price,sl,tp,type_time,expiration,comment));
  }
//+------------------------------------------------------------------+
//| Send BUY_STOP order.                                             |
//| INPUT:  volume     -volume of order,                             |
//|         price      -price for open,                              |
//|         symbol     -symbol for trade,                            |
//|         sl         -price of stop loss,                          |
//|         tp         -price of take profit,                        |
//|         type_time  -type expiration,                             |
//|         expiration -time expiration,                             |
//|         comment    -comment of order.                            |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::BuyStop(double volume,double price,const string symbol=NULL,double sl=0.0,double tp=0.0,
                     ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,const string comment="")
  {
   string sym;
//--- check symbol
   sym=(symbol==NULL)?Symbol():symbol;
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price!=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_PRICE;
      return(false);
     }
//--- send "BUY_STOP" order
   return(OrderOpen(symbol,ORDER_TYPE_BUY_STOP,volume,0.0,price,sl,tp,type_time,expiration,comment));
  }
//+------------------------------------------------------------------+
//| Send SELL_LIMIT order.                                           |
//| INPUT:  volume     -volume of order,                             |
//|         price      -price for open,                              |
//|         symbol     -symbol for trade,                            |
//|         sl         -price of stop loss,                          |
//|         tp         -price of take profit,                        |
//|         type_time  -type expiration,                             |
//|         expiration -time expiration,                             |
//|         comment    -comment of order.                            |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::SellLimit(double volume,double price,const string symbol=NULL,double sl=0.0,double tp=0.0,
                       ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,const string comment="")
  {
   string sym;
//--- check symbol
   sym=(symbol==NULL)?Symbol():symbol;
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price!=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_PRICE;
      return(false);
     }
//--- send "SELL_LIMIT" order
   return(OrderOpen(symbol,ORDER_TYPE_SELL_LIMIT,volume,0.0,price,sl,tp,type_time,expiration,comment));
  }
//+------------------------------------------------------------------+
//| Send SELL_STOP order.                                            |
//| INPUT:  volume     -volume of order,                             |
//|         price      -price for open,                              |
//|         symbol     -symbol for trade,                            |
//|         sl         -price of stop loss,                          |
//|         tp         -price of take profit,                        |
//|         type_time  -type expiration,                             |
//|         expiration -time expiration,                             |
//|         comment    -comment of order.                            |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::SellStop(double volume,double price,const string symbol=NULL,double sl=0.0,double tp=0.0,
                      ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,datetime expiration=0,const string comment="")
  {
   string sym;
//--- check symbol
   sym=(symbol==NULL)?Symbol():symbol;
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price!=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_PRICE;
      return(false);
     }
//--- send "SELL_STOP" order
   return(OrderOpen(sym,ORDER_TYPE_SELL_STOP,volume,0.0,price,sl,tp,type_time,expiration,comment));
  }
//+------------------------------------------------------------------+
//| позиции                                                          |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид тип позиции.                         |
//| INPUT:  str  - строка-приёмник,                                  |
//|         type - тип позиции.                                      |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatPositionType(string &str,const uint type) const
  {
//--- чистим
   str="";
//--- смотрим тип
   switch(type)
     {
      case POSITION_TYPE_BUY : str="buy";  break;
      case POSITION_TYPE_SELL: str="sell"; break;

      default:
         str="unknown position type "+(string)type;
         break;
     }
//--- вернем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид параметры позиции.                   |
//| INPUT:  str      - строка-приёмник,                              |
//|         position - указатель на экземпляр класса.                |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatPosition(string &str,const CPositionInfo *position) const
  {
   string tmp,type,volume,price;
   CSymbolInfo symbol;
//--- проверяем
   if(position==NULL) return("NULL pointer");
//--- настраиваем
   symbol.Name(position.Symbol());
   int digits=symbol.Digits();
//--- формируем описание позиции
   str=StringFormat("%s %s %s %s",
                    FormatPositionType(type,position.Type()),
                    DoubleToString(position.Volume(),2),
                    position.Symbol(),
                    DoubleToString(position.PriceOpen(),digits+3));
//--- добавляем стопы если есть
   double sl=position.StopLoss();
   double tp=position.TakeProfit();
   if(sl) { tmp=StringFormat(" sl: %s",DoubleToString(sl,digits)); str+=tmp; }
   if(tp) { tmp=StringFormat(" tp: %s",DoubleToString(tp,digits)); str+=tmp; }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| ордера                                                           |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид тип ордера.                          |
//| INPUT:  str  - строка-приёмник,                                  |
//|         type - тип ордера.                                       |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderType(string &str,const uint type) const
  {
//--- чистим
   str="";
//--- смотрим тип
   switch(type)
     {
      case ORDER_TYPE_BUY            : str="buy";             break;
      case ORDER_TYPE_SELL           : str="sell";            break;
      case ORDER_TYPE_BUY_LIMIT      : str="buy limit";       break;
      case ORDER_TYPE_SELL_LIMIT     : str="sell limit";      break;
      case ORDER_TYPE_BUY_STOP       : str="buy stop";        break;
      case ORDER_TYPE_SELL_STOP      : str="sell stop";       break;
      case ORDER_TYPE_BUY_STOP_LIMIT : str="buy stop limit";  break;
      case ORDER_TYPE_SELL_STOP_LIMIT: str="sell stop limit"; break;

      default:
         str="unknown order type "+(string)type;
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид статус ордера.                       |
//| INPUT:  str    - строка-приёмник,                                |
//|         status - статус ордера.                                  |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderStatus(string &str,const uint status) const
  {
//--- чистим
   str="";
//--- смотрим тип
   switch(status)
     {
      case ORDER_STATE_STARTED : str="started";  break;
      case ORDER_STATE_PLACED  : str="placed";   break;
      case ORDER_STATE_CANCELED: str="canceled"; break;
      case ORDER_STATE_PARTIAL : str="partial";  break;
      case ORDER_STATE_FILLED  : str="filled";   break;
      case ORDER_STATE_REJECTED: str="rejected"; break;
      case ORDER_STATE_EXPIRED : str="expired";  break;

      default:
         str="unknown order status "+(string)status;
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид тип ордера по заполнению.            |
//| INPUT:  str  - строка-приёмник,                                  |
//|         type - тип ордера по заполнению.                         |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderTypeFilling(string &str,const uint type) const
  {
//--- чистим
   str="";
//--- смотрим тип
   switch(type)
     {
      case ORDER_FILLING_RETURN: str="return remainder"; break;
      case ORDER_FILLING_CANCEL: str="cancel remainder"; break;
      case ORDER_FILLING_AON   : str="all or none";      break;

      default:
         str="unknown type filling "+(string)type;
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид тип ордера по сроку действия.        |
//| INPUT:  str  - строка-приёмник,                                  |
//|         type - тип ордера по сроку действия.                     |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderTypeTime(string &str,const uint type) const
  {
//--- чистим
   str="";
//--- смотрим тип
   switch(type)
     {
      case ORDER_TIME_GTC      : str="gtc";       break;
      case ORDER_TIME_DAY      : str="day";       break;
      case ORDER_TIME_SPECIFIED: str="specified"; break;

      default:
         str="unknown type time "+(string)type;
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид параметры ордера.                    |
//| INPUT:  str      - строка-приёмник,                              |
//|         position - указатель на экземпляр класса.                |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrder(string &str,const COrderInfo *order) const
  {
   string type,volume,price;
   CSymbolInfo symbol;
//--- проверяем
   if(order==NULL) return("NULL pointer");
//--- настраиваем
   symbol.Name(order.Symbol());
   int digits=symbol.Digits();
//--- формируем описание ордера
   StringFormat("#%I64u %s %s %s",
                order.Ticket(),
                FormatOrderType(type,order.Type()),
                DoubleToString(order.VolumeInitial(),2),
                order.Symbol());
//--- получим цену ордера
   FormatOrderPrice(price,order.PriceOpen(),order.PriceStopLimit(),digits);
//--- если цена есть то допишем ее
   if(price!="")
     {
      str+=" at ";
      str+=price;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид цены ордера.                         |
//| INPUT:  str           - строка-приёмник,                         |
//|         price_order   - цена ордера,                             |
//|         price_trigger - триггерная цена ордера.                  |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderPrice(string &str,const double price_order,const double price_trigger,const uint digits) const
  {
   string price,trigger;
//--- чистим
   str="";
//--- есть триггерная цена?
   if(price_trigger)
     {
      price  =DoubleToString(price_order,digits);
      trigger=DoubleToString(price_trigger,digits);
      str    =StringFormat("%s (%s)",price,trigger);
     }
   else str=DoubleToString(price_order,digits);
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| сделки                                                           |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид тип сделки.                          |
//| INPUT:  str    - строка-приёмник,                                |
//|         action - тип сделки.                                     |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatDealAction(string &str,const uint action) const
  {
//--- чистим
   str="";
//--- смотрим тип  
   switch(action)
     {
      case DEAL_TYPE_BUY       : str="buy";        break;
      case DEAL_TYPE_SELL      : str="sell";       break;
      case DEAL_TYPE_BALANCE   : str="balance";    break;
      case DEAL_TYPE_CREDIT    : str="credit";     break;
      case DEAL_TYPE_CHARGE    : str="charge";     break;
      case DEAL_TYPE_CORRECTION: str="correction"; break;

      default:
         str="unknown deal type "+(string)action;
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид направление сделки.                  |
//| INPUT:  str   - строка-приёмник,                                 |
//|         entry - направление сделки.                              |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatDealEntry(string &str,const uint entry) const
  {
//--- чистим
   str="";
//--- смотрим тип    
   switch(entry)
     {
      case DEAL_ENTRY_IN   : str="in";     break;
      case DEAL_ENTRY_OUT  : str="out";    break;
      case DEAL_ENTRY_INOUT: str="in/out"; break;

      default:
         str="unknown deal entry "+(string)entry;
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид параметры сделки.                    |
//| INPUT:  str  - строка-приёмник,                                  |
//|         deal - указатель на экземпляр класса.                    |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatDeal(string &str,const CDealInfo *deal) const
  {
   string type,volume,price,date;
   CSymbolInfo symbol;
//--- проверяем
   if(deal==NULL) return("NULL pointer");
//--- настраиваем
   symbol.Name(deal.Symbol());
   int digits=symbol.Digits();
//--- формируем описание сделки
   switch(deal.Type())
     {
      //--- купля-продажа
      case DEAL_TYPE_BUY       :
      case DEAL_TYPE_SELL      :
         str=StringFormat("#%I64u %s %s %s at %s",
                          deal.Ticket(),
                          FormatDealAction(type,deal.Type()),
                          DoubleToString(deal.Volume(),2),
                          deal.Symbol(),
                          DoubleToString(deal.Price(),digits));
      break;

      //--- балансовые операции
      case DEAL_TYPE_BALANCE   :
      case DEAL_TYPE_CREDIT    :
      case DEAL_TYPE_CHARGE    :
      case DEAL_TYPE_CORRECTION:
         str=StringFormat("#%I64u %s %s [%s]",
                          deal.Ticket(),
                          FormatDealAction(type,deal.Type()),
                          //            DoubleToString(deal.Profit(),deal.digits_currency),
                          DoubleToString(deal.Profit(),2),
                          deal.Comment());
      break;

      default:
         str="unknown deal type "+(string)deal.Type();
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| торговый запрос                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид параметры запроса.                   |
//| INPUT:  str     - строка-приёмник,                               |
//|         request - ссылка на структуру запроса.                   |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatRequest(string &str,const MqlTradeRequest &request) const
  {
   string      type,volume,volume_new,price,sl,tp,price_new,sl_new,tp_new;
   string      tmp;
   CSymbolInfo symbol;
//--- чистим
   str="";
//--- настраиваем
   symbol.Name(request.symbol);
   int digits=symbol.Digits();
//--- смотрим чего хотят
   switch(request.action)
     {
      //--- немедленное совершение сделки
      case TRADE_ACTION_DEAL:
         switch(symbol.TradeExecution())
           {
            //--- по запросу
            case SYMBOL_TRADE_EXECUTION_REQUEST:
               str=StringFormat("request %s %s %s at %s",
                                FormatOrderType(type,request.type),
                                DoubleToString(request.volume,2),
                                request.symbol,
                                DoubleToString(request.price,digits));
            //--- есть SL или TP?
            if(request.sl) { tmp=StringFormat(" sl: %s",DoubleToString(request.sl,digits)); str+=tmp; }
            if(request.tp) { tmp=StringFormat(" tp: %s",DoubleToString(request.tp,digits)); str+=tmp; }
            break;
            //--- по инстанту
            case SYMBOL_TRADE_EXECUTION_INSTANT:
               str=StringFormat("instant %s %s %s at %s",
                                FormatOrderType(type,request.type),
                                DoubleToString(request.volume,2),
                                request.symbol,
                                DoubleToString(request.price,digits));
            //--- есть SL или TP?
            if(request.sl) { tmp=StringFormat(" sl: %s",DoubleToString(request.sl,digits)); str+=tmp; }
            if(request.tp) { tmp=StringFormat(" tp: %s",DoubleToString(request.tp,digits)); str+=tmp; }
            break;
            //--- по рынку
            case SYMBOL_TRADE_EXECUTION_MARKET:
               str=StringFormat("market %s %s %s",
                                FormatOrderType(type,request.type),
                                DoubleToString(request.volume,2),
                                request.symbol);
            //--- есть SL или TP?
            if(request.sl) { tmp=StringFormat(" sl: %s",DoubleToString(request.sl,digits)); str+=tmp; }
            if(request.tp) { tmp=StringFormat(" tp: %s",DoubleToString(request.tp,digits)); str+=tmp; }
            break;
           }
         break;
         //--- выставление отложенного ордера
      case TRADE_ACTION_PENDING:
         str=StringFormat("%s %s %s at %s",
                          FormatOrderType(type,request.type),
                          DoubleToString(request.volume,2),
                          request.symbol,
                          FormatOrderPrice(price,request.price,request.stoplimit,digits));
      //--- есть SL или TP?
      if(request.sl) { tmp=StringFormat(" sl: %s",DoubleToString(request.sl,digits)); str+=tmp; }
      if(request.tp) { tmp=StringFormat(" tp: %s",DoubleToString(request.tp,digits)); str+=tmp; }
      break;

      //--- выставление SL/TP
      case TRADE_ACTION_SLTP:
         str=StringFormat("modify %s %s %s (sl: %s, tp: %s)",
                          FormatOrderType(type,request.type),
                          DoubleToString(request.volume,2),
                          request.symbol,
                          DoubleToString(request.sl,digits),
                          DoubleToString(request.tp,digits));
      break;

      //--- модифицирование отложенного ордера
      case TRADE_ACTION_MODIFY:
         str=StringFormat("modify #%I64u %s %s %s at %s (sl: %s tp: %s)",
                          request.order,
                          FormatOrderType(type,request.type),
                          DoubleToString(request.volume,2),
                          request.symbol,
                          FormatOrderPrice(price_new,request.price,request.stoplimit,digits),
                          DoubleToString(request.sl,digits),
                          DoubleToString(request.tp,digits));
      break;

      //--- удаление отложенного ордера
      case TRADE_ACTION_REMOVE:
         str=StringFormat("cancel #%I64u %s %s %s at %s",
                          request.order,
                          FormatOrderType(type,request.type),
                          DoubleToString(request.volume,2),
                          request.symbol,
                          FormatOrderPrice(price_new,request.price,request.stoplimit,digits));
      break;

      default:
         str="unknown action "+(string)request.action;
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
//| Преобразует в текстовый вид результат запроса.                   |
//| INPUT:  str     - строка-приёмник,                               |
//|         request - ссылка на структуру запроса,                   |
//|         result  - ссылка на структуру результата запроса.        |
//| OUTPUT: форматированная строка.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatRequestResult(string &str,const MqlTradeRequest &request,const MqlTradeResult &result) const
  {
   string      bid,ask;
   CSymbolInfo symbol;
//--- чистим
   str="";
//--- настраиваем
   symbol.Name(request.symbol);
   int digits=symbol.Digits();
//--- смотрим код ответа
   switch(result.retcode)
     {
      case TRADE_RETCODE_REQUOTE:
         str=StringFormat("requote (%s/%s)",
                          DoubleToString(result.bid,digits),
                          DoubleToString(result.ask,digits));
      break;

      case TRADE_RETCODE_DONE:
         if(symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_REQUEST ||
            symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_INSTANT ||
            symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_MARKET)
            str=StringFormat("done at %s",DoubleToString(result.price,digits));
      else
         str="done";
      break;

      case TRADE_RETCODE_DONE_PARTIAL:
         if(symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_REQUEST ||
            symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_INSTANT ||
            symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_MARKET)
            str=StringFormat("done partially %s at %s",
                             DoubleToString(result.volume,2),
                             DoubleToString(result.price,digits));
      else
         str=StringFormat("done partially %s",
                          DoubleToString(result.volume,2));
      break;

      case TRADE_RETCODE_REJECT            : str="rejected";           break;
      case TRADE_RETCODE_CANCEL            : str="canceled";           break;
      case TRADE_RETCODE_PLACED            : str="placed";             break;
      case TRADE_RETCODE_ERROR             : str="common error";       break;
      case TRADE_RETCODE_TIMEOUT           : str="timeout";            break;
      case TRADE_RETCODE_INVALID           : str="invalid request";    break;
      case TRADE_RETCODE_INVALID_VOLUME    : str="invalid volume";     break;
      case TRADE_RETCODE_INVALID_PRICE     : str="invalid price";      break;
      case TRADE_RETCODE_INVALID_STOPS     : str="invalid stops";      break;
      case TRADE_RETCODE_TRADE_DISABLED    : str="trade disabled";     break;
      case TRADE_RETCODE_MARKET_CLOSED     : str="market closed";      break;
      case TRADE_RETCODE_NO_MONEY          : str="not enough money";   break;
      case TRADE_RETCODE_PRICE_CHANGED     : str="price changed";      break;
      case TRADE_RETCODE_PRICE_OFF         : str="off quotes";         break;
      case TRADE_RETCODE_INVALID_EXPIRATION: str="invalid expiration"; break;
      case TRADE_RETCODE_ORDER_CHANGED     : str="order changed";      break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS : str="too many requests";  break;
      case TRADE_RETCODE_NO_CHANGES        : str="no changes";         break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: str="server disabled";    break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: str="client disabled";    break;
      case TRADE_RETCODE_LOCKED            : str="locked";             break;
      case TRADE_RETCODE_FROZEN            : str="frozen";             break;
      case TRADE_RETCODE_INVALID_FILL      : str="invalid fill";       break;
      case TRADE_RETCODE_CONNECTION        : str="no connection";      break;
      case TRADE_RETCODE_ONLY_REAL         : str="only real";          break;
      case TRADE_RETCODE_LIMIT_ORDERS      : str="limit orders";       break;
      case TRADE_RETCODE_LIMIT_VOLUME      : str="limit volume";       break;

      default:
         str="unknown retcode "+(string)result.retcode;
         break;
     }
//--- отдаем результат
   return(str);
  }
//+------------------------------------------------------------------+
