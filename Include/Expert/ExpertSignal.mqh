//+------------------------------------------------------------------+
//|                                                 ExpertSignal.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.08 |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Indicators\Indicators.mqh>
//+------------------------------------------------------------------+
//| Class CExpertSignal.                                             |
//| Appointment: Base class trading signals.                         |
//+------------------------------------------------------------------+
class CExpertSignal
  {
protected:
   CSymbolInfo      *m_symbol;                   // symbol object
   ENUM_TIMEFRAMES   m_period;                   // period
   double            m_adjusted_point;           // point value adjusted for 3 or 5 points
   CAccountInfo      m_account;                  // account object

public:
                     CExpertSignal();
   //--- methods initialize protected data
   virtual bool      Init(CSymbolInfo* symbol,ENUM_TIMEFRAMES period,double adjusted_point);
   virtual bool      InitIndicators(CIndicators* indicators)                                  { return(true);  }
   virtual bool      ValidationSettings()                                                     { return(true);  }
   //---
   virtual bool      CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration)  { return(false); }
   virtual bool      CheckCloseLong(double& price)                                            { return(false); }
   virtual bool      CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration) { return(false); }
   virtual bool      CheckCloseShort(double& price)                                           { return(false); }
   //---
   virtual bool      CheckReverseLong(double& price,double& sl,double& tp,datetime& expiration);
   virtual bool      CheckReverseShort(double& price,double& sl,double& tp,datetime& expiration);
   //---
   virtual bool      CheckTrailingOrderLong(COrderInfo* order,double& price)                  { return(false); }
   virtual bool      CheckTrailingOrderShort(COrderInfo* order,double& price)                 { return(false); }

protected:
   virtual double    PriceLevelUnit()                                              { return(m_adjusted_point); }
  };
//+------------------------------------------------------------------+
//| Constructor CExpertSignal.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpertSignal::CExpertSignal()
  {
//--- initialize protected data
   m_symbol=NULL;
  }
//+------------------------------------------------------------------+
//| Setting protected data.                                          |
//| INPUT:  symbol         -pointer to the CSymbolInfo,              |
//|         period         -working period,                          |
//|         adjusted_point -adjusted point value.                    |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpertSignal::Init(CSymbolInfo* symbol,ENUM_TIMEFRAMES period,double adjusted_point)
  {
//--- check
   if(symbol==NULL)
     {
      printf(__FUNCTION__+": error initializing");
      return(false);
     }
//---
   m_symbol        =symbol;
   m_period        =period;
   m_adjusted_point=adjusted_point;
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Check conditions for long position reverse.                      |
//| INPUT:  price      - refernce for price,                         |
//|         sl         - refernce for stop loss,                     |
//|         tp         - refernce for take profit,                   |
//|         expiration - refernce for expiration.                    |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpertSignal::CheckReverseLong(double& price,double& sl,double& tp,datetime& expiration)
  {
   double c_price;
//---
   if(!CheckCloseLong(c_price))                return(false);
   if(!CheckOpenShort(price,sl,tp,expiration)) return(false);
   if(c_price!=price)                          return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Check conditions for short position reverse.                     |
//| INPUT:  price      - refernce for price,                         |
//|         sl         - refernce for stop loss,                     |
//|         tp         - refernce for take profit,                   |
//|         expiration - refernce for expiration.                    |
//| OUTPUT: true-if condition performed, false otherwise.            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpertSignal::CheckReverseShort(double& price,double& sl,double& tp,datetime& expiration)
  {
   double c_price;
//---
   if(!CheckCloseShort(c_price))               return(false);
   if(!CheckOpenLong(price,sl,tp,expiration))  return(false);
   if(c_price!=price)                          return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
