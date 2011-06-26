//+------------------------------------------------------------------+
//|                                                    Indicator.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2011.06.09 |
//+------------------------------------------------------------------+
#include "Series.mqh"
//+------------------------------------------------------------------+
//| Class CIndicatorBuffer.                                          |
//| Purpose: Class for access to data of buffers of                  |
//|          technical indicators.                                   |
//|          Derives from class CDoubleBuffer.                       |
//+------------------------------------------------------------------+
class CIndicatorBuffer : public CDoubleBuffer
  {
protected:
   int               m_offset;           // shift along the time axis (in bars)
   string            m_name;             // name of buffer

public:
                     CIndicatorBuffer();
   //--- methods of access to protected data
   int               Offset()      const { return(m_offset); }
   void              Offset(int offset)  { m_offset=offset;  }
   string            Name()        const { return(m_name);   }
   void              Name(string name)   { m_name=name;      }
   //--- methods of access to data
   double            At(int index) const;
   //--- method of refreshing of data in buffer
   bool              Refresh(int handle,int num);
   bool              RefreshCurrent(int handle,int num);
  };
//+------------------------------------------------------------------+
//| Constructor CIndicatorBuffer.                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CIndicatorBuffer::CIndicatorBuffer()
  {
//--- initialize protected data
   m_size  =DEFAULT_BUFFER_SIZE;
   m_offset=0;
   m_name  ="";
   ArraySetAsSeries(m_data,true);
  }
//+------------------------------------------------------------------+
//| Access to data in a specified position.                          |
//| INPUT:  index - position of element.                             |
//| OUTPUT: element in the specified position or EMPTY_VALUE.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CIndicatorBuffer::At(int index) const
  {
   return(CDoubleBuffer::At(index+m_offset));
  }
//+------------------------------------------------------------------+
//| Refreshing of data in buffer.                                    |
//| INPUT:  handle - indicator handle,                               |
//|         num    - number of buffer of indicator.                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CIndicatorBuffer::Refresh(int handle,int num)
  {
//--- checking
   if(handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(false);
     }
//---
   m_data_total=CopyBuffer(handle,num,-m_offset,m_size,m_data);
//---
   return(m_data_total>0);
  }
