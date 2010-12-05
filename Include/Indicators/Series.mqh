//+------------------------------------------------------------------+
//|                                                       Series.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.10.17 |
//+------------------------------------------------------------------+
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayDouble.mqh>
//+------------------------------------------------------------------+
//| Class CSeries.                                                   |
//| Purpose: Base class for access to timeseries.                    |
//|          Derives from class CArrayObj.                           |
//+------------------------------------------------------------------+
class CSeries : public CArrayObj
  {
protected:
   string            m_name;             // name of series
   int               m_buffers_total;    // number of buffers
   int               m_timeframe_flags;  // flags of timeframes (similar to "flags of visibility of objects")
   string            m_symbol;           // symbol
   ENUM_TIMEFRAMES   m_period;           // period
   bool              m_refresh_current;  // flag

public:
                     CSeries();
   //--- methods of access to protected data
   string            Name()              const { return(m_name);            }
   int               BuffersTotal()      const { return(m_buffers_total);   }
   int               Timeframe()         const { return(m_timeframe_flags); }
   string            Symbol()            const { return(m_symbol);          }
   ENUM_TIMEFRAMES   Period()            const { return(m_period);          }
   string            PeriodDescription(int val=0);
   void              RefreshCurrent(bool flag) { m_refresh_current=flag;    }
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   virtual void      BufferResize(int size)    {                            }
   //--- method of refreshing" of the data
   virtual void      Refresh(int flags)        {                            }

protected:
   //--- methods of tuning
   void              SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period);
   void              PeriodToTimeframeFlag(ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Constructor CSeries.                                             |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CSeries::CSeries()
  {
//--- initialize protected data
   m_name           ="";
   m_timeframe_flags=0;
   m_buffers_total  =0;
   m_symbol         ="";
   m_period         =WRONG_VALUE;
   m_refresh_current=true;
  }
//+------------------------------------------------------------------+
//| Set symbol and period.                                           |
//| INPUT:  symbol - symbol,                                         |
//|         period - period.                                         |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CSeries::SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period)
  {
   if(symbol==NULL) m_symbol=ChartSymbol();
   else             m_symbol=symbol;
   if(period==0)    m_period=ChartPeriod();
   else             m_period=period;
   PeriodToTimeframeFlag(m_period);
  }
//+------------------------------------------------------------------+
//| Convert period to timeframe flag (similar to visibility flags).  |
//| INPUT:  period - period.                                         |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CSeries::PeriodToTimeframeFlag(ENUM_TIMEFRAMES period)
  {
   static ENUM_TIMEFRAMES _p_int[]={PERIOD_M1,PERIOD_M2,PERIOD_M3,PERIOD_M4,PERIOD_M5,PERIOD_M6,
                                    PERIOD_M10,PERIOD_M12,PERIOD_M15,PERIOD_M20,PERIOD_M30,
                                    PERIOD_H1,PERIOD_H2,PERIOD_H3,PERIOD_H4,PERIOD_H6,PERIOD_H8,PERIOD_H12,
                                    PERIOD_D1,PERIOD_W1,PERIOD_MN1};
//--- cycle for all timeframes
   for(int i=0;i<ArraySize(_p_int);i++)
      if(period==_p_int[i])
        {
         //--- at the same time generate the flag of the working timeframe
         m_timeframe_flags=((int)1)<<i;
         return;
        }
  }
//+------------------------------------------------------------------+
//| Converting value of ENUM_TIMEFRAMES to string.                   |
//| INPUT:  val - value for conversion.                              |
//| OUTPUT: conversion result.                                       |
//| REMARK: the parameter val has the int type for the               |
//|         possibility of transmission of error values.             |
//+------------------------------------------------------------------+
string CSeries::PeriodDescription(int val)
  {
   int i,frame;
//--- arrays for conversion of ENUM_TIMEFRAMES to string
   static string          _p_str[]={"M1","M2","M3","M4","M5","M6","M10","M12","M15","M20","M30",
                                    "H1","H2","H3","H4","H6","H8","H12","D1","W1","MN","UNKNOWN"};
   static ENUM_TIMEFRAMES _p_int[]={PERIOD_M1,PERIOD_M2,PERIOD_M3,PERIOD_M4,PERIOD_M5,PERIOD_M6,
                                    PERIOD_M10,PERIOD_M12,PERIOD_M15,PERIOD_M20,PERIOD_M30,
                                    PERIOD_H1,PERIOD_H2,PERIOD_H3,PERIOD_H4,PERIOD_H6,PERIOD_H8,PERIOD_H12,
                                    PERIOD_D1,PERIOD_W1,PERIOD_MN1};
//--- checking
   frame=(val==-1)?m_period:val;
   if(frame==WRONG_VALUE) return("WRONG_VALUE");
//--- cycle for all timeframes
   for(i=0;i<ArraySize(_p_int);i++)
      if(frame==_p_int[i]) break;
//---
   return(_p_str[i]);
  }
//+------------------------------------------------------------------+
//| Class CDoubleBuffer.                                             |
//| Purpose: Base class of buffer of data of the double type.        |
//|          Derives from class CArrayDouble.                        |
//+------------------------------------------------------------------+
class CDoubleBuffer : public CArrayDouble
  {
protected:
   string            m_symbol;           // symbol
   ENUM_TIMEFRAMES   m_period;           // period
   int               m_freshed_data;     // number of freshed data
   int               m_size;             // size of used history

public:
                     CDoubleBuffer();
   //--- methods of access to protected data
   void              Size(int size)      { m_size=size;  }
   //--- methods of access to data
   double            At(int index)                const;
   int               Minimum(int start,int count) const;
   int               Maximum(int start,int count) const;
   //--- method of refreshing of the data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
   //--- methods of tuning
   void              SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Constructor CDoubleBuffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CDoubleBuffer::CDoubleBuffer()
  {
//--- initialize protected data
   m_size  =16;
   ArraySetAsSeries(m_data,true);
  }
//+------------------------------------------------------------------+
//| Access to data in a specified position.                          |
//| INPUT:  index - position of element.                             |
//| OUTPUT: value of element in the position, or EMPTY_VALUE.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CDoubleBuffer::At(int index) const
  {
//--- checking
   if(index>=m_data_total) return(EMPTY_VALUE);
//---
   double d=CArrayDouble::At(index);
//---
   return(d);
  }
//+------------------------------------------------------------------+
//| Find minimum of buffer.                                          |
//| INPUT:  start - start element,                                   |
//|         count - number of elements of the search range.          |
//| OUTPUT: position of element, or -1.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDoubleBuffer::Minimum(int start,int count) const
  {
   return(ArrayMinimum(m_data,start,count));
  }
//+------------------------------------------------------------------+
//| Find maximum of buffer.                                          |
//| INPUT:  start - start element,                                   |
//|         count - number of elements of search range.              |
//| OUTPUT: position of element, or -1.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDoubleBuffer::Maximum(int start,int count) const
  {
   return(ArrayMaximum(m_data,start,count));
  }
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CDoubleBuffer::Refresh()
  {
   if(m_freshed_data>0)
     {
      m_data_total=ArraySize(m_data);
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CDoubleBuffer::RefreshCurrent()
  {
   if(m_freshed_data==1 && m_data_total>0)
     {
      ArrayResize(m_data,m_data_total);
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Set symbol and period.                                           |
//| INPUT:  symbol - symbol,                                         |
//|         period - period.                                         |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CDoubleBuffer::SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period)
  {
   if(symbol==NULL) m_symbol=ChartSymbol();
   else             m_symbol=symbol;
   if(period==0)    m_period=ChartPeriod();
   else             m_period=period;
  }
//+------------------------------------------------------------------+
