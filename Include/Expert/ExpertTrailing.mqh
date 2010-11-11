//+------------------------------------------------------------------+
//|                                               ExpertTrailing.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.08 |
//+------------------------------------------------------------------+
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Indicators\Indicators.mqh>
//+------------------------------------------------------------------+
//| Class CExpertTrailing.                                           |
//| Appointment: Base class traling stops.                           |
//+------------------------------------------------------------------+
class CExpertTrailing
  {
protected:
   CSymbolInfo      *m_symbol;                   // symbol object
   ENUM_TIMEFRAMES   m_period;                   // period
   double            m_adjusted_point;           // point value adjusted for 3 or 5 points
   CAccountInfo      m_account;                  // account object

public:
                     CExpertTrailing();
   //--- methods initialize protected data
   virtual bool      Init(CSymbolInfo* symbol,ENUM_TIMEFRAMES period,double adjusted_point);
   virtual bool      InitIndicators(CIndicators* indicators)                               { return(true);  }
   virtual bool      ValidationSettings()                                                  { return(true);  }
   //---
   virtual bool      CheckTrailingStopLong(CPositionInfo* position,double& sl,double& tp)  { return(false); }
   virtual bool      CheckTrailingStopShort(CPositionInfo* position,double& sl,double& tp) { return(false); }
  };
//+------------------------------------------------------------------+
//| Constructor CExpertTrailing.                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CExpertTrailing::CExpertTrailing()
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
bool CExpertTrailing::Init(CSymbolInfo *symbol,ENUM_TIMEFRAMES period,double adjusted_point)
  {
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
