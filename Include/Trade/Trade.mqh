//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//|                                              Revision 2010.02.08 |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include "SymbolInfo.mqh"
#include "OrderInfo.mqh"
#include "HistoryOrderInfo.mqh"
#include "PositionInfo.mqh"
#include "DealInfo.mqh"
//+------------------------------------------------------------------+
//| enumerations                                                     |
//+------------------------------------------------------------------+
enum ENUM_LOG_LEVELS
  {
   LOG_LEVEL_NO    =0,
   LOG_LEVEL_ERRORS=1,
   LOG_LEVEL_ALL   =2
  };
//+------------------------------------------------------------------+
//| Class CTrade.                                                    |
//| Appointment: Class trade operations.                             |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CTrade : public CObject
  {
protected:
   MqlTradeRequest   m_request;         // request data
   MqlTradeResult    m_result;          // result data
   MqlTradeCheckResult m_check_result;  // result check data
   ulong             m_magic;           // expert magic number
   ulong             m_deviation;       // deviation default
   ENUM_ORDER_TYPE_FILLING m_type_filling;
   //---
   ENUM_LOG_LEVELS   m_log_level;

public:
                     CTrade();
   //--- methods of access to protected data
   void              LogLevel(ENUM_LOG_LEVELS log_level)     { m_log_level=log_level;               }
   void              Request(MqlTradeRequest &request) const;
   ENUM_TRADE_REQUEST_ACTIONS RequestAction()          const { return(m_request.action);            }
   string            RequestActionDescription()        const;
   ulong             RequestMagic()                    const { return(m_request.magic);             }
   ulong             RequestOrder()                    const { return(m_request.order);             }
   string            RequestSymbol()                   const { return(m_request.symbol);            }
   double            RequestVolume()                   const { return(m_request.volume);            }
   double            RequestPrice()                    const { return(m_request.price);             }
   double            RequestStopLimit()                const { return(m_request.stoplimit);         }
   double            RequestSL()                       const { return(m_request.sl);                }
   double            RequestTP()                       const { return(m_request.tp);                }
   ulong             RequestDeviation()                const { return(m_request.deviation);         }
   ENUM_ORDER_TYPE   RequestType()                     const { return(m_request.type);              }
   string            RequestTypeDescription()          const;
   ENUM_ORDER_TYPE_FILLING RequestTypeFilling()        const { return(m_request.type_filling);      }
   string            RequestTypeFillingDescription()   const;
   ENUM_ORDER_TYPE_TIME RequestTypeTime()              const { return(m_request.type_time);         }
   string            RequestTypeTimeDescription()      const;
   datetime          RequestExpiration()               const { return(m_request.expiration);        }
   string            RequestComment()                  const { return(m_request.comment);           }
   //---
   void              Result(MqlTradeResult &result)    const;
   uint              ResultRetcode()                   const { return(m_result.retcode);            }
   string            ResultRetcodeDescription()        const;
   ulong             ResultDeal()                      const { return(m_result.deal);               }
   ulong             ResultOrder()                     const { return(m_result.order);              }
   double            ResultVolume()                    const { return(m_result.volume);             }
   double            ResultPrice()                     const { return(m_result.price);              }
   double            ResultBid()                       const { return(m_result.bid);                }
   double            ResultAsk()                       const { return(m_result.ask);                }
   string            ResultComment()                   const { return(m_result.comment);            }
   //---
   void              CheckResult(MqlTradeCheckResult &check_result) const;
   uint              CheckResultRetcode()              const { return(m_check_result.retcode);      }
   string            CheckResultRetcodeDescription()   const;
   double            CheckResultBalance()              const { return(m_check_result.balance);      }
   double            CheckResultEquity()               const { return(m_check_result.equity);       }
   double            CheckResultProfit()               const { return(m_check_result.profit);       }
   double            CheckResultMargin()               const { return(m_check_result.margin);       }
   double            CheckResultMarginFree()           const { return(m_check_result.margin_free);  }
   double            CheckResultMarginLevel()          const { return(m_check_result.margin_level); }
   string            CheckResultComment()              const { return(m_check_result.comment);      }
   //--- trade methods
   void              SetExpertMagicNumber(ulong magic)       { m_magic=magic;                       }
   void              SetDeviationInPoints(ulong deviation)   { m_deviation=deviation;               }
   void              SetTypeFilling(ENUM_ORDER_TYPE_FILLING filling) { m_type_filling=filling;      }
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
   //--- info methods
   void              PrintRequest() const;
   void              PrintResult()  const;
   //--- positions
   string            FormatPositionType(string& str,const uint type)           const;
   //--- orders
   string            FormatOrderType(string& str,const uint type)              const;
   string            FormatOrderStatus(string& str,const uint status)          const;
   string            FormatOrderTypeFilling(string& str,const uint type)       const;
   string            FormatOrderTypeTime(string& str,const uint type)          const;
   string            FormatOrderPrice(string& str,const double price_order,const double price_trigger,const uint digits) const;
   //--- trade request
   string            FormatRequest(string& str,const MqlTradeRequest& request) const;
   string            FormatRequestResult(string& str,const MqlTradeRequest& request,const MqlTradeResult& result) const;

protected:
   void              ClearStructures();
   bool              IsStopped(string function);
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
   m_log_level   =LOG_LEVEL_ERRORS;
//--- check programm mode
   if(MQL5InfoInteger(MQL5_OPTIMIZATION)) m_log_level=LOG_LEVEL_NO;
   if(MQL5InfoInteger(MQL5_TESTING))      m_log_level=LOG_LEVEL_ALL;
  }
