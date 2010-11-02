//+------------------------------------------------------------------+
//|                                         TrailingParabolicSAR.mqh |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.12 |
//+------------------------------------------------------------------+
#include <Expert\ExpertTrailing.mqh>
// wizard description start
//+------------------------------------------------------------------+
//| Description of the class                                         |
//| Title=Trailing with Parabolic SAR                                |
//| Type=Trailing                                                    |
//| Name=ParabolicSAR                                                |
//| Class=CTrailingPSAR                                              |
//| Page=                                                            |
//| Parameter=Step,double,0.02                                       |
//| Parameter=Maximum,double,0.2                                     |
//+------------------------------------------------------------------+
// wizard description end
//+------------------------------------------------------------------+
//| Class CTrailingPSAR.                                             |
//| Appointment: Class traling stops with Parabolic SAR.             |
//|              Derives from class CExpertTrailing.                 |
//+------------------------------------------------------------------+
class CTrailingPSAR : public CExpertTrailing
  {
protected:
   CiSAR            *m_SAR;
   //--- input parameters
   double            m_step;
   double            m_maximum;

public:
                     CTrailingPSAR();
                    ~CTrailingPSAR();
   //--- methods initialize protected data
   void              Step(double step)       { m_step=step;       }
   void              Maximum(double maximum) { m_maximum=maximum; }
   virtual bool      InitIndicators(CIndicators *indicators);
   //---
   virtual bool      CheckTrailingStopLong(CPositionInfo *position,double& sl,double& tp);
   virtual bool      CheckTrailingStopShort(CPositionInfo *position,double& sl,double& tp);
  };
//+------------------------------------------------------------------+
//| Constructor CTrailingPSAR.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrailingPSAR::CTrailingPSAR()
  {
//--- initialize protected data
   m_SAR    =NULL;
//--- set default inputs
   m_step   =0.02;
   m_maximum=0.2;
  }
//+------------------------------------------------------------------+
//| Destructor CTrailingPSAR.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTrailingPSAR::~CTrailingPSAR()
  {
//---
  }
//+------------------------------------------------------------------+
//| Checking for input parameters and setting protected data.        |
//| INPUT:  symbol         -pointer to the CSymbolInfo,              |
//|         period         -working period,                          |
//|         adjusted_point -adjusted point value.                    |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrailingPSAR::InitIndicators(CIndicators *indicators)
  {
//--- check
   if(indicators==NULL)       return(false);
//--- create SAR indicator
   if(m_SAR==NULL)
      if((m_SAR=new CiSAR)==NULL)
        {
         printf(__FUNCTION__+": Error creating object");
         return(false);
        }
//--- add SAR indicator to collection
   if(!indicators.Add(m_SAR))
     {
      printf(__FUNCTION__+": Error adding object");
      delete m_SAR;
      return(false);
     }
//--- initialize SAR indicator
   if(!m_SAR.Create(m_symbol.Name(),m_period,m_step,m_maximum))
     {
      printf(__FUNCTION__+": Error initializing object");
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
bool CTrailingPSAR::CheckTrailingStopLong(CPositionInfo *position,double& sl,double& tp)
  {
//--- check
   if(position==NULL) return(false);
//---
   double level =NormalizeDouble(m_symbol.Bid()-m_symbol.StopsLevel()*m_symbol.Point(),m_symbol.Digits());
   double new_sl=NormalizeDouble(m_SAR.Main(1),m_symbol.Digits());
//---
   sl=EMPTY_VALUE;
   tp=EMPTY_VALUE;
   if(new_sl>position.PriceOpen() && new_sl>position.StopLoss() && new_sl<level)
      sl=new_sl;
//---
   return(sl!=EMPTY_VALUE);
  }
//+------------------------------------------------------------------+
//| Checking trailing stop and/or profit for short position.         |
//| INPUT:  symbol -symbol.                                          |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTrailingPSAR::CheckTrailingStopShort(CPositionInfo *position,double& sl,double& tp)
  {
//--- check
   if(position==NULL) return(false);
//---
   double level =NormalizeDouble(m_symbol.Ask()+m_symbol.StopsLevel()*m_symbol.Point(),m_symbol.Digits());
   double new_sl=NormalizeDouble(m_SAR.Main(1)+m_symbol.Spread()*m_symbol.Point(),m_symbol.Digits());
//---
   sl=EMPTY_VALUE;
   tp=EMPTY_VALUE;
   if(new_sl<position.PriceOpen() && (new_sl<position.StopLoss() || position.StopLoss()==0.0) && new_sl>level)
      sl=new_sl;
//---
   return(sl!=EMPTY_VALUE);
  }
//+------------------------------------------------------------------+