//+------------------------------------------------------------------+
//| Refreshing of the data in buffer.                                |
//| INPUT:  handle - indicator handle,                               |
//|         num    - number of buffer of indicator.                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CIndicatorBuffer::RefreshCurrent(int handle,int num)
  {
   double array[1];
//--- checking
   if(handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(false);
     }
//---
   if(CopyBuffer(handle,num,-m_offset,1,array)>0 && m_data_total>0)
     {
      m_data[0]=array[0];
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Class CIndicator.                                                |
//| Purpose: Base class of technical indicators.                     |
//|          Derives from class CSeries.                             |
//+------------------------------------------------------------------+
class CIndicator : public CSeries
  {
protected:
   int               m_handle;           // indicator handle
   string            m_status;           // status of creation
   bool              m_full_release;     // flag

public:
                     CIndicator();
                    ~CIndicator();
   //--- methods of access to protected data
   int               Handle()         const { return(m_handle);    }
   string            Status()         const { return(m_status);    }
   void              FullRelease(bool flag) { m_full_release=flag; }
   //--- method for creating
   bool              Create(string symbol,ENUM_TIMEFRAMES period,ENUM_INDICATOR type,int num_params,MqlParam &params[]);
   virtual bool      BufferResize(int size);
   //--- methods of access to data
   double            GetData(int buffer_num,int index)                                               const;
   int               GetData(int start_pos,int count,int buffer_num,double& buffer[])                const;
   int               GetData(datetime start_time,int count,int buffer_num,double& buffer[])          const;
   int               GetData(datetime start_time,datetime stop_time,int buffer_num,double& buffer[]) const;
   //--- methods for find extremum
   int               Minimum(int buffer_num,int start,int count)             const;
   double            MinValue(int buffer_num,int start,int count,int& index) const;
   int               Maximum(int buffer_num,int start,int count)             const;
   double            MaxValue(int buffer_num,int start,int count,int& index) const;
   //--- method of "freshening" of the data
   virtual void      Refresh(int flags);
   //--- methods of conversion of constants to strings
   string            MethodDescription(int val) const;
   string            PriceDescription(int val)  const;
   string            VolumeDescription(int val) const;

protected:
   //--- methods of tuning
   bool              CreateBuffers(string symbol,ENUM_TIMEFRAMES period,int buffers);
   virtual bool      Initialize(string symbol,ENUM_TIMEFRAMES period,int num_params,MqlParam &params[]) {return(false);}
  };
//+------------------------------------------------------------------+
//| Constructor CIndicator.                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CIndicator::CIndicator()
  {
//--- initialize protected data
   m_handle      =INVALID_HANDLE;
   m_status      ="";
   m_full_release=false;
  }
//+------------------------------------------------------------------+
//| Destructor CIndicator.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CIndicator::~CIndicator()
  {
//--- indicator handle release
   if(m_full_release && m_handle!=INVALID_HANDLE)
     {
      IndicatorRelease(m_handle);
      m_handle=INVALID_HANDLE;
     }
  }
//+------------------------------------------------------------------+
//| Creation of the indicator with universal parameters.             |
//| INPUT:  symbol    - indicator symbol,                            |
//|         period    - indicator period,                            |
//|         type      - indicator type,                              |
//|         num_param - number of parameters,                        |
//|         params    - array of parameters.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CIndicator::Create(string symbol,ENUM_TIMEFRAMES period,ENUM_INDICATOR type,int num_params,MqlParam &params[])
  {
//--- check history
   if(!SetSymbolPeriod(symbol,period)) return(false);
//--- create
   m_handle=IndicatorCreate(symbol,period,type,num_params,params);
//--- check result
   if(m_handle==INVALID_HANDLE)        return(false);
//--- idicator successfully created
   if(!Initialize(symbol,period,num_params,params))
     {
      //--- initialization failed
      IndicatorRelease(m_handle);
      m_handle=INVALID_HANDLE;
      return(false);
     }
//--- ok
  return(true);
  }
//+------------------------------------------------------------------+
//| API access method "Copying an element of indicator buffer        |
//| by specifying number of buffer and position of element".         |        
//| INPUT:  buffer_num - buffer number,                              |
//|         index      - position of element in the buffer.          |
//| OUTPUT: value of element if successful, EMPTY_VALUE if not.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CIndicator::GetData(int buffer_num,int index) const
  {
   CIndicatorBuffer *buffer=At(buffer_num);
//--- checking
   if(buffer==NULL)
     {
      Print("CIndicator::GetData: invalid buffer");
      return(EMPTY_VALUE);
     }
//---
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the buffer of indicator by specifying |
//| a start position and number of elements".                        |
//| INPUT:  start_pos  - position of start element in the buffer,    |
//|         count      - number of elements to be copied,            |
//|         buffer_num - buffer number,                              |
//|         buffer     - reference to a dynamic array of             |
//|                      double values.                              |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CIndicator::GetData(int start_pos,int count,int buffer_num,double& buffer[]) const
  {
//--- checking
   if(m_handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(-1);
     }
   if(buffer_num>=m_buffers_total)
     {
      SetUserError(ERR_USER_INVALID_BUFF_NUM);
      return(-1);
     }
//---
   return(CopyBuffer(m_handle,buffer_num,start_pos,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the buffer of indicator by specifying |
//| start time and number of elements".                              |
//| INPUT:  start_time - time of start element of the buffer,        |
//|         count      - number of elements to be copied,            |
//|         buffer_num - buffer number,                              |
//|         buffer     - reference to a dynamic array of             |
//|                      double values.                              |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CIndicator::GetData(datetime start_time,int count,int buffer_num,double& buffer[]) const
  {
//--- checking
   if(m_handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(-1);
     }
   if(buffer_num>=m_buffers_total)
     {
      SetUserError(ERR_USER_INVALID_BUFF_NUM);
      return(-1);
     }
//---
   return(CopyBuffer(m_handle,buffer_num,start_time,count,buffer));
  }
//+------------------------------------------------------------------+
//| API access method "Copying the buffer of indicator by specifying |
//| start and end time.                                              |
//| and final time".                                                 |
//| INPUT:  start_time - time of start element of the buffer,        |
//|         stop_time  - time of end element of the buffer,          |
//|         buffer_num - buffer number,                              |
//|         buffer     - reference to a dynamic array of             |
//|                      double values.                              |
//| OUTPUT: >=0 if successful, -1 if not.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CIndicator::GetData(datetime start_time,datetime stop_time,int buffer_num,double& buffer[]) const
  {
//--- checking
   if(m_handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(-1);
     }
   if(buffer_num>=m_buffers_total)
     {
      SetUserError(ERR_USER_INVALID_BUFF_NUM);
      return(-1);
     }
//---
   return(CopyBuffer(m_handle,buffer_num,start_time,stop_time,buffer));
  }
//+------------------------------------------------------------------+
//| Find minimum of a specified buffer.                              |
//| INPUT:  buffer_num - buffer number,                              |
//|         start      - start element for searching,                |
//|         count      - size of search interval.                    |
//| OUTPUT: position of element, or -1.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CIndicator::Minimum(int buffer_num,int start,int count) const
  {
//--- checking
   if(m_handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(-1);
     }
   if(buffer_num>=m_buffers_total)
     {
      SetUserError(ERR_USER_INVALID_BUFF_NUM);
      return(-1);
     }
//---
   CIndicatorBuffer *buffer=At(buffer_num);
   if(buffer==NULL) return(-1);
//---
   return(buffer.Minimum(start,count));
  }
//+------------------------------------------------------------------+
//| Find minimum of a specified buffer.                              |
//| INPUT:  buffer_num - buffer number,                              |
//|         start      - start element for searching,                |
//|         count      - number of elements,                         |
//|         index      - reference to variable for the value         |
//|                      of index.                                   |
//| OUTPUT: value of element, or EMPTY_VALUE.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CIndicator::MinValue(int buffer_num,int start,int count,int& index) const
  {
   int    idx=Minimum(buffer_num,start,count);
   double res=EMPTY_VALUE;
//--- checking
   if(idx!=-1)
     {
      CIndicatorBuffer *buffer=At(buffer_num);
      res=buffer.At(idx);
      index=idx;
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Find maximum of a specified buffer.                              |
//| INPUT:  buffer_num - buffer number,                              |
//|         start      - start element for searching,                |
//|         count      - number of elements.                         |
//| OUTPUT: position of element, or -1.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CIndicator::Maximum(int buffer_num,int start,int count) const
  {
//--- checking
   if(m_handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(-1);
     }
   if(buffer_num>=m_buffers_total)
     {
      SetUserError(ERR_USER_INVALID_BUFF_NUM);
      return(-1);
     }
//---
   CIndicatorBuffer *buffer=At(buffer_num);
   if(buffer==NULL) return(-1);
//---
   return(buffer.Maximum(start,count));
  }
//+------------------------------------------------------------------+
//| Find maximum of specified buffer.                                |
//| INPUT:  buffer_num - buffer number,                              |
//|         start      - start element for searching,                |
//|         count      - number of elements,                         |
//|         index      - reference to variable for the value         |
//|                      of index.                                   |
//| OUTPUT: value of element, or EMPTY_VALUE.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CIndicator::MaxValue(int buffer_num,int start,int count,int& index) const
  {
   int    idx=Maximum(buffer_num,start,count);
   double res=EMPTY_VALUE;
//--- checking
   if(idx!=-1)
     {
      CIndicatorBuffer *buffer=At(buffer_num);
      res=buffer.At(idx);
      index=idx;
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Creating data buffers of indicator.                              |
//| INPUT:  symbol  - symbol,                                        |
//|         period  - period,                                        |
//|         buffers - number of buffers.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CIndicator::CreateBuffers(string symbol,ENUM_TIMEFRAMES period,int buffers)
  {
   bool result=true;
//--- checking
   if(m_handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(false);
     }
   if(buffers==0)        return(false);
   if(!Reserve(buffers)) return(false);
//---
   for(int i=0;i<buffers;i++)
      result&=Add(new CIndicatorBuffer);
//---
   if(result)
      m_buffers_total=buffers;
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Set size of buffers of indicator.                                |
//| INPUT:  size - size of buffers.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CIndicator::BufferResize(int size)
  {
   if(size>m_buffer_size && !CSeries::BufferResize(size)) return(false);
//-- history is avalible
   int total=Total();
   for(int i=0;i<total;i++)
     {
      CIndicatorBuffer *buff=At(i);
      //--- check pointer
      if(buff==NULL) return(false);
      buff.Size(size);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Refreshing data of indicator.                                    |
//| INPUT:  flags - flags of updating of timeframes.                 |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CIndicator::Refresh(int flags)
  {
   int               i;
   CIndicatorBuffer *buff;
//--- refreshing buffers
   for(i=0;i<Total();i++)
     {
      buff=At(i);
      if(!(flags&m_timeframe_flags))
        {
         if(m_refresh_current) buff.RefreshCurrent(m_handle,i);
        }
      else                     buff.Refresh(m_handle,i);
     }
  }
//+------------------------------------------------------------------+
//| Converting value of ENUM_MA_METHOD into string                   |
//| INPUT:  val - value for conversion.                              |
//| OUTPUT: conversion result.                                       |
//| REMARK: the parameter val has the int type for the               |
//|         possibility of transmission of error values.             |
//+------------------------------------------------------------------+
string CIndicator::MethodDescription(int val) const
  {
   string str;
//--- array for conversion of ENUM_MA_METHOD to string
   static string _m_str[]={"SMA","EMA","SMMA","LWMA"};
//--- checking
   if(val<0) return("ERROR");
//---
   if(val<4) str=_m_str[val];
   else      if(val<10) str="METHOD_UNKNOWN="+IntegerToString(val);
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Converting value of ENUM_APPLIED_PRICE into string.              |
//| INPUT:  val - value for conversion.                              |
//| OUTPUT: conversion result.                                       |
//| REMARK: the parameter val has the int type for the               |
//|         possibility of transmission of error values.             |
//+------------------------------------------------------------------+
string CIndicator::PriceDescription(int val) const
  {
   string str;
//--- array for conversion of ENUM_APPLIED_PRICE to string
   static string _a_str[]={"Close","Open","High","Low","Median","Typical","Weighted"};
//--- checking
   if(val<0) return("Unknown");
//---
   if(val<7)
      str=_a_str[val];
   else
     {
      if(val<10) str="PriceUnknown="+IntegerToString(val);
      else       str="AppliedHandle="+IntegerToString(val);
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Converting value of ENUM_APPLIED_VOLUME into string.             |
//| INPUT:  val - value for conversion.                              |
//| OUTPUT: conversion result.                                       |
//| REMARK: the parameter val has the int type for the               |
//|         possibility of transmission of error values.             |
//+------------------------------------------------------------------+
string CIndicator::VolumeDescription(int val) const
  {
   string str;
//--- array for conversion of ENUM_APPLIED_VOLUME to string
   static string _v_str[]={"None","Tick","Real"};
//--- checking
   if(val<0) return("Unknown");
//---
   if(val<3)
      str=_v_str[val];
   else
     {
      if(val<10) str="VolumeUnknown="+IntegerToString(val);
      else       str="AppliedHandle="+IntegerToString(val);
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