//+------------------------------------------------------------------+
//| Get the request structure.                                       |
//| INPUT:  request - reference.                                     |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::Request(MqlTradeRequest& request) const
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
//| INPUT:  result - refernce.                                       |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::Result(MqlTradeResult& result) const
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
//| INPUT:  check_result - reference.                                |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::CheckResult(MqlTradeCheckResult& check_result) const
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
//--- check stopped
   if(IsStopped(__FUNCTION__)) return(false);
//--- clean
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
//--- variables
   string action,result;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      m_result.retcode=m_check_result.retcode;
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      //--- copy return code
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   if(m_log_level>LOG_LEVEL_ERRORS)
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
//--- check stopped
   if(IsStopped(__FUNCTION__)) return(false);
//--- clean
   ClearStructures();
//--- setting request
   m_request.action=TRADE_ACTION_SLTP;
   m_request.symbol=symbol;
   m_request.sl    =sl;
   m_request.tp    =tp;
//--- variables
   string action,result;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      //--- copy return code
      m_result.retcode=m_check_result.retcode;
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   if(m_log_level>LOG_LEVEL_ERRORS)
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
//--- check stopped
   if(IsStopped(__FUNCTION__)) return(false);
//--- variables
   string action,result;
//--- clean
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
         if(m_log_level>LOG_LEVEL_NO)
            printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
         return(false);
        }
      //--- order send
      if(!OrderSend(m_request,m_result))
        {
         if(--retry_count!=0) continue;
         if(retcode==TRADE_RETCODE_DONE_PARTIAL)
            m_result.retcode=retcode;
         if(m_log_level>LOG_LEVEL_NO)
            printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
         return(false);
        }
      retcode=TRADE_RETCODE_DONE_PARTIAL;
      if(partial_close) Sleep(1000);
     }
   while(partial_close);
   if(m_log_level>LOG_LEVEL_ERRORS)
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
//--- check stopped
   if(IsStopped(__FUNCTION__)) return(false);
//--- clean
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
//--- variables
   string action,result;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      //--- copy return code
      m_result.retcode=m_check_result.retcode;
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   if(m_log_level>LOG_LEVEL_ERRORS)
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
//--- check stopped
   if(IsStopped(__FUNCTION__)) return(false);
//--- clean
   ClearStructures();
//--- setting request
   m_request.action      =TRADE_ACTION_MODIFY;
   m_request.order       =ticket;
   m_request.price       =price;
   m_request.sl          =sl;
   m_request.tp          =tp;
   m_request.type_time   =type_time;
   m_request.expiration  =expiration;
