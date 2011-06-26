//+------------------------------------------------------------------+
//|                                                   TimeSeries.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2011.06.09 |
//+------------------------------------------------------------------+
#include "Series.mqh"
#include <Arrays\ArrayInt.mqh>
#include <Arrays\ArrayLong.mqh>
//+------------------------------------------------------------------+
//| Class CPriceSeries.                                              |
//| Purpose: Base class of price series.                             |
//|          Derives from class CSeries.                             |
//+------------------------------------------------------------------+
class CPriceSeries : public CSeries
  {
public:
   //--- method of creation
   virtual bool      BufferResize(int size);
   //--- methods for searching extremum
   virtual int       MinIndex(int start,int count)            const;
   virtual double    MinValue(int start,int count,int& index) const;
   virtual int       MaxIndex(int start,int count)            const;
   virtual double    MaxValue(int start,int count,int& index) const;
   //--- methods of access to data
   double            GetData(int index)                       const;
   //--- method of refreshing of the data
   virtual void      Refresh(int flags);
  };
//+------------------------------------------------------------------+
//| Set size of buffer.                                              |
//| INPUT:  size - size buffer.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CPriceSeries::BufferResize(int size)
  {
   if(size>m_buffer_size && !CSeries::BufferResize(size)) return(false);
//-- history is avalible
   CDoubleBuffer *buff=At(0);
//--- check pointer
   if(buff==NULL) return(false);
//--
   buff.Size(size);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Find minimum of specified buffer.                                |
//| INPUT:  start - start element,                                   |
//|         count - number of elements of search range.              |
//| OUTPUT: position of element, or -1.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CPriceSeries::MinIndex(int start,int count) const
  {
   CDoubleBuffer *buff=At(0);
//--- checking
   if(buff==NULL) return(-1);
//---
   return(buff.Minimum(start,count));
  }
//+------------------------------------------------------------------+
//| Find minimum of specified buffer.                                |
//| INPUT:  start - first element,                                   |
//|         count - number of elements for search range,             |
//|         index - reference to variable for index value.           |
//| OUTPUT: value of element, or EMPTY_VALUE.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPriceSeries::MinValue(int start,int count,int& index) const
  {
   int    idx=MinIndex(start,count);
   double res=EMPTY_VALUE;
//--- checking
   if(idx!=-1)
     {
      CDoubleBuffer *buff=At(0);
      res=buff.At(idx);
      index=idx;
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Find maximum of specified buffer.                                |
//| INPUT:  start - start element,                                   |
//|         count - number of elements for search range.             |
//| OUTPUT: position of element, or -1.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CPriceSeries::MaxIndex(int start,int count) const
  {
   CDoubleBuffer *buff=At(0);
//--- checking
   if(buff==NULL) return(-1);
//---
   return(buff.Maximum(start,count));
  }
//+------------------------------------------------------------------+
//| Find maximum of specified buffer.                                |
//| INPUT:  start - start element,                                   |
//|         count - number of elements for search range,             |
//|         index - reference to variable for index value.           |
//| OUTPUT: value element, or EMPTY_VALUE.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPriceSeries::MaxValue(int start,int count,int& index) const
  {
   int    idx=MaxIndex(start,count);
   double res=EMPTY_VALUE;
//--- checking
   if(idx!=-1)
     {
      CDoubleBuffer *buff=At(0);
      res=buff.At(idx);
      index=idx;
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Method to access data.                                           |
//| INPUT:  index - position element in the buffer.                  |
//| OUTPUT: value if successful, EMPTY_VALUE if not.                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CPriceSeries::GetData(int index) const
  {
   CDoubleBuffer *buff=At(0);
//--- checking
   if(buff==NULL)
     {
      Print("CPriceSeries::GetData: invalid buffer");
      return(EMPTY_VALUE);
     }
//---
   return(buff.At(index));
  }
//+------------------------------------------------------------------+
//| Refreshing of the data.                                          |
//| INPUT:  flags - flags of updating timeframes.                    |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CPriceSeries::Refresh(int flags)
  {
   CDoubleBuffer *buff=At(0);
//--- checking
   if(buff==NULL) return;
//--- refreshing of buffers
   if(!(flags&m_timeframe_flags))
     {
      if(m_refresh_current) buff.RefreshCurrent();
     }
   else                     buff.Refresh();
  }
//+------------------------------------------------------------------+
//| Class COpenBuffer.                                               |
//| Purpose: Class of buffer of open price series.                   |
//|          Derives from class CDoubleBuffer.                       |
//+------------------------------------------------------------------+
class COpenBuffer : public CDoubleBuffer
  {
public:
   //--- method of refreshing of the data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
  };
//+------------------------------------------------------------------+
//| Refreshing of the data buffer.                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool COpenBuffer::Refresh()
  {
   m_data_total=CopyOpen(m_symbol,m_period,0,m_size,m_data);
//---
   return(m_data_total>0);
  }
//+------------------------------------------------------------------+
//| Refreshing of the data buffer.                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool COpenBuffer::RefreshCurrent()
  {
   double array[1];
//---
   if(CopyOpen(m_symbol,m_period,0,1,array)==1 && m_data_total>0)
     {
      m_data[0]=array[0];
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Class CiOpen.                                                    |
//| Purpose: Class of open series.                                   |
//|          Derives from class CPriceSeries.                        |
//+------------------------------------------------------------------+
class CiOpen : public CPriceSeries
  {
public:
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   //--- methods of access to data
   int               GetData(int start_pos,int count,double& buffer[])                const;
   int               GetData(datetime start_time,int count,double& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,double& buffer[]) const;
  };
//+------------------------------------------------------------------+
//| Creation of open series.                                         |
//| INPUT:  symbol  - series symbol,                                 |
//|         period  - series period.                                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiOpen::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   CDoubleBuffer *buff;
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   if((buff=new COpenBuffer)==NULL)    return(false);
//--- add
   if(!Add(buff))
     {
      delete buff;
      return(false);
     }
//--- tune
   buff.SetSymbolPeriod(m_symbol,m_period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| API access method "Copying the open buffer by specifying         |
//| start position and number of elements".                          |
//| INPUT:  start_pos - position of start element in the buffer,     |
//|         count     - number of elements to copy,                  |
//|         buffer    - reference to a dynamic array of double       |
//|                     values.                                      |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiOpen::GetData(int start_pos,int count,double& buffer[]) const
  {
   return(CopyOpen(m_symbol,m_period,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the open buffer by specifying         |
//| start time and number of elements".                              |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         count      - number of elements to copy,                 |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiOpen::GetData(datetime start_time,int count,double& buffer[]) const
  {
   return(CopyOpen(m_symbol,m_period,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the open buffer by specifying         |
//| start and end time".                                             |
//| INPUT:  start_time - time of start element of the buffer,        |
//|         stop_time  - time of end element of the buffer,          |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiOpen::GetData(datetime start_time,datetime stop_time,double& buffer[]) const
  {
   return(CopyOpen(m_symbol,m_period,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Class CHighBuffer.                                               |
//| Purpose: Class of buffer of high price series.                   |
//|          Derives from class CDoubleBuffer.                       |
//+------------------------------------------------------------------+
class CHighBuffer : public CDoubleBuffer
  {
public:
   //--- method of refreshing of the data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
  };
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CHighBuffer::Refresh()
  {
   m_data_total=CopyHigh(m_symbol,m_period,0,m_size,m_data);
//---
   return(m_data_total>0);
  }
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CHighBuffer::RefreshCurrent()
  {
   double array[1];
//---
   if(CopyHigh(m_symbol,m_period,0,1,array)>0 && m_data_total>0)
     {
      m_data[0]=array[0];
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Class CiHigh.                                                    |
//| Purpose: Class of high series.                                   |
//|          Derives from class CPriceSeries.                        |
//+------------------------------------------------------------------+
class CiHigh : public CPriceSeries
  {
public:
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   //--- methods of access to data
   int               GetData(int start_pos,int count,double& buffer[])                const;
   int               GetData(datetime start_time,int count,double& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,double& buffer[]) const;
  };
//+------------------------------------------------------------------+
//| Creation of high series.                                         |
//| INPUT:  symbol - series symbol,                                  |
//|         period - series period.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiHigh::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   CDoubleBuffer *buff;
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   if((buff=new CHighBuffer)==NULL)    return(false);
//--- add
   if(!Add(buff))
     {
      delete buff;
      return(false);
     }
//--- tune
   buff.SetSymbolPeriod(m_symbol,m_period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| API access method "Copying the high buffer by specifying         |
//| start position and number of elements".                          |
//| INPUT:  start_pos - position of start element in the buffer,     |
//|         count     - number of elements to copy,                  |
//|         buffer    - reference to a dynamic array of double       |
//|                     value.                                       |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiHigh::GetData(int start_pos,int count,double& buffer[]) const
  {
   return(CopyHigh(m_symbol,m_period,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the high buffer for the initial       |
//| time and the number of elements".                                |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         count      - number of elements to copy,                 |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiHigh::GetData(datetime start_time,int count,double& buffer[]) const
  {
   return(CopyHigh(m_symbol,m_period,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the high buffer by specifying         |
//| start and end time".                                             |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         stop_time  - time of end element in the buffer,          |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiHigh::GetData(datetime start_time,datetime stop_time,double& buffer[]) const
  {
   return(CopyHigh(m_symbol,m_period,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Class CLowBuffer.                                                |
//| Purpose: Class of buffer of low price series.                    |
//|          Derives from class CPriceBuffer.                        |
//+------------------------------------------------------------------+
class CLowBuffer : public CDoubleBuffer
  {
public:
   //--- method of refreshing of the data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
  };
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CLowBuffer::Refresh()
  {
   m_data_total=CopyLow(m_symbol,m_period,0,m_size,m_data);
//---
   return(m_data_total>0);
  }
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CLowBuffer::RefreshCurrent()
  {
   double array[1];
//---
   if(CopyLow(m_symbol,m_period,0,1,array)>0 && m_data_total>0)
     {
      m_data[0]=array[0];
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Class CiLow.                                                     |
//| Purpose: Class of low series.                                    |
//|          Derives from class CPriceSeries.                        |
//+------------------------------------------------------------------+
class CiLow : public CPriceSeries
  {
public:
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   //--- methods of access to data
   int               GetData(int start_pos,int count,double& buffer[])                const;
   int               GetData(datetime start_time,int count,double& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,double& buffer[]) const;
  };
//+------------------------------------------------------------------+
//| Creation of low series.                                          |
//| INPUT:  symbol - series symbol,                                  |
//|         period - series period.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiLow::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   CDoubleBuffer *buff;
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   if((buff=new CLowBuffer)==NULL)     return(false);
//--- add
   if(!Add(buff))
     {
      delete buff;
      return(false);
     }
//--- tune
   buff.SetSymbolPeriod(m_symbol,m_period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| API access method "Copying the low buffer by specifying          |
//| start position and number of elements".                          |
//| INPUT:  start_pos - position of start element in the buffer,     |
//|         count     - number of elements to copy,                  |
//|         buffer    - reference to a dynamic array of double       |
//|                     values.                                      |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiLow::GetData(int start_pos,int count,double& buffer[]) const
  {
   return(CopyLow(m_symbol,m_period,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the low buffer for the initial        |
//| time and the number of elements".                                |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         count      - number of elements to copy,                 |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiLow::GetData(datetime start_time,int count,double& buffer[]) const
  {
   return(CopyLow(m_symbol,m_period,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the low buffer for the initial        |
//| and final time".                                                 |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         stop_time  - time of end element in the buffer,          |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiLow::GetData(datetime start_time,datetime stop_time,double& buffer[]) const
  {
   return(CopyLow(m_symbol,m_period,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Class CCloseBuffer.                                              |
//| Purpose: Class of buffer of low price series.                    |
//|          Derives from class CPriceBuffer.                        |
//+------------------------------------------------------------------+
class CCloseBuffer : public CDoubleBuffer
  {
public:
   //--- method of refreshing of data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
  };
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCloseBuffer::Refresh()
  {
   m_data_total=CopyClose(m_symbol,m_period,0,m_size,m_data);
//---
   return(m_data_total>0);
  }
//+------------------------------------------------------------------+
//| Refreshing of the data buffer.                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CCloseBuffer::RefreshCurrent()
  {
   double array[1];
//---
   if(CopyClose(m_symbol,m_period,0,1,array)>0 && m_data_total>0)
     {
      m_data[0]=array[0];
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Class CiClose.                                                   |
//| Purpose: Class of close series.                                  |
//|          Derives from class CPriceSeries.                        |
//+------------------------------------------------------------------+
class CiClose : public CPriceSeries
  {
public:
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   //--- methods of access to data
   int               GetData(int start_pos,int count,double& buffer[])                const;
   int               GetData(datetime start_time,int count,double& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,double& buffer[]) const;
  };
//+------------------------------------------------------------------+
//| Creation of the close series.                                    |
//| INPUT:  symbol - series symbol,                                  |
//|         period - series period.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiClose::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   CDoubleBuffer *buff;
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   if((buff=new CCloseBuffer)==NULL)   return(false);
//--- add
   if(!Add(buff))
     {
      delete buff;
      return(false);
     }
//--- tune
   buff.SetSymbolPeriod(m_symbol,m_period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| API access method "Copying the close buffer by specifying        |
//| start position and number of elements".                          |
//| INPUT:  start_pos - position of start element in the buffer,     |
//|         count     - number of elements to copy,                  |
//|         buffer    - reference to a dynamic array of double       |
//|                     values.                                      |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiClose::GetData(int start_pos,int count,double& buffer[]) const
  {
   return(CopyClose(m_symbol,m_period,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the close buffer by specifying        |
//| start time and number of elements".                              |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         count      - number of elements to copy,                 |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiClose::GetData(datetime start_time,int count,double& buffer[]) const
  {
   return(CopyClose(m_symbol,m_period,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the close buffer by specifying        |
//| start and end time".                                             |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         stop_time  - time of end element in the buffer,          |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiClose::GetData(datetime start_time,datetime stop_time,double& buffer[]) const
  {
   return(CopyClose(m_symbol,m_period,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Class CSpreadBuffer.                                             |
//| Purpose: Class of buffer of spread series.                       |
//|          Derives from class CArrayInt.                           |
//+------------------------------------------------------------------+
class CSpreadBuffer : public CArrayInt
  {
protected:
   string            m_symbol;           // symbol
   ENUM_TIMEFRAMES   m_period;           // period
   int               m_freshed_data;     // number of refreshed data
   int               m_size;             // size of used history

public:
                     CSpreadBuffer();
   //--- methods of access to protected data
   void              Size(int size) { m_size=size; }
   //--- methods of access to data
   int               At(int index) const;
   //--- method of refreshing of the data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
   //--- methods of tuning
   void              SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Constructor CSpreadBuffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CSpreadBuffer::CSpreadBuffer()
  {
//--- initialize protected data
   m_size=DEFAULT_BUFFER_SIZE;
   ArraySetAsSeries(m_data,true);
  }
//+------------------------------------------------------------------+
//| Access to data on the position.                                  |
//| INPUT:  index - position of element.                             |
//| OUTPUT: element in the position, or 0.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSpreadBuffer::At(int index) const
  {
//--- checking
   if(index>=m_data_total) return(0);
//---
   int d=CArrayInt::At(index);
//---
   return(CArrayInt::At(index));
  }
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSpreadBuffer::Refresh()
  {
   m_freshed_data=CopySpread(m_symbol,m_period,0,m_size,m_data);
//---
   if(m_freshed_data>0)
     {
      m_data_total=ArraySize(m_data);
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Refreshing of the data buffer.                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CSpreadBuffer::RefreshCurrent()
  {
   int array[1];
//---
   m_freshed_data=CopySpread(m_symbol,m_period,0,1,m_data);
//---
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
void CSpreadBuffer::SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period)
  {
   if(symbol==NULL) m_symbol=ChartSymbol();
   else             m_symbol=symbol;
   if(period==0)    m_period=ChartPeriod();
   else             m_period=period;
  }
//+------------------------------------------------------------------+
//| Class CiSpread.                                                  |
//| Purpose: Class of spread series.                                 |
//|          Derives from class CSeries.                             |
//+------------------------------------------------------------------+
class CiSpread : public CSeries
  {
public:
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   virtual bool      BufferResize(int size);
   //--- methods of access to data
   int               GetData(int index)                                            const;
   int               GetData(int start_pos,int count,int& buffer[])                const;
   int               GetData(datetime start_time,int count,int& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,int& buffer[]) const;
   //--- method of refreshing of the data
   virtual void      Refresh(int flags);
  };
//+------------------------------------------------------------------+
//| Creating of the spread series.                                   |
//| INPUT:  symbol  - series symbol,                                 |
//|         period  - series period.                                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiSpread::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   CSpreadBuffer *buff;
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   if((buff=new CSpreadBuffer)==NULL)  return(false);
//--- add
   if(!Add(buff))
     {
      delete buff;
      return(false);
     }
//--- tune
   buff.SetSymbolPeriod(m_symbol,m_period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Method to access data.                                           |
//| INPUT:  index - position of element in the buffer.               |
//| OUTPUT: value of element if successful, 0 if not.                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiSpread::GetData(int index) const
  {
   CSpreadBuffer *buff=At(0);
//--- checking
   if(buff==NULL)
     {
      Print("CiSpread::GetData: invalid buffer");
      return(0);
     }
//---
   return(buff.At(index));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the spread buffer by specifying       |
//| start position and number of elements".                          |
//| INPUT:  start_pos - position of start element in the buffer,     |
//|         count     - number of elements to copy,                  |
//|         buffer    - reference to a dynamic array of double       |
//|                     values.                                      |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiSpread::GetData(int start_pos,int count,int& buffer[]) const
  {
   return(CopySpread(m_symbol,m_period,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the spread buffer by specifying       |
//| start time and number of elements".                              |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         count      - number of elements to copy,                 |
//|         buffer     - reference to a dynamic array of double      |
//|                      value.                                      |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiSpread::GetData(datetime start_time,int count,int& buffer[]) const
  {
   return(CopySpread(m_symbol,m_period,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the spread buffer by specifying       |
//| start and end time".                                             |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         stop_time  - time of end element in the buffer,          |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiSpread::GetData(datetime start_time,datetime stop_time,int& buffer[]) const
  {
   return(CopySpread(m_symbol,m_period,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Set size buffer.                                                 |
//| INPUT:  size - size buffer.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiSpread::BufferResize(int size)
  {
   if(size>m_buffer_size && !CSeries::BufferResize(size)) return(false);
//-- history is avalible
   CSpreadBuffer *buff=At(0);
//--- check pointer
   if(buff==NULL) return(false);
//---
   buff.Size(size);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Refreshing of data.                                              |
//| INPUT:  flags - flags of updating timeframes.                    |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CiSpread::Refresh(int flags)
  {
   CSpreadBuffer *buff=At(0);
//--- checking
   if(buff==NULL) return;
//--- refreshing buffer
   if(!(flags&m_timeframe_flags))
     {
      if(m_refresh_current) buff.RefreshCurrent();
     }
   else                     buff.Refresh();
  }
//+------------------------------------------------------------------+
//| Class CTimeBuffer.                                               |
//| Purpose: Class of buffer of time series.                         |
//|          Derives from class CArrayLong.                          |
//+------------------------------------------------------------------+
class CTimeBuffer : public CArrayLong
  {
protected:
   string            m_symbol;           // symbol
   ENUM_TIMEFRAMES   m_period;           // period
   int               m_freshed_data;     // number of refreshed data
   int               m_size;             // size of used history

public:
                     CTimeBuffer();
   //--- methods of access to protected data
   void              Size(int size) { m_size=size; }
   //--- methods of access to data
   long              At(int index) const;
   //--- method of refreshing of the data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
   //--- methods of tuning
   void              SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Constructor CTimeBuffer.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CTimeBuffer::CTimeBuffer()
  {
//--- initialize protected data
   m_size=DEFAULT_BUFFER_SIZE;
   ArraySetAsSeries(m_data,true);
  }
//+------------------------------------------------------------------+
//| Access to data in a position.                                    |
//| INPUT:  index - position of element.                             |
//| OUTPUT: element in the position, or 0.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CTimeBuffer::At(int index) const
  {
//--- checking
   if(index>=m_data_total) return(0);
//---
   datetime d=(datetime)CArrayLong::At(index);
//---
   return(d);
  }
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTimeBuffer::Refresh()
  {
   m_freshed_data=CopyTime(m_symbol,m_period,0,m_size,m_data);
//---
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
bool CTimeBuffer::RefreshCurrent()
  {
   long array[1];
//---
   m_freshed_data=CopyTime(m_symbol,m_period,0,1,m_data);
//---
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
void CTimeBuffer::SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period)
  {
   if(symbol==NULL) m_symbol=ChartSymbol();
   else             m_symbol=symbol;
   if(period==0)    m_period=ChartPeriod();
   else             m_period=period;
  }
//+------------------------------------------------------------------+
//| Class CiTime.                                                    |
//| Purpose: Class of time series.                                   |
//|          Derives from class CSeries.                             |
//+------------------------------------------------------------------+
class CiTime : public CSeries
  {
public:
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   virtual bool      BufferResize(int size);
   //--- methods of access to data
   datetime          GetData(int index)                                                 const;
   int               GetData(int start_pos,int count,datetime& buffer[])                const;
   int               GetData(datetime start_time,int count,datetime& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,datetime& buffer[]) const;
   //--- method of refreshing of the data
   virtual void      Refresh(int flags);
  };
//+------------------------------------------------------------------+
//| Creating of the time series.                                     |
//| INPUT:  symbol - series symbol,                                  |
//|         period - series period.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiTime::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   CTimeBuffer *buff;
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   if((buff=new CTimeBuffer)==NULL)    return(false);
//--- add
   if(!Add(buff))
     {
      delete buff;
      return(false);
     }
//--- tune
   buff.SetSymbolPeriod(m_symbol,m_period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Method to access data.                                           |
//| INPUT:  index - position of element in the buffer.               |
//| OUTPUT: value - if successful, 0 otherwise.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
datetime CiTime::GetData(int index) const
  {
   CTimeBuffer *buff=At(0);
//--- checking
   if(buff==NULL)
     {
      Print("CiSpread::GetData: invalid buffer");
      return(0);
     }
//---
   return((datetime)buff.At(index));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the time buffer by specifying         |
//| start position and number of elements".                          |
//| INPUT:  start_pos - position of start element in the buffer,     |
//|         count     - number of elements to copy,                  |
//|         buffer    - reference to a dynamic array of double       |
//|                     values.                                      |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiTime::GetData(int start_pos,int count,datetime& buffer[]) const
  {
   return(CopyTime(m_symbol,m_period,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the time buffer by specifying         |
//| start time and number of elements".                              |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         count      - number of elements to copy,                 |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiTime::GetData(datetime start_time,int count,datetime& buffer[]) const
  {
   return(CopyTime(m_symbol,m_period,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the time buffer by specifying         |
//| start and end time".                                             |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         stop_time  - time of end element in the buffer,          |
//|         buffer     - reference to a dynamic array of double      |
//|                      variables.                                  |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiTime::GetData(datetime start_time,datetime stop_time,datetime& buffer[]) const
  {
   return(CopyTime(m_symbol,m_period,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Set size buffer.                                                 |
//| INPUT:  size - size buffer.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiTime::BufferResize(int size)
  {
   if(size>m_buffer_size && !CSeries::BufferResize(size)) return(false);
//-- history is avalible
   CTimeBuffer *buff=At(0);
//--- check pointer
   if(buff==NULL) return(false);
//---
   buff.Size(size);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Refreshing of data.                                              |
//| INPUT:  flags - flags of updating timeframes.                    |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CiTime::Refresh(int flags)
  {
   CTimeBuffer *buff=At(0);
//--- checking
   if(buff==NULL) return;
//--- refreshing buffers
   if(!(flags&m_timeframe_flags))
     {
      if(m_refresh_current) buff.RefreshCurrent();
     }
   else                     buff.Refresh();
  }
//+------------------------------------------------------------------+
//| Class CTickVolumeBuffer.                                         |
//| Purpose: Class of buffer of tick volume series.                  |
//|          Derives from class CArrayLong.                          |
//+------------------------------------------------------------------+
class CTickVolumeBuffer : public CArrayLong
  {
protected:
   string            m_symbol;           // symbol
   ENUM_TIMEFRAMES   m_period;           // period
   int               m_freshed_data;     // number of refreshed data
   int               m_size;             // size of used history

public:
                     CTickVolumeBuffer();
   //--- methods of access to protected data
   void              Size(int size) { m_size=size; }
   //--- methods of access to data
   long              At(int index) const;
   //--- method of refreshing of the data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
   //--- methods of tuning
   void              SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Constructor CTickVolumeBuffer.                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CTickVolumeBuffer::CTickVolumeBuffer()
  {
//--- initialize protected data
   m_size=DEFAULT_BUFFER_SIZE;
   ArraySetAsSeries(m_data,true);
  }
//+------------------------------------------------------------------+
//| Access to data in a position.                                    |
//| INPUT:  index - position of element.                             |
//| OUTPUT: value of element in the position, or 0.                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CTickVolumeBuffer::At(int index) const
  {
//--- checking
   if(index>=m_data_total) return(0);
//---
   datetime d=(datetime)CArrayLong::At(index);
//---
   return(d);
  }
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTickVolumeBuffer::Refresh()
  {
   m_freshed_data=CopyTickVolume(m_symbol,m_period,0,m_size,m_data);
//---
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
bool CTickVolumeBuffer::RefreshCurrent()
  {
   long array[1];
//---
   m_freshed_data=CopyTickVolume(m_symbol,m_period,0,1,m_data);
//---
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
void CTickVolumeBuffer::SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period)
  {
   if(symbol==NULL) m_symbol=ChartSymbol();
   else             m_symbol=symbol;
   if(period==0)    m_period=ChartPeriod();
   else             m_period=period;
  }
//+------------------------------------------------------------------+
//| Class CiTickVolume.                                              |
//| Purpose: Class of tick volume series.                            |
//|          Derives from class CSeries.                             |
//+------------------------------------------------------------------+
class CiTickVolume : public CSeries
  {
public:
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   virtual bool      BufferResize(int size);
   //--- methods of access to data
   long              GetData(int index)                                             const;
   int               GetData(int start_pos,int count,long& buffer[])                const;
   int               GetData(datetime start_time,int count,long& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,long& buffer[]) const;
   //--- method of refreshing of the data
   virtual void      Refresh(int flags);
  };
//+------------------------------------------------------------------+
//| Creation of the tick volume series.                              |
//| INPUT:  symbol - series symbol,                                  |
//|         period - series period.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiTickVolume::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   CTickVolumeBuffer *buff;
//--- check history
   if(!SetSymbolPeriod(symbol,period))    return(false);
//--- create
   if((buff=new CTickVolumeBuffer)==NULL) return(false);
//--- add
   if(!Add(buff))
     {
      delete buff;
      return(false);
     }
//--- tune
   buff.SetSymbolPeriod(m_symbol,m_period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Method to access data.                                           |
//| INPUT:  index - position of element in the buffer.               |
//| OUTPUT: value of element if successful, 0 if not.                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CiTickVolume::GetData(int index) const
  {
   CTickVolumeBuffer *buff=At(0);
//--- checking
   if(buff==NULL)
     {
      Print("CiSpread::GetData: invalid buffer");
      return(0);
     }
//---
   return(buff.At(index));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the tick volume buffer by specifying  |
//| start position and number of elements".                          |
//| INPUT:  start_pos - position of start element in the buffer,     |
//|         count     - number of elements to copy,                  |
//|         buffer    - reference to a dynamic array of double       |
//|                     values.                                      |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiTickVolume::GetData(int start_pos,int count,long& buffer[]) const
  {
   return(CopyTickVolume(m_symbol,m_period,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the tick volume buffer by specifying  |
//| start time and number of elements".                              |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         count      - number of elements to copy,                 |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiTickVolume::GetData(datetime start_time,int count,long& buffer[]) const
  {
   return(CopyTickVolume(m_symbol,m_period,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the tick volume buffer by specifying  |
//| start and end time".                                             |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         stop_time  - time of end element in the buffer,          |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiTickVolume::GetData(datetime start_time,datetime stop_time,long& buffer[]) const
  {
   return(CopyTickVolume(m_symbol,m_period,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Set size buffer.                                                 |
//| INPUT:  size - size buffer.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiTickVolume::BufferResize(int size)
  {
   if(size>m_buffer_size && !CSeries::BufferResize(size)) return(false);
//-- history is avalible
   CTickVolumeBuffer *buff=At(0);
//--- check pointer
   if(buff==NULL) return(false);
//--
   buff.Size(size);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Refreshing of data.                                              |
//| INPUT:  flags - flags of updating timeframes.                    |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CiTickVolume::Refresh(int flags)
  {
   CTickVolumeBuffer *buff=At(0);
//--- checking
   if(buff==NULL) return;
//--- refreshing buffers
   if(!(flags&m_timeframe_flags))
     {
      if(m_refresh_current) buff.RefreshCurrent();
     }
   else                     buff.Refresh();
  }
//+------------------------------------------------------------------+
//| Class CRealVolumeBuffer.                                         |
//| Purpose: Class of buffer of real volume series.                  |
//|          Derives from class CArrayLong.                          |
//+------------------------------------------------------------------+
class CRealVolumeBuffer : public CArrayLong
  {
protected:
   string            m_symbol;           // symbol
   ENUM_TIMEFRAMES   m_period;           // period
   int               m_freshed_data;     // number of refreshed data
   int               m_size;             // size of used history

public:
                     CRealVolumeBuffer();
   //--- methods of access to protected data
   void              Size(int size) { m_size=size; }
   //--- methods of access to data
   long              At(int index) const;
   //--- method of refreshing of the data buffer
   virtual bool      Refresh();
   virtual bool      RefreshCurrent();
   //--- methods of tuning
   void              SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period);
  };
//+------------------------------------------------------------------+
//| Constructor CRealVolumeBuffer.                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CRealVolumeBuffer::CRealVolumeBuffer()
  {
//--- initialize protected data
   m_size=DEFAULT_BUFFER_SIZE;
   ArraySetAsSeries(m_data,true);
  }
//+------------------------------------------------------------------+
//| Access to data in a position.                                    |
//| INPUT:  index - position of element.                             |
//| OUTPUT: element in the position, or 0.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CRealVolumeBuffer::At(int index) const
  {
//--- checking
   if(index>=m_data_total) return(0);
//---
   datetime d=(datetime)CArrayLong::At(index);
//---
   return(d);
  }
//+------------------------------------------------------------------+
//| Refreshing of data buffer.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CRealVolumeBuffer::Refresh()
  {
   m_freshed_data=CopyRealVolume(m_symbol,m_period,0,m_size,m_data);
//---
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
bool CRealVolumeBuffer::RefreshCurrent()
  {
   long array[1];
//---
   m_freshed_data=CopyRealVolume(m_symbol,m_period,0,1,m_data);
//---
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
void CRealVolumeBuffer::SetSymbolPeriod(string symbol,ENUM_TIMEFRAMES period)
  {
   if(symbol==NULL) m_symbol=ChartSymbol();
   else             m_symbol=symbol;
   if(period==0)    m_period=ChartPeriod();
   else             m_period=period;
  }
//+------------------------------------------------------------------+
//| Class CiRealVolume.                                              |
//| Purpose: Class of real volume series.                            |
//|          Derives from class CSeries.                             |
//+------------------------------------------------------------------+
class CiRealVolume : public CSeries
  {
public:
   //--- method of creation
   bool              Create(string symbol,ENUM_TIMEFRAMES period);
   virtual bool      BufferResize(int size);
   //--- methods of access to data
   long              GetData(int index)                                             const;
   int               GetData(int start_pos,int count,long& buffer[])                const;
   int               GetData(datetime start_time,int count,long& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,long& buffer[]) const;
   //--- method of refreshing of the data
   virtual void      Refresh(int flags);
  };
//+------------------------------------------------------------------+
//| Creation of the real volume series.                              |
//| INPUT:  symbol - series symbol,                                  |
//|         period - series period.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiRealVolume::Create(string symbol,ENUM_TIMEFRAMES period)
  {
   CRealVolumeBuffer *buff;
//--- check history
   if(!SetSymbolPeriod(symbol,period))    return(false);
//--- create
   if((buff=new CRealVolumeBuffer)==NULL) return(false);
//--- add
   if(!Add(buff))
     {
      delete buff;
      return(false);
     }
//--- tune
   buff.SetSymbolPeriod(m_symbol,m_period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Method to access data.                                           |
//| INPUT:  index - position element of the buffer.                  |
//| OUTPUT: value -if successful, 0 otherwise.                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
long CiRealVolume::GetData(int index) const
  {
   CRealVolumeBuffer *buff=At(0);
//--- checking
   if(buff==NULL)
     {
      Print("CiSpread::GetData: invalid buffer");
      return(0);
     }
//---
   return(buff.At(index));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the real volume buffer by specifying  |
//| start position and number of elements".                          |
//| INPUT:  start_pos - position of start element in the buffer,     |
//|         count     - number of elements to copy,                  |
//|         buffer    - reference to a dynamic array of double       |
//|                     values.                                      |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiRealVolume::GetData(int start_pos,int count,long& buffer[]) const
  {
   return(CopyRealVolume(m_symbol,m_period,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the real volume buffer by specifying  |
//| start time and number of elements".                              |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         count      - number of elements to copy,                 |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiRealVolume::GetData(datetime start_time,int count,long& buffer[]) const
  {
   return(CopyRealVolume(m_symbol,m_period,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the real volume buffer by specifying  |
//| start and end time".                                             |
//| INPUT:  start_time - time of start element in the buffer,        |
//|         stop_time  - time of end element in the buffer,          |
//|         buffer     - reference to a dynamic array of double      |
//|                      values.                                     |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CiRealVolume::GetData(datetime start_time,datetime stop_time,long& buffer[]) const
  {
   return(CopyRealVolume(m_symbol,m_period,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Set size buffer.                                                 |
//| INPUT:  size - size buffer.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CiRealVolume::BufferResize(int size)
  {
   if(size>m_buffer_size && !CSeries::BufferResize(size)) return(false);
//-- history is avalible
   CRealVolumeBuffer *buff=At(0);
//--- check pointer
   if(buff==NULL) return(false);
//--
   buff.Size(size);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Refreshing of data.                                              |
//| INPUT:  flags - flags of updating timeframes.                    |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CiRealVolume::Refresh(int flags)
  {
   CRealVolumeBuffer *buff=At(0);
//--- checking
   if(buff==NULL) return;
//--- refreshing buffers
   if(!(flags&m_timeframe_flags))
     {
      if(m_refresh_current) buff.RefreshCurrent();
     }
   else                     buff.Refresh();
  }
//+------------------------------------------------------------------+
