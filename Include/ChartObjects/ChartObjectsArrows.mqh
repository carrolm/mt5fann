//+------------------------------------------------------------------+
//|                                           ChartObjectsArrows.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
//| All arrows.                                                      |
//+------------------------------------------------------------------+
#include "ChartObject.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectArrow.                                         |
//| Purpose: Class of the "Arrow" object of chart.                   |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectArrow : public CChartObject
  {
public:
   //--- methods of access to properties of the object
   char              ArrowCode() const;
   bool              ArrowCode(char code);
   ENUM_ARROW_ANCHOR Anchor() const;
   bool              Anchor(ENUM_ARROW_ANCHOR anchor);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price,char code);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Arrow".                                           |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrow::Create(long chart_id,string name,int window,datetime time,double price,char code)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW,window,time,price);
   if(result)
     {
      result&=Attach(chart_id,name,window,1);
      result&=ArrowCode(code);
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get code of "arrow" symbol.                                      |
//| INPUT:  no.                                                      |
//| OUTPUT: code of "arrow".                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
char CChartObjectArrow::ArrowCode() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((char)ObjectGetInteger(m_chart_id,m_name,OBJPROP_ARROWCODE));
  }
//+------------------------------------------------------------------+
//| Set code of "arrow" symbol.                                      |
//| INPUT:  code - new code of "arrow" symbol.                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrow::ArrowCode(char code)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_ARROWCODE,code));
  }
//+------------------------------------------------------------------+
//| Get anchor type.                                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: anchor type.                                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_ARROW_ANCHOR CChartObjectArrow::Anchor() const
  {
   return((ENUM_ARROW_ANCHOR)ObjectGetInteger(m_chart_id,m_name,OBJPROP_ANCHOR));
  }
//+------------------------------------------------------------------+
//| Set anchor type.                                                 |
//| INPUT:  anchor - new anchor type.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrow::Anchor(ENUM_ARROW_ANCHOR anchor)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_ANCHOR,anchor));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrow::Save(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CObject::Save(file_handle);
   if(resutl)
     {
      //--- writing code of "arrow" symbol
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_ARROWCODE),CHAR_VALUE)!=sizeof(char)) return(false);
      //--- writing anchor type
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_ANCHOR),INT_VALUE)!=sizeof(int)) return(false);
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
bool CChartObjectArrow::Load(int file_handle)
  {
   bool resutl;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CObject::Load(file_handle);
   if(resutl)
     {
      //--- reading code of "arrow" symbol
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_ARROWCODE,FileReadInteger(file_handle,CHAR_VALUE))) return(false);
      //--- reading anchor type
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_ANCHOR,FileReadInteger(file_handle,INT_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectArrowThumbUp.                                  |
//| Purpose: Class of the "Thumbs Up" object of chart.               |
//|          Derives from class CChartObjectArrow.                   |
//+------------------------------------------------------------------+
class CChartObjectArrowThumbUp : public CChartObjectArrow
  {
public:
   //--- change of arrow code is blocked
   bool              ArrowCode(char code) { return(false); }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW_THUMB_UP); }
  };
//+------------------------------------------------------------------+
//| Create object "Thumbs Up".                                       |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false of not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrowThumbUp::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW_THUMB_UP,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectArrowThumbDown.                                |
//| Purpose: Class of the "Thumbs Down" object of chart.             |
//|          Derives from class CChartObjectArrow.                   |
//+------------------------------------------------------------------+
class CChartObjectArrowThumbDown : public CChartObjectArrow
  {
public:
   //--- change of arrow code is blocked
   bool              ArrowCode(char code) { return(false); }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW_THUMB_DOWN); }
  };
//+------------------------------------------------------------------+
//| Create object "ThumbsDown".                                      |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrowThumbDown::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW_THUMB_DOWN,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectArrowUp.                                       |
//| Purpose: Class of the "Arrow Up" object of chart.                |
//|          Derives from class CChartObjectArrow.                   |
//+------------------------------------------------------------------+
class CChartObjectArrowUp : public CChartObjectArrow
  {
public:
   //--- change of arrow code is blocked
   bool              ArrowCode(char code) { return(false); }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW_UP); }
  };
//+------------------------------------------------------------------+
//| Create object "Arrow Up".                                        |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrowUp::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW_UP,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectArrowDown.                                     |
//| Purpose: Class of the "Arrow Down" object of chart.              |
//|          Derives from class CChartObjectArrow.                   |
//+------------------------------------------------------------------+
class CChartObjectArrowDown : public CChartObjectArrow
  {
public:
   //--- change of arrow code is blocked
   bool              ArrowCode(char code) { return(false); }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW_DOWN); }
  };
//+------------------------------------------------------------------+
//| Create object "Arrow Down".                                      |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrowDown::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW_DOWN,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectArrowStop.                                     |
//| Purpose: Class of the "Stop Sign" object of chart.               |
//|          Derives from class CChartObjectArrow.                   |
//+------------------------------------------------------------------+
class CChartObjectArrowStop : public CChartObjectArrow
  {
public:
   //--- change of arrow code is blocked
   bool              ArrowCode(char code) { return(false); }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW_STOP); }
  };
//+------------------------------------------------------------------+
//| Create object "Stop Sign".                                       |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrowStop::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW_STOP,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectArrowCheck.                                    |
//| Purpose: Class of the "Check Sign" object of chart.              |
//|          Derives from class CChartObjectArrow.                   |
//+------------------------------------------------------------------+
class CChartObjectArrowCheck : public CChartObjectArrow
  {
public:
   //--- change of arrow code is blocked
   bool              ArrowCode(char code) { return(false); }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW_CHECK); }
  };
//+------------------------------------------------------------------+
//| Create object "Check Sign".                                      |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrowCheck::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW_CHECK,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectArrowLeftPrice.                                |
//| Purpose: Class of the "Left Price Label" object of chart.        |
//|          Derives from class CChartObjectArrow.                   |
//+------------------------------------------------------------------+
class CChartObjectArrowLeftPrice : public CChartObjectArrow
  {
public:
   //--- change of arrow code and anchor point is blocked
   bool              ArrowCode(char code)             { return(false); }
   bool              Anchor(ENUM_ANCHOR_POINT anchor) { return(false); }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW_LEFT_PRICE); }
  };
//+------------------------------------------------------------------+
//| Create object "Left Price Label".                                |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrowLeftPrice::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW_LEFT_PRICE,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectArrowRightPrice.                               |
//| Purpose: Class of the "Right Price Label" object of chart.       |
//|          Derives from class CChartObjectArrow.                   |
//+------------------------------------------------------------------+
class CChartObjectArrowRightPrice : public CChartObjectArrow
  {
public:
   //--- change of arrow code and anchor point is blocked
   bool              ArrowCode(char code)             { return(false); }
   bool              Anchor(ENUM_ANCHOR_POINT anchor) { return(false); }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_ARROW_RIGHT_PRICE); }
  };
//+------------------------------------------------------------------+
//| Create object "Right Price Label".                               |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectArrowRightPrice::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_ARROW_RIGHT_PRICE,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