//--- variables
   string action,result;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      //--- copy return code
      m_result.retcode=m_check_result.retcode;
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   if(m_log_level>LOG_LEVEL_ERRORS)
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete specified pending order.                                  |
//| INPUT:  ticket - ticket of order for delete.                     |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::OrderDelete(ulong ticket)
  {
//--- variables
   string action,result;
//--- check stopped
   if(IsStopped(__FUNCTION__)) return(false);
//--- clean
   ClearStructures();
//--- setting request
   m_request.action    =TRADE_ACTION_REMOVE;
   m_request.order     =ticket;
//--- order check
   if(!OrderCheck(m_request,m_check_result))
     {
      //--- copy return code
      m_result.retcode=m_check_result.retcode;
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
//--- order send
   if(!OrderSend(m_request,m_result))
     {
      if(m_log_level>LOG_LEVEL_NO)
         printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
      return(false);
     }
   if(m_log_level>LOG_LEVEL_ERRORS)
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
   if(m_log_level<LOG_LEVEL_ALL) return;
//---
   string str;
   printf("%s",FormatRequest(str,m_request));
  }
//+------------------------------------------------------------------+
//| Output full information of result to log.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrade::PrintResult() const
  {
   if(m_log_level<LOG_LEVEL_ALL) return;
//---
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
//| Checks forced shutdown of MQL5-program.                          |
//| INPUT:  function - name of the caller.                           |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrade::IsStopped(string function)
  {
   if(!IsStopped()) return(false);
//--- MQL5 program is stopped
   printf("MQL5 program is stopped. Trading is disabled");
   m_result.retcode=TRADE_RETCODE_CLIENT_DISABLES_AT;
   return(true);
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
//--- check symbol
   sym.Name((symbol==NULL)?Symbol():symbol);
//--- check price
   if(price==0.0)
     {
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
//--- check symbol
   sym.Name((symbol==NULL)?Symbol():symbol);
//--- check price
   if(price==0.0)
     {
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
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price==0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_PRICE;
      return(false);
     }
//--- check symbol
   sym=(symbol==NULL)?Symbol():symbol;
//--- send "BUY_LIMIT" order
   return(OrderOpen(sym,ORDER_TYPE_BUY_LIMIT,volume,0.0,price,sl,tp,type_time,expiration,comment));
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
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price==0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_PRICE;
      return(false);
     }
//--- check symbol
   sym=(symbol==NULL)?Symbol():symbol;
//--- send "BUY_STOP" order
   return(OrderOpen(sym,ORDER_TYPE_BUY_STOP,volume,0.0,price,sl,tp,type_time,expiration,comment));
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
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price==0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_PRICE;
      return(false);
     }
//--- check symbol
   sym=(symbol==NULL)?Symbol():symbol;
//--- send "SELL_LIMIT" order
   return(OrderOpen(sym,ORDER_TYPE_SELL_LIMIT,volume,0.0,price,sl,tp,type_time,expiration,comment));
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
//--- check volume
   if(volume<=0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
      return(false);
     }
//--- check price
   if(price==0.0)
     {
      m_result.retcode=TRADE_RETCODE_INVALID_PRICE;
      return(false);
     }
//--- check symbol
   sym=(symbol==NULL)?Symbol():symbol;
//--- send "SELL_STOP" order
   return(OrderOpen(sym,ORDER_TYPE_SELL_STOP,volume,0.0,price,sl,tp,type_time,expiration,comment));
  }
//+------------------------------------------------------------------+
//| Converts the position type to text.                              |
//| INPUT:  str  - receiving string,                                 |
//|         type - position type.                                    |
//| OUTPUT: formatted string.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatPositionType(string& str,const uint type) const
  {
//--- clean
   str="";
//--- see the type
   switch(type)
     {
      case POSITION_TYPE_BUY : str="buy";  break;
      case POSITION_TYPE_SELL: str="sell"; break;

      default:
         str="unknown position type "+(string)type;
         break;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Converts the order type to text.                                 |
//| INPUT:  str  - receiving string,                                 |
//|         type - order type.                                       |
//| OUTPUT: formatted string.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderType(string& str,const uint type) const
  {
//--- clean
   str="";
//--- see the type
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
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Converts the order filling type to text.                         |
//| INPUT:  str  - receiving string,                                 |
//|         type - order filling type.                               |
//| OUTPUT: formatted string.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderTypeFilling(string& str,const uint type) const
  {
//--- clean
   str="";
//--- see the type
   switch(type)
     {
      case ORDER_FILLING_RETURN: str="return remainder"; break;
      case ORDER_FILLING_CANCEL: str="cancel remainder"; break;
      case ORDER_FILLING_AON   : str="all or none";      break;

      default:
         str="unknown type filling "+(string)type;
         break;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Converts the type of order by expiration to text.                |
//| INPUT:  str  - receiving string,                                 |
//|         type - type of order by expiration.                      |
//| OUTPUT: formatted string.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderTypeTime(string& str,const uint type) const
  {
//--- clean
   str="";
//--- see the type
   switch(type)
     {
      case ORDER_TIME_GTC      : str="gtc";       break;
      case ORDER_TIME_DAY      : str="day";       break;
      case ORDER_TIME_SPECIFIED: str="specified"; break;

      default:
         str="unknown type time "+(string)type;
         break;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Converts the order prices to text.                               |
//| INPUT:  str           - receiving string,                        |
//|         price_order   - order price,                             |
//|         price_trigger - the order trigger price.                 |
//| OUTPUT: formatted string.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatOrderPrice(string& str,const double price_order,const double price_trigger,const uint digits) const
  {
   string price,trigger;
//--- clean
   str="";
//--- Is there its trigger price?
   if(price_trigger)
     {
      price  =DoubleToString(price_order,digits);
      trigger=DoubleToString(price_trigger,digits);
      str    =StringFormat("%s (%s)",price,trigger);
     }
   else str=DoubleToString(price_order,digits);
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Converts the parameters of a trade request to text.              |
//| INPUT:  str     - receiving string,                              |
//|         request - reference ri the request structure.            |
//| OUTPUT: formatted string.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatRequest(string& str,const MqlTradeRequest& request) const
  {
   string      type,volume,volume_new,price,sl,tp,price_new,sl_new,tp_new;
   string      tmp;
   CSymbolInfo symbol;
//--- clean
   str="";
//--- set up
   int digits=5;
   if(request.symbol!=NULL)
     {
      if(symbol.Name(request.symbol))
         digits=symbol.Digits();
     }
//--- see what is wanted
   switch(request.action)
     {
      //--- instant execution of a deal
      case TRADE_ACTION_DEAL:
         switch(symbol.TradeExecution())
           {
            //--- request execution
            case SYMBOL_TRADE_EXECUTION_REQUEST:
               str=StringFormat("request %s %s %s at %s",
                                FormatOrderType(type,request.type),
                                DoubleToString(request.volume,2),
                                request.symbol,
                                DoubleToString(request.price,digits));
            //--- Is there SL or TP?
            if(request.sl) { tmp=StringFormat(" sl: %s",DoubleToString(request.sl,digits)); str+=tmp; }
            if(request.tp) { tmp=StringFormat(" tp: %s",DoubleToString(request.tp,digits)); str+=tmp; }
            break;
            //--- instant execution
            case SYMBOL_TRADE_EXECUTION_INSTANT:
               str=StringFormat("instant %s %s %s at %s",
                                FormatOrderType(type,request.type),
                                DoubleToString(request.volume,2),
                                request.symbol,
                                DoubleToString(request.price,digits));
            //--- Is there SL or TP?
            if(request.sl) { tmp=StringFormat(" sl: %s",DoubleToString(request.sl,digits)); str+=tmp; }
            if(request.tp) { tmp=StringFormat(" tp: %s",DoubleToString(request.tp,digits)); str+=tmp; }
            break;
            //--- market execution
            case SYMBOL_TRADE_EXECUTION_MARKET:
               str=StringFormat("market %s %s %s",
                                FormatOrderType(type,request.type),
                                DoubleToString(request.volume,2),
                                request.symbol);
            //--- Is there SL or TP?
            if(request.sl) { tmp=StringFormat(" sl: %s",DoubleToString(request.sl,digits)); str+=tmp; }
            if(request.tp) { tmp=StringFormat(" tp: %s",DoubleToString(request.tp,digits)); str+=tmp; }
            break;
           }
         break;
      //--- setting a pending order
      case TRADE_ACTION_PENDING:
         str=StringFormat("%s %s %s at %s",
                          FormatOrderType(type,request.type),
                          DoubleToString(request.volume,2),
                          request.symbol,
                          FormatOrderPrice(price,request.price,request.stoplimit,digits));
      //--- Is there SL or TP?
      if(request.sl) { tmp=StringFormat(" sl: %s",DoubleToString(request.sl,digits)); str+=tmp; }
      if(request.tp) { tmp=StringFormat(" tp: %s",DoubleToString(request.tp,digits)); str+=tmp; }
      break;

      //--- Setting SL/TP
      case TRADE_ACTION_SLTP:
         str=StringFormat("modify %s (sl: %s, tp: %s)",
                          request.symbol,
                          DoubleToString(request.sl,digits),
                          DoubleToString(request.tp,digits));
      break;

      //--- modifying a pending order
      case TRADE_ACTION_MODIFY:
         str=StringFormat("modify #%I64u at %s (sl: %s tp: %s)",
                          request.order,
                          FormatOrderPrice(price_new,request.price,request.stoplimit,digits),
                          DoubleToString(request.sl,digits),
                          DoubleToString(request.tp,digits));
      break;

      //--- deleting a pending order
      case TRADE_ACTION_REMOVE:
         str=StringFormat("cancel #%I64u",request.order);
      break;

      default:
         str="unknown action "+(string)request.action;
         break;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Converts teh result of a request to text.                        |
//| INPUT:  str     - receiving string,                              |
//|         request - reference at the request structure,            |
//|         result  - reference at the request result.               |
//| OUTPUT: formatted string.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CTrade::FormatRequestResult(string& str,const MqlTradeRequest& request,const MqlTradeResult& result) const
  {
   string      bid,ask;
   CSymbolInfo symbol;
//--- clean
   str="";
//--- set up
   int digits=5;
   if(request.symbol!=NULL)
     {
      if(symbol.Name(request.symbol))
         digits=symbol.Digits();
     }
//--- see the response code
   switch(result.retcode)
     {
      case TRADE_RETCODE_REQUOTE:
         str=StringFormat("requote (%s/%s)",
                          DoubleToString(result.bid,digits),
                          DoubleToString(result.ask,digits));
      break;

      case TRADE_RETCODE_DONE:
         if(request.action==TRADE_ACTION_DEAL &&
           (symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_REQUEST ||
            symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_INSTANT ||
            symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_MARKET))
            str=StringFormat("done at %s",DoubleToString(result.price,digits));
         else
            str="done";
      break;

      case TRADE_RETCODE_DONE_PARTIAL:
         if(request.action==TRADE_ACTION_DEAL &&
           (symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_REQUEST ||
            symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_INSTANT ||
            symbol.TradeExecution()==SYMBOL_TRADE_EXECUTION_MARKET))
            str=StringFormat("done partially %s at %s",
                             DoubleToString(result.volume,2),
                             DoubleToString(result.price,digits));
         else
            str=StringFormat("done partially %s",
                             DoubleToString(result.volume,2));
      break;

      case TRADE_RETCODE_REJECT            : str="rejected";                        break;
      case TRADE_RETCODE_CANCEL            : str="canceled";                        break;
      case TRADE_RETCODE_PLACED            : str="placed";                          break;
      case TRADE_RETCODE_ERROR             : str="common error";                    break;
      case TRADE_RETCODE_TIMEOUT           : str="timeout";                         break;
      case TRADE_RETCODE_INVALID           : str="invalid request";                 break;
      case TRADE_RETCODE_INVALID_VOLUME    : str="invalid volume";                  break;
      case TRADE_RETCODE_INVALID_PRICE     : str="invalid price";                   break;
      case TRADE_RETCODE_INVALID_STOPS     : str="invalid stops";                   break;
      case TRADE_RETCODE_TRADE_DISABLED    : str="trade disabled";                  break;
      case TRADE_RETCODE_MARKET_CLOSED     : str="market closed";                   break;
      case TRADE_RETCODE_NO_MONEY          : str="not enough money";                break;
      case TRADE_RETCODE_PRICE_CHANGED     : str="price changed";                   break;
      case TRADE_RETCODE_PRICE_OFF         : str="off quotes";                      break;
      case TRADE_RETCODE_INVALID_EXPIRATION: str="invalid expiration";              break;
      case TRADE_RETCODE_ORDER_CHANGED     : str="order changed";                   break;
      case TRADE_RETCODE_TOO_MANY_REQUESTS : str="too many requests";               break;
      case TRADE_RETCODE_NO_CHANGES        : str="no changes";                      break;
      case TRADE_RETCODE_SERVER_DISABLES_AT: str="auto trading disabled by server"; break;
      case TRADE_RETCODE_CLIENT_DISABLES_AT: str="auto trading disabled by client"; break;
      case TRADE_RETCODE_LOCKED            : str="locked";                          break;
      case TRADE_RETCODE_FROZEN            : str="frozen";                          break;
      case TRADE_RETCODE_INVALID_FILL      : str="invalid fill";                    break;
      case TRADE_RETCODE_CONNECTION        : str="no connection";                   break;
      case TRADE_RETCODE_ONLY_REAL         : str="only real";                       break;
      case TRADE_RETCODE_LIMIT_ORDERS      : str="limit orders";                    break;
      case TRADE_RETCODE_LIMIT_VOLUME      : str="limit volume";                    break;

      default:
         str="unknown retcode "+(string)result.retcode;
         break;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
