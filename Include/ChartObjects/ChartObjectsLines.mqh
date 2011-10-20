//+------------------------------------------------------------------+
//|                                            ChartObjectsLines.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
//| All lines.                                                       |
//+------------------------------------------------------------------+
#include "ChartObject.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectVLine.                                         |
//| Purpose: Class of the "Vertical line" object of chart.           |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectVLine : public CChartObject
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_VLINE); }
  };
//+------------------------------------------------------------------+
//| Create object "Vertical line".                                   |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate.                              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectVLine::Create(long chart_id,string name,int window,datetime time)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_VLINE,window,time,0.0);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectHLine.                                         |
//| Purpose: Class of the "Horizontal line" object of chart.         |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectHLine : public CChartObject
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_HLINE); }
  };
//+------------------------------------------------------------------+
//| Create object "Horizontal line".                                 |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectHLine::Create(long chart_id,string name,int window,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_HLINE,window,0,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectTrend.                                         |
//| Purpose: Class of the "Trendline" object of chart.               |
//|          Derives from class CChartObject.                        |
//| It is the parent class for all objects that have properties      |
//| RAY_LEFT and RAY_RIGHT.                                          |
//+------------------------------------------------------------------+
class CChartObjectTrend : public CChartObject
  {
public:
   //--- methods of access to properties of the object
   bool              RayLeft() const;
   bool              RayLeft(bool new_sel);
   bool              RayRight() const;
   bool              RayRight(bool new_sel);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_TREND); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Trendline".                                       |
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
bool CChartObjectTrend::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_TREND,window,time1,price1,time2,price2);
   if(result) result&=Attach(chart_id,name,window,2);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get the "Ray left" flag.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: the "Ray left" flag.                                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectTrend::RayLeft() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_RAY_LEFT));
  }
//+------------------------------------------------------------------+
//| Set the "Ray left" flag.                                         |
//| INPUT:  new_ray - new flag "Ray left".                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectTrend::RayLeft(bool new_ray)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_RAY_LEFT,new_ray));
  }
//+------------------------------------------------------------------+
//| Get the "Ray right" flag.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the "Ray right" flag.                                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectTrend::RayRight() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_RAY_RIGHT));
  }
//+------------------------------------------------------------------+
//| Set the "Ray right" flag.                                        |
//| INPUT:  new_ray - new flag "Ray right".                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectTrend::RayRight(bool new_ray)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_RAY_RIGHT,new_ray));
  }
//+------------------------------------------------------------------+
//| Writing parameters of objject to file.                           |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectTrend::Save(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObject::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "Ray left" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_RAY_LEFT),CHAR_VALUE)!=sizeof(char)) return(false);
      //--- writing value of the "Ray right" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_RAY_RIGHT),CHAR_VALUE)!=sizeof(char)) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Reading parameters of object from file.                          |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectTrend::Load(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObject::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "Ray left" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_RAY_LEFT,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
      //--- reading value of the "Ray right" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_RAY_RIGHT,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectTrendByAngle.                                  |
//| Puprose: Class of the "Trendline by angle" object of chart.      |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectTrendByAngle : public CChartObjectTrend
  {
public:
   //--- methods of access to properties of the object
   double            Angle() const;
   bool              Angle(double angle);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2);
   //--- method of identifying the object
   virtual int       Type() { return(OBJ_TRENDBYANGLE); }
  };
//+------------------------------------------------------------------+
//| Create object "Trendline by angle".                              |
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
bool CChartObjectTrendByAngle::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_TRENDBYANGLE,window,time1,price1,time2,price2);
//---
   if(result) result&=Attach(chart_id,name,window,2);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get the "Angle" property.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: the "Angle" property.                                    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObjectTrendByAngle::Angle() const
  {
//--- checking
   if(m_chart_id==-1) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_ANGLE));
  }
//+------------------------------------------------------------------+
//| Set the "Angle" property.                                        |
//| INPUT:  angle - new value of the "Angle" property.               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectTrendByAngle::Angle(double angle)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_ANGLE,angle));
  }
//+------------------------------------------------------------------+
//| Class CChartObjectCycles.                                        |
//| Purpose: Class of the "Cycle lines" object of chart.             |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectCycles : public CChartObject
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_TREND); }
  };
//+------------------------------------------------------------------+
//| Create object "Cycle lines".                                     |
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
bool CChartObjectCycles::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_CYCLES,window,time1,price1,time2,price2);
//---
   if(result) result&=Attach(chart_id,name,window,2);
//---
   return(result);
  }
//+------------------------------------------------------------------+
