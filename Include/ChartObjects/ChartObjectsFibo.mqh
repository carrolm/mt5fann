//+------------------------------------------------------------------+
//|                                             ChartObjectsFibo.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
//| All Fibonacci tools.                                             |
//+------------------------------------------------------------------+
#include "ChartObjectsLines.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectFibo.                                          |
//| Purpose: Class of the "Fibonacci Lines" object.                  |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectFibo : public CChartObjectTrend
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_FIBO); }
  };
//+------------------------------------------------------------------+
//| Create object "Fibonacci Lines".                                 |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate.                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFibo::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_FIBO,window,time1,price1,time2,price2);
//---
   if(result) result&=Attach(chart_id,name,window,2);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectFiboTimes.                                     |
//| Purpose: Class of the "Fibonacci Time Zones" object of chart     |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectFiboTimes : public CChartObject
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_FIBOTIMES); }
  };
//+------------------------------------------------------------------+
//| Create object "Fibonacci Time Zones".                            |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate.                      |
//| OUTPUT: true if successful, false if not .                       |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFiboTimes::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_FIBOTIMES,window,time1,price1,time2,price2);
//---
   if(result) result&=Attach(chart_id,name,window,2);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectFiboFan.                                       |
//| Purpose: Class of the "Fibonacci Fan" object of chart.           |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectFiboFan : public CChartObject
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_FIBOFAN); }
  };
//+------------------------------------------------------------------+
//| Create object "Fibonacci Fan".                                   |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate.                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFiboFan::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_FIBOFAN,window,time1,price1,time2,price2);
//---
   if(result) result&=Attach(chart_id,name,window,2);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectFiboArc.                                       |
//| Purpose: Class of the "Fibonacci Arcs" object of chart.          |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectFiboArc : public CChartObject
  {
public:
   //--- methods of access to properties of the object
   double            Scale() const;
   bool              Scale(double scale);
   bool              Ellipse() const;
   bool              Ellipse(bool ellipse);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,double scale);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_FIBOARC); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Fibonacci Arcs".                                  |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate,                      |
//|         scale    - scale.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFiboArc::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,double scale)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_FIBOARC,window,time1,price1,time2,price2);
//---
   if(result)
     {
      result&=Attach(chart_id,name,window,2);
      result&=Scale(scale);
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get value of the "Scale" property.                               |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "Scale" property.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObjectFiboArc::Scale() const
  {
//--- checking
   if(m_chart_id==-1) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE));
  }
//+------------------------------------------------------------------+
//| Set value for the "Scale" property.                              |
//| INPUT:  scale - new value of the "Scale" property.               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFiboArc::Scale(double scale)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,scale));
  }
//+------------------------------------------------------------------+
//| Get value of the "Ellipse" property.                             |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "Ellipse" property.                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFiboArc::Ellipse() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_ELLIPSE));
  }
//+------------------------------------------------------------------+
//| Set value for the "Ellipse" property.                            |
//| INPUT:  new_ray - new value for the "Ellipse" property.          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFiboArc::Ellipse(bool ellipse)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_ELLIPSE,ellipse));
  }
//+------------------------------------------------------------------+
//| Writing parameter of object to file.                             |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing file.                                        |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFiboArc::Save(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObject::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "Scale" property
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE))!=sizeof(double)) return(false);
      //--- writing value of the "Ellipse" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_ELLIPSE),CHAR_VALUE)!=sizeof(char)) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Reading parameters of object from file.                          |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading file.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectFiboArc::Load(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObject::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "Scale" property
      if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,FileReadDouble(file_handle))) return(false);
      //--- reading value of the "Ellipse" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_ELLIPSE,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectFiboChannel.                                   |
//| Purpose: Class of the "Fibonacci Channel" object of chart.       |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectFiboChannel : public CChartObjectTrend
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_FIBOCHANNEL); }
  };
//+------------------------------------------------------------------+
//| Create object "Fibonacci Channel".                               |
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
bool CChartObjectFiboChannel::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_FIBOCHANNEL,window,time1,price1,time2,price2,time3,price3);
//---
   if(result) result&=Attach(chart_id,name,window,3);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectFiboExpansion.                                 |
//| Purpose: Class of the "Fibonacci Expansion" object.              |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectFiboExpansion : public CChartObjectTrend
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_EXPANSION); }
  };
//+------------------------------------------------------------------+
//| Create object "Fibonacci Expansion".                             |
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
bool CChartObjectFiboExpansion::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_EXPANSION,window,time1,price1,time2,price2,time3,price3);
//---
   if(result) result&=Attach(chart_id,name,window,3);
//---
   return(result);
  }
//+------------------------------------------------------------------+
