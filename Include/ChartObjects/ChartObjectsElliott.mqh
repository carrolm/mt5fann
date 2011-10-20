//+------------------------------------------------------------------+
//|                                          ChartObjectsElliott.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
//| All Elliott tools.                                               |
//+------------------------------------------------------------------+
#include "ChartObject.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectElliottWave3.                                  |
//| Purpose: Class of the "ElliottCorrectiveWave" object of chart.   |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectElliottWave3 : public CChartObject
  {
public:
   //--- methods of access to properties of the object
   ENUM_ELLIOT_WAVE_DEGREE Degree() const;
   bool              Degree(ENUM_ELLIOT_WAVE_DEGREE degree);
   bool              Lines() const;
   bool              Lines(bool lines);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ELLIOTWAVE3); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "ElliottCorrectiveWave".                           |
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
bool CChartObjectElliottWave3::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ELLIOTWAVE3,window,time1,price1,time2,price2,time3,price3);
//---
   if(result) result&=Attach(chart_id,name,window,3);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get value of the "Degree" property.                              |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "Degree" property.                          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_ELLIOT_WAVE_DEGREE CChartObjectElliottWave3::Degree() const
  {
//--- checking
   if(m_chart_id==-1) return(WRONG_VALUE);
//---
   return((ENUM_ELLIOT_WAVE_DEGREE)ObjectGetInteger(m_chart_id,m_name,OBJPROP_DEGREE));
  }
//+------------------------------------------------------------------+
//| Set value for the "Degree" property.                             |
//| INPUT:  degree - new value for the "Degree" proeprty.            |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectElliottWave3::Degree(ENUM_ELLIOT_WAVE_DEGREE degree)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_DEGREE,degree));
  }
//+------------------------------------------------------------------+
//| Get value of the "Lines" property.                               |
//| INPUT:  no.                                                      |
//| OUTPUT: value of "Lines" property.                               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectElliottWave3::Lines() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_DRAWLINES));
  }
//+------------------------------------------------------------------+
//| Set value for the "Lines" property.                              |
//| INPUT:  lines - new value for the "Lines" property.              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectElliottWave3::Lines(bool lines)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_DRAWLINES,lines));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectElliottWave3::Save(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObject::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "Degree" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_DEGREE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "Lines" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_DRAWLINES),INT_VALUE)!=sizeof(int)) return(false);
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
bool CChartObjectElliottWave3::Load(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObject::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "Degree" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_DEGREE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "Lines" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_DRAWLINES,FileReadInteger(file_handle,INT_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectElliottWave5.                                  |
//| Purpose: Class of the "ElliottMotiveWave" object of chart.       |
//|          Derives from class CChartObjectElliottWave3    .        |
//+------------------------------------------------------------------+
class CChartObjectElliottWave5 : public CChartObjectElliottWave3
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3,datetime time4,double price4,datetime time5,double price5);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ELLIOTWAVE5); }
  };
//+------------------------------------------------------------------+
//| Create object "ElliottMotiveWave".                               |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate,                      |
//|         time3    - third time coordinate,                        |
//|         price3   - third price coordinate,                       |
//|         time4    - fourth time coordinate,                       |
//|         price4   - fourth pricecoordinate,                       |
//|         time5    - fifth time coordinate,                        |
//|         price5   - fifth price coordinate.                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectElliottWave5::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3,datetime time4,double price4,datetime time5,double price5)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ELLIOTWAVE5,window,time1,price1,time2,price2,time3,price3,time4,price4,time5,price5);
//---
   if(result) result&=Attach(chart_id,name,window,5);
//---
   return(result);
  }
//+------------------------------------------------------------------+
