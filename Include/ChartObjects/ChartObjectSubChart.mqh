//+------------------------------------------------------------------+
//|                                          ChartObjectSubChart.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
#include "ChartObject.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectSubChart.                                      |
//| Purpose: Class of the "SubChart" object of chart.                |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectSubChart : public CChartObject
  {
public:
   //--- methods of access to properties of the object
   int               X_Distance() const;
   bool              X_Distance(int X);
   int               Y_Distance() const;
   bool              Y_Distance(int Y);
   ENUM_BASE_CORNER  Corner() const;
   bool              Corner(ENUM_BASE_CORNER corner);
   int               X_Size() const;
   bool              X_Size(int size);
   int               Y_Size() const;
   bool              Y_Size(int size);
   string            Symbol() const;
   bool              Symbol(string symbol);
   int               Period() const;
   bool              Period(int period);
   int               Scale() const;
   bool              Scale(int scale);
   bool              DateScale() const;
   bool              DateScale(bool scale);
   bool              PriceScale() const;
   bool              PriceScale(bool scale);
   //--- change of time/price coordinates is blocked
   bool              Time(datetime time) { return(false); }
   bool              Price(double price) { return(false); }
   //--- method of creating object
   bool              Create(long chart_id,string name,int window,int X,int Y,int sizeX,int sizeY);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_CHART); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "SubChart".                                        |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         X        - X-distance from anchor point to base corner,  |
//|         Y        - Y-distance from anchor point to base corner,  |
//|         sizeX    - X-size,                                       |
//|         sizeY    - Y-size.                                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::Create(long chart_id,string name,int window,int X,int Y,int sizeX,int sizeY)
  {
   bool result=ObjectCreate(chart_id,name,(ENUM_OBJECT)Type(),window,0,0,0);
//---
   if(result) result&=Attach(chart_id,name,window,1);
   result&=X_Distance(X);
   result&=Y_Distance(Y);
   result&=X_Size(sizeX);
   result&=Y_Size(sizeY);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get the X-distance.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: X-distance.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectSubChart::X_Distance() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE));
  }
//+------------------------------------------------------------------+
//| Set the X-distance.                                              |
//| INPUT:  X - new X-distance.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::X_Distance(int X)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE,X));
  }
//+------------------------------------------------------------------+
//| Get the Y-distance.                                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: Y-distance.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectSubChart::Y_Distance() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YDISTANCE));
  }
//+------------------------------------------------------------------+
//| Set the Y-distance.                                              |
//| INPUT:  Y - new Y-distance.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::Y_Distance(int Y)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_YDISTANCE,Y));
  }
//+------------------------------------------------------------------+
//| Get base corner.                                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: base corner.                                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_BASE_CORNER CChartObjectSubChart::Corner() const
  {
//--- checking
   if(m_chart_id==-1) return(WRONG_VALUE);
//---
   return((ENUM_BASE_CORNER)ObjectGetInteger(m_chart_id,m_name,OBJPROP_CORNER));
  }
//+------------------------------------------------------------------+
//| Set base corner.                                                 |
//| INPUT:  corner - new base corner.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::Corner(ENUM_BASE_CORNER corner)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_CORNER,corner));
  }
//+------------------------------------------------------------------+
//| Get the X-size.                                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: X-size.                                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectSubChart::X_Size() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XSIZE));
  }
//+------------------------------------------------------------------+
//| Set X-size.                                                      |
//| INPUT:  size - new X-size.                                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::X_Size(int size)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_XSIZE,size));
  }
//+------------------------------------------------------------------+
//| Get the Y-size.                                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: Y-size.                                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectSubChart::Y_Size() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YSIZE));
  }
//+------------------------------------------------------------------+
//| Set the Y-size.                                                  |
//| INPUT:  size - new Y-size.                                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::Y_Size(int size)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_YSIZE,size));
  }
//+------------------------------------------------------------------+
//| Get chart symbol.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: chart symbol.                                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObjectSubChart::Symbol() const
  {
//--- checking
   if(m_chart_id==-1) return("");
//---
   return(ObjectGetString(m_chart_id,m_name,OBJPROP_SYMBOL));
  }
//+------------------------------------------------------------------+
//| Set chart symbol.                                                |
//| INPUT:  symbol - new symbol of chart.                            |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::Symbol(string symbol)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetString(m_chart_id,m_name,OBJPROP_SYMBOL,symbol));
  }
//+------------------------------------------------------------------+
//| Get chart period.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: chart period.                                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectSubChart::Period() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_PERIOD));
  }
//+------------------------------------------------------------------+
//| Set chart period.                                                |
//| INPUT:  period - new period chart.                               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::Period(int period)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_PERIOD,period));
  }
//+------------------------------------------------------------------+
//| Get chart scale.                                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: chart scale.                                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectSubChart::Scale() const
  {
//--- checking
   if(m_chart_id==-1) return(-1);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_CHART_SCALE));
  }
//+------------------------------------------------------------------+
//| Set chart scale.                                                 |
//| INPUT:  scale - new scale of chart.                              |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::Scale(int scale)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_CHART_SCALE,scale));
  }
//+------------------------------------------------------------------+
//| Get the "time scale" flag.                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: the "time scale" flag.                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::DateScale() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_DATE_SCALE));
  }
//+------------------------------------------------------------------+
//| Set the "time scale" flag.                                       |
//| INPUT:  new_ray - new "time scale" flag.                         |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::DateScale(bool scale)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_DATE_SCALE,scale));
  }
//+------------------------------------------------------------------+
//| Get the "price scale" flag.                                      |
//| INPUT:  no.                                                      |
//| OUTPUT: the "price scale" flag.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::PriceScale() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_PRICE_SCALE));
  }
//+------------------------------------------------------------------+
//| Set the "price scale" flag.                                      |
//| INPUT:  new_ray - new "price scale" flag.                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::PriceScale(bool scale)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_PRICE_SCALE,scale));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//          for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectSubChart::Save(int file_handle)
  {
   bool   resutl;
   int    len;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObject::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "X-distance" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "Y-distance" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YDISTANCE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "corner" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_CORNER),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "X-size" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XSIZE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "Y-size" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YSIZE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "symbol" property
      str=ObjectGetString(m_chart_id,m_name,OBJPROP_SYMBOL);
      len=StringLen(str);
      if(FileWriteInteger(file_handle,len,INT_VALUE)!=INT_VALUE) return(false);
      if(len!=0) if(FileWriteString(file_handle,str,len)!=len) return(false);
      //--- writing value of the "period" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_PERIOD),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "scale" property
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE))!=sizeof(double)) return(false);
      //--- writing value of the "time scale" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_DATE_SCALE),CHAR_VALUE)!=sizeof(char)) return(false);
      //--- writing value of the "price scale" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_PRICE_SCALE),CHAR_VALUE)!=sizeof(char)) return(false);
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
bool CChartObjectSubChart::Load(int file_handle)
  {
   bool   resutl;
   int    len;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObject::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "X-distance" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "Y-distance" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_YDISTANCE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "corner" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_CORNER,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "X-size" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_XSIZE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "Y-size" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_YSIZE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "symbol" property
      len=FileReadInteger(file_handle,INT_VALUE);
      if(len!=0) str=FileReadString(file_handle,len);
      else       str="";
      if(!ObjectSetString(m_chart_id,m_name,OBJPROP_SYMBOL,str)) return(false);
      //--- reading value of the "period" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_PERIOD,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "scale" property
      if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,FileReadDatetime(file_handle))) return(false);
      //--- reading value of the "time scale" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_DATE_SCALE,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
      //--- reading value of the "price scale" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_PRICE_SCALE,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
