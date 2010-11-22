//+------------------------------------------------------------------+
//|                                             ChartObjectsGann.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
//| All Gann tools.                                                  |
//+------------------------------------------------------------------+
#include "ChartObjectsLines.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectGannLine.                                      |
//| Purpose: Class of the "Gann Line" object of chart.               |
//|          Derives from class CChartObjectTrendByAngle.            |
//+------------------------------------------------------------------+
class CChartObjectGannLine : public CChartObjectTrendByAngle
  {
public:
   //--- methods of access to properties of the object
   double            PipsPerBar() const;
   bool              PipsPerBar(double ppb);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double ppb);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_GANNLINE); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Gann Line".                                       |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         ppb      - scale.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannLine::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double ppb)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_GANNLINE,window,time1,price1,time2,0.0);
//---
   if(result)
     {
      result&=Attach(chart_id,name,window,2);
      result&=PipsPerBar(ppb);
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get value of the "PipsPerBar" property.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "PipsPerBar" property.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObjectGannLine::PipsPerBar() const
  {
//--- checking
   if(m_chart_id==-1) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE));
  }
//+------------------------------------------------------------------+
//| Set value for the "PipsPerBar" property.                          |
//| INPUT:  ppb - new value for the "PipsPerBar" property.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannLine::PipsPerBar(double ppb)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,ppb));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing file.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannLine::Save(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObjectTrend::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "PipsPerBar"
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE))!=sizeof(double)) return(false);
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
bool CChartObjectGannLine::Load(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObjectTrend::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "PipsPerBar" property
      if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,FileReadDouble(file_handle))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectGannFan.                                       |
//| Purpose: Class of the "Gann Fan" object of chart.                |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectGannFan : public CChartObjectTrend
  {
public:
   //--- methods of access to properties of the object
   double            PipsPerBar() const;
   bool              PipsPerBar(double ppb);
   bool              Downtrend() const;
   bool              Downtrend(bool downtrend);
   //--- method of create the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double ppb);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_GANNFAN); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Gann Fan".                                        |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         ppb      - scale.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannFan::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double ppb)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_GANNFAN,window,time1,price1,time2,0.0);
//---
   if(result)
     {
      result&=Attach(chart_id,name,window,2);
      result&=PipsPerBar(ppb);
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get value of the "PipsPerBar" property.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "PipsPerBar" property.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObjectGannFan::PipsPerBar() const
  {
//--- checking
   if(m_chart_id==-1) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE));
  }
//+------------------------------------------------------------------+
//| Set value for the "PipsPerBar" property.                         |
//| INPUT:  ppb - new value for the "PipsPerBar" property.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannFan::PipsPerBar(double ppb)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,ppb));
  }
//+------------------------------------------------------------------+
//| Get value of the "Downtrend" property.                           |
//| INPUT:  no.                                                      |
//| OUTPUT: value of "Downtrend" property.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannFan::Downtrend() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_DIRECTION));
  }
//+------------------------------------------------------------------+
//| Set value for the "Downtrend" property.                          |
//| INPUT:  new_ray - new value for the "Downtrend" property.        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannFan::Downtrend(bool downtrend)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_DIRECTION,downtrend));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannFan::Save(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObjectTrend::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "PipsPerBar" property
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE))!=sizeof(double)) return(false);
      //--- writing value of the "Downtrend" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_DIRECTION),CHAR_VALUE)!=sizeof(char)) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Reading object parameters from file.                             |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannFan::Load(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObjectTrend::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "PipsPerBar"  property
      if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,FileReadDouble(file_handle))) return(false);
      //--- reading value of the "Downtrend"  property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_DIRECTION,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectGannGrid.                                      |
//| Purpose: Class of the "Gann Grid" object of chart.               |
//|          Derives from class CChartObjectTrend.                   |
//+------------------------------------------------------------------+
class CChartObjectGannGrid : public CChartObjectTrend
  {
public:
   //--- methods of access to properties of the object
   double            PipsPerBar() const;
   bool              PipsPerBar(double ppb);
   bool              Downtrend() const;
   bool              Downtrend(bool downtrend);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double ppb);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_GANNGRID); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Gann Grid".                                       |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         ppb      - scale.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannGrid::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double ppb)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_GANNGRID,window,time1,price1,time2,0.0);
//---
   if(result)
     {
      result&=Attach(chart_id,name,window,2);
      result&=PipsPerBar(ppb);
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get value of the"PipsPerBar" property.                           |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "PipsPerBar" property.                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObjectGannGrid::PipsPerBar() const
  {
//--- checking
   if(m_chart_id==-1) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE));
  }
//+------------------------------------------------------------------+
//| Set value for the "PipsPerBar" property.                         |
//| INPUT:  ppb - new value for the "PipsPerBar" property.           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannGrid::PipsPerBar(double ppb)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,ppb));
  }
//+------------------------------------------------------------------+
//| Get the property value "Downtrend".                              |
//| INPUT:  no.                                                      |
//| OUTPUT: the property value "Downtrend".                          |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannGrid::Downtrend() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_DIRECTION));
  }
//+------------------------------------------------------------------+
//| Set the property value "Downtrend".                              |
//| INPUT:  new_ray -new the property value "Downtrend".             |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannGrid::Downtrend(bool downtrend)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_DIRECTION,downtrend));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannGrid::Save(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObjectTrend::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "PipsPerBar" property
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE))!=sizeof(double)) return(false);
      //--- writing value of the "Downtrend" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_DIRECTION),CHAR_VALUE)!=sizeof(char)) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Reading paprameters of object from file.                         |
//| INPUT:  file_handle - handle of fiel previously opened           |
//|         for reading.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectGannGrid::Load(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObjectTrend::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "PipsPerBar" property
      if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,FileReadDouble(file_handle))) return(false);
      //--- reading value of the "Downtrend" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_DIRECTION,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
