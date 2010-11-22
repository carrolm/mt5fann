//+------------------------------------------------------------------+
//|                                           ChartObjectsShapes.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
//| All shapes.                                                      |
//+------------------------------------------------------------------+
#include "ChartObject.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectRectangle.                                     |
//| Purpose: Class of the "Rectangle" object of chart.               |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectRectangle : public CChartObject
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_RECTANGLE); }
  };
//+------------------------------------------------------------------+
//| Create object "Rectangle".                                       |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate                         |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate.                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectRectangle::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_RECTANGLE,window,time1,price1,time2,price2);
//---
   if(result) result&=Attach(chart_id,name,window,2);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectTriangle.                                      |
//| Purpose: Class of the "Triangle" object of chart.                |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectTriangle : public CChartObject
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_TRIANGLE); }
  };
//+------------------------------------------------------------------+
//| Create object "Triangle".                                        |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate.                      |
//|         time3    - third time coordinate,                        |
//|         price3   - third price coordinate.                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectTriangle::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_TRIANGLE,window,time1,price1,time2,price2,time3,price3);
//---
   if(result) result&=Attach(chart_id,name,window,3);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectEllipse.                                       |
//| Purpose: Class of the "Ellipse" object of chart.                 |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectEllipse : public CChartObject
  {
public:
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ELLIPSE); }
  };
//+------------------------------------------------------------------+
//| Create object "Ellipse".                                         |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time1    - first time coordinate,                        |
//|         price1   - first price coordinate,                       |
//|         time2    - second time coordinate,                       |
//|         price2   - second price coordinate.                      |
//|         time3    - third time coordinate,                        |
//|         price3   - third price coordinate.                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectEllipse::Create(long chart_id,string name,int window,datetime time1,double price1,datetime time2,double price2,datetime time3,double price3)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ELLIPSE,window,time1,price1,time2,price2,time3,price3);
//---
   if(result) result&=Attach(chart_id,name,window,3);
//---
   return(result);
  }
//+------------------------------------------------------------------+
