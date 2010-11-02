//+------------------------------------------------------------------+
//|                                            TrailingFixedPips.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.08 |
//+------------------------------------------------------------------+
#include <Expert\ExpertTrailing.mqh>
// wizard description start
//+------------------------------------------------------------------+
//| Description of the class                                         |
//| Title=Trailing with fixed Stop Level                             |
//| Type=Trailing                                                    |
//| Name=FixedPips                                                   |
//| Class=CTrailingFixedPips                                         |
//| Page=                                                            |
//| Parameter=StopLevel,int,30                                       |
//| Parameter=ProfitLevel,int,50                                     |
//+------------------------------------------------------------------+
// wizard description end
//+------------------------------------------------------------------+
//| Class CTrailingFixedPips.                                        |
//| Appointment: Class traling stops with fixed in pips stop.        |
//|              Derives from class CExpertTrailing.                 |
//+------------------------------------------------------------------+
class CTrailingFixedPips : public CExpertTrailing
  {
protected:
   //--- input parameters
   int               m_stop_level;
   int               m_profit_level;

public:
                     CTrailingFixedPips();
   //--- methods initialize protected data
   void              StopLevel(int stop_level)     { m_stop_level=stop_level;     }
   void              ProfitLevel(int profit_level) { m_profit_level=profit_level; }
   virtual bool      ValidationSettings();
   //---
   virtual bool      CheckTrailingStopLong(CPositionInfo *position,double& sl,double& tp);
   virtual bool      CheckTrailingStopShort(CPositionInfo *position,double& sl,double& tp);
  };
//+------------------------------------------------------------------+
//| Constructor CTrailingFixedPips.                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrailingFixedPips::CTrailingFixedPips()
  {
//--- set default inputs
   m_stop_level  =30;
   m_profit_level=50;
  }
//+------------------------------------------------------------------+
//| Validation settings protected data.                              |
//| INPUT:  no.                                                      |
//| OUTPUT: true-if settings are correct, false otherwise.           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrailingFixedPips::ValidationSettings()
  {
//--- initial data checks
   if(m_profit_level*(m_adjusted_point/m_symbol.Point())<m_symbol.StopsLevel())
     {
      printf(__FUNCTION__+": Take Profit Level must be greater than %d",m_symbol.StopsLevel());
      return(false);
     }
   if(m_stop_level*(m_adjusted_point/m_symbol.Point())<m_symbol.StopsLevel())
     {
      printf(__FUNCTION__+": Trailing Stop Level must be greater than %d",m_symbol.StopsLevel());
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Checking trailing stop and/or profit for long position.          |
//| INPUT:  symbol -symbol.                                          |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrailingFixedPips::CheckTrailingStopLong(CPositionInfo *position,double& sl,double& tp)
  {
//--- check
   if(position==NULL) return(false);
//---
   double delta;
   double price=m_symbol.Bid();
//---
   sl=EMPTY_VALUE;
   tp=EMPTY_VALUE;
   if(m_stop_level!=0)
     {
      delta=m_stop_level*m_adjusted_point;
      if(position.StopLoss()==0.0)
        {
         if(price-position.PriceOpen()>delta) sl=price-delta;
        }
      else
        {
         if(price-position.StopLoss()>delta)  sl=price-delta;
        }
     }
   if(m_profit_level!=0)
     {
      delta=m_profit_level*m_adjusted_point;
      if(sl!=EMPTY_VALUE) tp=price+delta;
     }
//---
   return(sl!=EMPTY_VALUE);
  }
//+------------------------------------------------------------------+
//| Checking trailing stop and/or profit for short position.         |
//| INPUT:  symbol -symbol.                                          |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrailingFixedPips::CheckTrailingStopShort(CPositionInfo *position,double& sl,double& tp)
  {
//--- check
   if(position==NULL) return(false);
//---
   double delta;
   double price=m_symbol.Ask();
//---
   sl=EMPTY_VALUE;
   tp=EMPTY_VALUE;
   if(m_stop_level!=0)
     {
      delta=m_stop_level*m_adjusted_point;
      if(position.StopLoss()==0.0)
        {
         if(position.PriceOpen()-price>delta) sl=price+delta;
        }
      else
        {
         if(position.StopLoss()-price>delta)  sl=price+delta;
        }
     }
   if(m_profit_level!=0)
     {
      delta=m_profit_level*m_adjusted_point;
      if(sl!=EMPTY_VALUE) tp=price-delta;
     }
//---
   return(sl!=EMPTY_VALUE);
  }
//+------------------------------------------------------------------+
