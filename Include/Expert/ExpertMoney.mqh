//+------------------------------------------------------------------+
//|                                                  ExpertMoney.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.12 |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Indicators\Indicators.mqh>
//+------------------------------------------------------------------+
//| Class CExpertMoney.                                              |
//| Appointment: Base class money managment.                         |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CExpertMoney : public CObject
  {
protected:
   CSymbolInfo      *m_symbol;
   ENUM_TIMEFRAMES   m_period;
   double            m_adjusted_point;
   CAccountInfo      m_account;
   //--- input parameters
   double            m_percent;

public:
                     CExpertMoney();
   //--- methods initialize protected data
   void              Percent(double percent)                 { m_percent=percent; }
   virtual bool      Init(CSymbolInfo* symbol,ENUM_TIMEFRAMES period,double adjusted_point);
   virtual bool      InitIndicators(CIndicators* indicators) { return(true);      }
   virtual bool      ValidationSettings();
   //---
   virtual double    CheckOpenLong(double price,double sl);
   virtual double    CheckOpenShort(double price,double sl);
   virtual double    CheckReverse(CPositionInfo* position,double sl);
   virtual double    CheckClose(CPositionInfo* position);
  };
//+------------------------------------------------------------------+
//| Constructor CExpertMoney.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpertMoney::CExpertMoney()
  {
//--- initialize protected data
   m_symbol        =NULL;
   m_period        =PERIOD_CURRENT;
   m_adjusted_point=1.0;
//--- set default inputs
   m_percent       =10.0;
  }
//+------------------------------------------------------------------+
//| Setting protected data.                                          |
//| INPUT:  symbol         -pointer to the CSymbolInfo,              |
//|         period         -working period,                          |
//|         adjusted_point -adjusted point value.                    |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpertMoney::Init(CSymbolInfo *symbol,ENUM_TIMEFRAMES period,double adjusted_point)
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
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Validation settings protected data.                              |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if settings are correct, false otherwise.           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CExpertMoney::ValidationSettings()
  {
//--- initial data checks
   if(m_percent<0.0 || m_percent>100.0)
     {
      printf(__FUNCTION__+": percentage of risk should be in the range from 0 to 100 inclusive");
      return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Getting lot size for open long position.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: lot-if successful, 0.0 otherwise.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CExpertMoney::CheckOpenLong(double price,double sl)
  {
   if(m_symbol==NULL) return(0.0);
//---
   double lot;
   if(price==0.0)
      lot=m_account.MaxLotCheck(m_symbol.Name(),ORDER_TYPE_BUY,m_symbol.Ask(),m_percent);
   else
      lot=m_account.MaxLotCheck(m_symbol.Name(),ORDER_TYPE_BUY,price,m_percent);
   if(lot<m_symbol.LotsMin()) return(0.0);
//---
   return(m_symbol.LotsMin());
  }
//+------------------------------------------------------------------+
//| Getting lot size for open short position.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: lot-if successful, 0.0 otherwise.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CExpertMoney::CheckOpenShort(double price,double sl)
  {
   if(m_symbol==NULL) return(0.0);
//---
   double lot;
   if(price==0.0)
      lot=m_account.MaxLotCheck(m_symbol.Name(),ORDER_TYPE_SELL,m_symbol.Ask(),m_percent);
   else
      lot=m_account.MaxLotCheck(m_symbol.Name(),ORDER_TYPE_SELL,price,m_percent);
   if(lot<m_symbol.LotsMin()) return(0.0);
//---
   return(m_symbol.LotsMin());
  }
//+------------------------------------------------------------------+
//| Getting lot size for reverse.                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: lot-if successful, 0.0 otherwise.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CExpertMoney::CheckReverse(CPositionInfo* position,double sl)
  {
   double lots=0.0;
//---
   if(position.PositionType()==POSITION_TYPE_BUY)
      lots=CheckOpenShort(m_symbol.Bid(),sl);
   if(position.PositionType()==POSITION_TYPE_SELL)
      lots=CheckOpenLong(m_symbol.Ask(),sl);
//---
   if(lots!=0.0) lots+=position.Volume();
//---
   return(lots);
  }
//+------------------------------------------------------------------+
//| Getting lot size for close.                                      |
//| INPUT:  no.                                                      |
//| OUTPUT: lot-if successful, 0.0 otherwise.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CExpertMoney::CheckClose(CPositionInfo* position)
  {
   if(m_percent==0.0)
     return(0.0);
//---
   if(-position.Profit()>m_account.Balance()*m_percent/100.0)
     return(position.Volume());
//---
   return(0.0);
  }
//+------------------------------------------------------------------+
