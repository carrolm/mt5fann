//+------------------------------------------------------------------+
//|                                                  AccountInfo.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CAccountInfo.                                              |
//| Appointment: Class for access to account info.                   |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CAccountInfo : public CObject
  {
public:
   //--- fast access methods to the integer account propertyes
   long              Login()                 const;
   ENUM_ACCOUNT_TRADE_MODE TradeMode()       const;
   string            TradeModeDescription()  const;
   long              Leverage()              const;
   ENUM_ACCOUNT_STOPOUT_MODE MarginMode()    const;
   string            MarginModeDescription() const;
   bool              TradeAllowed()          const;
   bool              TradeExpert()           const;
   int               LimitOrders()           const;
   //--- fast access methods to the double account propertyes
   double            Balance()               const;
   double            Credit()                const;
   double            Profit()                const;
   double            Equity()                const;
   double            Margin()                const;
   double            FreeMargin()            const;
   double            MarginLevel()           const;
   double            MarginCall()            const;
   double            MarginStopOut()         const;
   //--- fast access methods to the string account propertyes
   string            Name()                  const;
   string            Server()                const;
   string            Currency()              const;
   string            Company()               const;
   //--- access methods to the API MQL5 functions
   long              InfoInteger(ENUM_ACCOUNT_INFO_INTEGER prop_id) const;
   double            InfoDouble(ENUM_ACCOUNT_INFO_DOUBLE prop_id)   const;
   string            InfoString(ENUM_ACCOUNT_INFO_STRING prop_id)   const;
   //---
   double            OrderProfitCheck(const string symbol,ENUM_ORDER_TYPE trade_operation,double volume,double price_open,double price_close) const;
   double            MarginCheck(const string symbol,ENUM_ORDER_TYPE trade_operation,double volume,double price)      const;
   double            FreeMarginCheck(const string symbol,ENUM_ORDER_TYPE trade_operation,double volume,double price)  const;
   double            MaxLotCheck(const string symbol,ENUM_ORDER_TYPE trade_operation,double price,double percent=100) const;
  };
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_LOGIN".                          |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_LOGIN".                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CAccountInfo::Login() const
  {
   return(AccountInfoInteger(ACCOUNT_LOGIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_TRADE_MODE".                     |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_TRADE_MODE".                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_ACCOUNT_TRADE_MODE CAccountInfo::TradeMode() const
  {
   return((ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_TRADE_MODE" as string.           |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_TRADE_MODE" as string.       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CAccountInfo::TradeModeDescription() const
  {
   string str;
//---
   switch(TradeMode())
     {
      case ACCOUNT_TRADE_MODE_DEMO:
         str="Demo trading account";
         break;
      case ACCOUNT_TRADE_MODE_CONTEST:
         str="Contest trading account";
         break;
      case ACCOUNT_TRADE_MODE_REAL:
         str="Real trading account";
         break;
      default:
         str="Unknown trade account";
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_LEVERAGE".                       |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_LEVERAGE".                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CAccountInfo::Leverage() const
  {
   return(AccountInfoInteger(ACCOUNT_LEVERAGE));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_SO_MODE".                 |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_MARGIN_SO_MODE".             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_ACCOUNT_STOPOUT_MODE CAccountInfo::MarginMode() const
  {
   return((ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_SO_MODE" as string.       |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_MARGIN_SO_MODE" as string.   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CAccountInfo::MarginModeDescription() const
  {
   string str;
//---
   switch(MarginMode())
     {
      case ACCOUNT_STOPOUT_MODE_PERCENT:
         str="Level is specified in percentage";
         break;
      case ACCOUNT_STOPOUT_MODE_MONEY:
         str="Level is specified in money";
         break;
      default:
         str="Unknown margin mode";
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_TRADE_ALLOWED".                  |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_TRADE_ALLOWED".              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CAccountInfo::TradeAllowed() const
  {
   return((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_TRADE_EXPERT".                   |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_TRADE_EXPERT".               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CAccountInfo::TradeExpert() const
  {
   return((bool)AccountInfoInteger(ACCOUNT_TRADE_EXPERT));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_LIMIT_ORDERS".                   |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_LIMIT_ORDERS".               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CAccountInfo::LimitOrders() const
  {
   return((int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_BALANCE".                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_BALANCE".                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::Balance() const
  {
   return(AccountInfoDouble(ACCOUNT_BALANCE));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_CREDIT".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_CREDIT".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::Credit() const
  {
   return(AccountInfoDouble(ACCOUNT_CREDIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_PROFIT".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_PROFIT".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::Profit() const
  {
   return(AccountInfoDouble(ACCOUNT_PROFIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_EQUITY".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_EQUITY".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::Equity() const
  {
   return(AccountInfoDouble(ACCOUNT_EQUITY));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_MARGIN".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::Margin() const
  {
   return(AccountInfoDouble(ACCOUNT_MARGIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_FREEMARGIN".                     |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_FREEMARGIN".                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::FreeMargin() const
  {
   return(AccountInfoDouble(ACCOUNT_FREEMARGIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_LEVEL".                   |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_MARGIN_LEVEL".               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::MarginLevel() const
  {
   return(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_SO_CALL".                 |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_MARGIN_SO_CALL".             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::MarginCall() const
  {
   return(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_SO_SO".                   |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_MARGIN_SO_SO".               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::MarginStopOut() const
  {
   return(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_NAME".                           |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_NAME".                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CAccountInfo::Name() const
  {
   return(AccountInfoString(ACCOUNT_NAME));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_SERVER".                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_SERVER".                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CAccountInfo::Server() const
  {
   return(AccountInfoString(ACCOUNT_SERVER));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_CURRENCY".                       |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_CURRENCY".                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CAccountInfo::Currency() const
  {
   return(AccountInfoString(ACCOUNT_CURRENCY));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_COMPANY".                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "ACCOUNT_COMPANY".                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CAccountInfo::Company() const
  {
   return(AccountInfoString(ACCOUNT_COMPANY));
  }
//+------------------------------------------------------------------+
//| Access functions AccountInfoInteger(...).                        |
//| INPUT:  prop_id  -identifier integer properties.                 |
//| OUTPUT: the integer property value.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CAccountInfo::InfoInteger(ENUM_ACCOUNT_INFO_INTEGER prop_id) const
  {
   return(AccountInfoInteger(prop_id));
  }
//+------------------------------------------------------------------+
//| Access functions AccountInfoDouble(...).                         |
//| INPUT:  prop_id  -identifier double properties.                  |
//| OUTPUT: the double property value.                               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::InfoDouble(ENUM_ACCOUNT_INFO_DOUBLE prop_id) const
  {
   return(AccountInfoDouble(prop_id));
  }
//+------------------------------------------------------------------+
//| Access functions AccountInfoString(...).                         |
//| INPUT:  prop_id  -identifier string properties.                  |
//| OUTPUT: the string property value.                               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CAccountInfo::InfoString(ENUM_ACCOUNT_INFO_STRING prop_id) const
  {
   return(AccountInfoString(prop_id));
  }
//+------------------------------------------------------------------+
//| Access functions OrderCalcProfit(...).                           |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         volume          - volume of the opening position,        |
//|         price_open      - price of the opening position.         |
//|         price_close     - price of the closing position.         |
//| OUTPUT: the free margin value.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::OrderProfitCheck(const string symbol,ENUM_ORDER_TYPE trade_operation,double volume,double price_open,double price_close) const
  {
   double profit=EMPTY_VALUE;
//---
   if(!OrderCalcProfit(trade_operation,symbol,volume,price_open,price_close,profit)) return(EMPTY_VALUE);
//---
   return(profit);
  }
//+------------------------------------------------------------------+
//| Access functions OrderCalcMargin(...).                           |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         volume          - volume of the opening position,        |
//|         price           - price of the opening position.         |
//| OUTPUT: the free margin value.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::MarginCheck(const string symbol,ENUM_ORDER_TYPE trade_operation,double volume,double price) const
  {
   double margin=EMPTY_VALUE;
//---
   if(!OrderCalcMargin(trade_operation,symbol,volume,price,margin)) return(EMPTY_VALUE);
//---
   return(margin);
  }
//+------------------------------------------------------------------+
//| Access functions OrderCalcMargin(...).                           |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         volume          - volume of the opening position,        |
//|         price           - price of the opening position.         |
//| OUTPUT: the free margin value.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::FreeMarginCheck(const string symbol,ENUM_ORDER_TYPE trade_operation,double volume,double price) const
  {
   return(FreeMargin()-MarginCheck(symbol,trade_operation,volume,price));
  }
//+------------------------------------------------------------------+
//| Access functions OrderCalcMargin(...).                           |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         price           - price of the opening position.         |
//|         percent         - percent of available margin [1-100%]   |
//| OUTPUT: the free margin value.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CAccountInfo::MaxLotCheck(const string symbol,ENUM_ORDER_TYPE trade_operation,double price,double percent) const
  {
   double margin=0.0;
//--- checks
   if(symbol=="" || price<=0.0 || percent<1 || percent>100)
     {
      Print("CAccountInfo::MaxLotCheck invalid parameters");
      return(0.0);
     }
//--- calculate margin requirements for 1 lot
   if(!OrderCalcMargin(trade_operation,symbol,1.0,price,margin) || margin<0.0)
     {
      Print("CAccountInfo::MaxLotCheck margin calculation failed");
      return(0.0);
     }
//---
   if(margin==0.0)   // for pending orders
      return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX));
//--- calculate maximum volume
   double volume=NormalizeDouble(FreeMargin()*percent/100.0/margin,2);
//--- normalize and check limits
   double stepvol=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   if(stepvol>0.0)
     {
      double newvol=stepvol*NormalizeDouble(volume/stepvol,0);
      if(newvol>volume) volume=NormalizeDouble(newvol-stepvol,2);
      else              volume=newvol;
     }
//---
   double minvol=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   if(volume<minvol) volume=0.0;
//---
   double maxvol=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   if(volume>maxvol) volume=maxvol;
//--- return volume
   return(volume);
  }
//+------------------------------------------------------------------+
