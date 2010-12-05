//+------------------------------------------------------------------+
//|                                         ChartObjectsChannels.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
//| All channels.                                                    |
//+------------------------------------------------------------------+
#include "ChartObjectsLines.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectChannel.                                       |
//| Purpose: Class of the "Equidistant channel" object of chart.     |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectChannel : public CChartObjectTrend
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_CHANNEL); }
  };
//+------------------------------------------------------------------+
//| Create object "Equidistant channel".                             |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate,                      |
//|         time3    - third time coordinate,                        |
//|         price3   - third price coordinate.                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectChannel::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_CHANNEL,window,time1,price1,time2,price2,time3,price3);
   if(result) result&=Attach(chart_id,name,window,3);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectStdDevChannel.                                 |
//| Purpose: Class of the "Standrad deviation channel"               |
//|          object of chart.                                        |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectStdDevChannel : public CChartObjectTrend
  {
public:
   //--- methods of access to properties of the object
   double            Deviations() const;
   bool              Deviations(double deviation);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,datetime time2,double deviation);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_STDDEVCHANNEL); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Standard deviation channel".                      |
//| INPUT:  chart_id  - chart identifier,                            |
//|         name      - object name,                                 |
//|         window    - subwindow number,                            |
//|         time1     - first time coordinate,                       |
//|         time2     - second time coordinate,                      |
//|         deviation - deviation.                                   |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectStdDevChannel::Create(long chart_id,string name,int window,datetime time1,datetime time2,double deviation)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_STDDEVCHANNEL,window,time1,0.0,time2,0.0);
   if(result)
     {
      result&=Attach(chart_id,name,window,2);
      result&=Deviations(deviation);
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get value of the "Deviations" property.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "Deviations" property.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObjectStdDevChannel::Deviations() const
  {
//--- checking
   if(m_chart_id==-1) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_DEVIATION));
  }
//+------------------------------------------------------------------+
//| Set value for the "Deviations" property.                         |
//| INPUT:  deviations - new value for the "Deviations" property.    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectStdDevChannel::Deviations(double deviation)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_DEVIATION,deviation));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing file.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectStdDevChannel::Save(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObjectTrend::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "Deviations" property
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_DEVIATION))!=sizeof(double)) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Reading parameters of object from file.                          |
//| INPUT:  file_handle - handle of previously opened                |
//|         for reading file.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectStdDevChannel::Load(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObjectTrend::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "Deviations" property
      if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_DEVIATION,FileReadDouble(file_handle))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectRegression.                                    |
//| Purpose: Class of the "Regression channel" object of chart.      |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectRegression : public CChartObjectTrend
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,datetime time2);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_REGRESSION); }
  };
//+------------------------------------------------------------------+
//| Create object "Regression channel".                              |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         time2    - second time coordinate.                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectRegression::Create(long chart_id,string name,int window,datetime time1,datetime time2)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_REGRESSION,window,time1,0.0,time2,0.0);
   if(result) result&=Attach(chart_id,name,window,2);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectPitchfork.                                     |
//| Purpose: Class of the "Andrews pitchfork" object of chart        |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectPitchfork : public CChartObjectTrend
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_CHANNEL); }
  };
//+------------------------------------------------------------------+
//| Create object "Andrews pitchfork".                               |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate,                      |
//|         time3    - third time coordinate,                        |
//|         price3   - third price coordinate.                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectPitchfork::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_PITCHFORK,window,time1,price1,time2,price2,time3,price3);
   if(result) result&=Attach(chart_id,name,window,3);
//---
   return(result);
  }
//+------------------------------------------------------------------+
