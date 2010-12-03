//+------------------------------------------------------------------+
//|                                      ChartObjectsTxtControls.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.03.30 |
//+------------------------------------------------------------------+
//| All text objects.                                                |
//+------------------------------------------------------------------+
#include "ChartObject.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectText.                                          |
//| Purpose: Class of the "Text" object of chart.                    |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectText : public CChartObject
  {
public:
   //--- methods of access to properties of the object
   double            Angle() const;
   bool              Angle(double angle);
   string            Font() const;
   bool              Font(string font);
   int               FontSize() const;
   bool              FontSize(int size);
   ENUM_ANCHOR_POINT Anchor() const;
   bool              Anchor(ENUM_ANCHOR_POINT anchor);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_TEXT); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Text".                                            |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectText::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_TEXT,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get value of the "Angle" property.                               |
//| INPUT:  no.                                                      |
//| OUTPUT: value of the "Angle" property.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CChartObjectText::Angle() const
  {
//--- checking
   if(m_chart_id==-1) return(EMPTY_VALUE);
//---
   return(ObjectGetDouble(m_chart_id,m_name,OBJPROP_ANGLE));
  }
//+------------------------------------------------------------------+
//| Set value of the "Angle" property.                               |
//| INPUT:  angle - new value of the "Angle" property.               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectText::Angle(double angle)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetDouble(m_chart_id,m_name,OBJPROP_ANGLE,angle));
  }
//+------------------------------------------------------------------+
//| Get font name.                                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: font name.                                               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObjectText::Font() const
  {
//--- checking
   if(m_chart_id==-1) return("");
//---
   return(ObjectGetString(m_chart_id,m_name,OBJPROP_FONT));
  }
//+------------------------------------------------------------------+
//| Set font name.                                                   |
//| INPUT:  font - new name of font.                                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectText::Font(string font)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetString(m_chart_id,m_name,OBJPROP_FONT,font));
  }
//+------------------------------------------------------------------+
//| Get font size.                                                   |
//| INPUT:  no.                                                      |
//| OUTPUT: font size.                                               |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectText::FontSize() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_FONTSIZE));
  }
//+------------------------------------------------------------------+
//| Set font size.                                                   |
//| INPUT:  size - new size of font.                                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectText::FontSize(int size)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_FONTSIZE,size));
  }
//+------------------------------------------------------------------+
//| Get anchor point.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: anchor point.                                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_ANCHOR_POINT CChartObjectText::Anchor() const
  {
//--- checking
   if(m_chart_id==-1) return(WRONG_VALUE);
//---
   return((ENUM_ANCHOR_POINT)ObjectGetInteger(m_chart_id,m_name,OBJPROP_ANCHOR));
  }
//+------------------------------------------------------------------+
//| Set anchor point.                                                |
//| INPUT:  anchor - new anchor point.                               |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectText::Anchor(ENUM_ANCHOR_POINT anchor)
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
bool CChartObjectText::Save(int file_handle)
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
      //--- writing value of the "Angle" property
      if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_ANGLE))!=sizeof(double)) return(false);
      //--- writing value of the "Font Name" property
      str=ObjectGetString(m_chart_id,m_name,OBJPROP_FONT);
      len=StringLen(str);
      if(FileWriteInteger(file_handle,len,INT_VALUE)!=INT_VALUE) return(false);
      if(len!=0) if(FileWriteString(file_handle,str,len)!=len) return(false);
      //--- writing value of the "Font Size" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_FONTSIZE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "Anchor Point" property
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
bool CChartObjectText::Load(int file_handle)
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
      //--- reading value of the "Angle" property
      if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_ANGLE,0,FileReadDouble(file_handle))) return(false);
      //--- reading value of the "Font Name" property
      len=FileReadInteger(file_handle,INT_VALUE);
      if(len!=0) str=FileReadString(file_handle,len);
      else       str="";
      if(!ObjectSetString(m_chart_id,m_name,OBJPROP_FONT,str)) return(false);
      //--- reading value of the "Font Size" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_FONTSIZE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "Anchor Point" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_ANCHOR,FileReadInteger(file_handle,INT_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectLabel.                                         |
//| Purpose: Class of the "Label" object of chart.                   |
//|          Derives from class CChartObjectText.                    |
//+------------------------------------------------------------------+
class CChartObjectLabel : public CChartObjectText
  {
public:
   //--- methods of access to properties of the object
   int               X_Distance() const;
   bool              X_Distance(int X);
   int               Y_Distance() const;
   bool              Y_Distance(int Y);
   int               X_Size() const;
   int               Y_Size() const;
   ENUM_BASE_CORNER  Corner() const;
   bool              Corner(ENUM_BASE_CORNER corner);
   //--- change of time/price coordinates is blocked
   bool              Time(datetime time) { return(false);     }
   bool              Price(double price) { return(false);     }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,int X,int Y);
   //--- method of identifying the object
   virtual int       Type() const        { return(OBJ_LABEL); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Label".                                           |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         X        - X-distance from anchor point to base corner,  |
//|         Y        - Y-distance from anchor point to base corner.  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectLabel::Create(long chart_id,string name,int window,int X,int Y)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_LABEL,window,0,0.0);
//---
   if(result) result&=Attach(chart_id,name,window,1);
   result&=Description(name);
   result&=X_Distance(X);
   result&=Y_Distance(Y);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get the X-distance.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: X-distance.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectLabel::X_Distance() const
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
bool CChartObjectLabel::X_Distance(int X)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE,X));
  }
//+------------------------------------------------------------------+
//| Get the Y-distance.                                              |
//| INPUT:  no.                                                      |
//| OUTPUT: Y-distance.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectLabel::Y_Distance() const
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
bool CChartObjectLabel::Y_Distance(int Y)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_YDISTANCE,Y));
  }
//+------------------------------------------------------------------+
//| Get the X-size.                                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: X-size.                                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectLabel::X_Size() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XSIZE));
  }
//+------------------------------------------------------------------+
//| Get the Y-size.                                                  |
//| INPUT:  no.                                                      |
//| OUTPUT: Y-size.                                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectLabel::Y_Size() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YSIZE));
  }
//+------------------------------------------------------------------+
//| Get base corner.                                                 |
//| INPUT:  no.                                                      |
//| OUTPUT: base corner.                                             |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_BASE_CORNER CChartObjectLabel::Corner() const
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
bool CChartObjectLabel::Corner(ENUM_BASE_CORNER corner)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_CORNER,corner));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectLabel::Save(int file_handle)
  {
   bool   resutl;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObjectText::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "X-distance" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "Y-distance" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YDISTANCE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "Corner" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_CORNER),INT_VALUE)!=sizeof(int)) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Reading parameters of object from file.                          |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading file.                                        |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectLabel::Load(int file_handle)
  {
   bool   resutl;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObjectText::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "X-distance" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "Y-distance" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_YDISTANCE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "Corner" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_CORNER,FileReadInteger(file_handle,INT_VALUE))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectEdit.                                          |
//| Purpose: Class of the "Edit" object of chart.                    |
//|          Derives from class CChartObjectLabel.                   |
//+------------------------------------------------------------------+
class CChartObjectEdit : public CChartObjectLabel
  {
public:
   //--- methods of access to properties of the object
   bool              X_Size(int X);
   bool              Y_Size(int Y);
   color             BackColor() const;
   bool              BackColor(color new_color);
   bool              ReadOnly() const;
   bool              ReadOnly(bool flag);
   //--- change of angle is blocked
   bool              Angle(double angle) { return(false);    }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,int X,int Y,int sizeX,int sizeY);
   //--- method of identifying the object
   virtual int       Type() const        { return(OBJ_EDIT); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Edit".                                            |
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
bool CChartObjectEdit::Create(long chart_id,string name,int window,int X,int Y,int sizeX,int sizeY)
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
//| Set X-size.                                                      |
//| INPUT:  X - new X-size.                                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectEdit::X_Size(int X)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_XSIZE,X));
  }
//+------------------------------------------------------------------+
//| Set Y-size.                                                      |
//| INPUT:  Y - new Y-size.                                          |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectEdit::Y_Size(int Y)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_YSIZE,Y));
  }
//+------------------------------------------------------------------+
//| Get background color.                                            |
//| INPUT:  no.                                                      |
//| OUTPUT: background color.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
color CChartObjectEdit::BackColor() const
  {
//--- checking
   if(m_chart_id==-1) return(CLR_NONE);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_BGCOLOR));
  }
//+------------------------------------------------------------------+
//| Set background color.                                            |
//| INPUT:  new_color - new background color.                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectEdit::BackColor(color new_color)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_BGCOLOR,new_color));
  }
//+------------------------------------------------------------------+
//| Get the "Read only" property.                                    |
//| INPUT:  no.                                                      |
//| OUTPUT: value of "Read only" property.                           |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectEdit::ReadOnly() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_READONLY));
  }
//+------------------------------------------------------------------+
//| Set the "Read only" property.                                    |
//| INPUT:  flag - new value of the "Read only" property.            |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectEdit::ReadOnly(bool flag)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_READONLY,flag));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectEdit::Save(int file_handle)
  {
   bool   resutl;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObjectLabel::Save(file_handle);
   if(resutl)
     {
      //--- writing value of the "X-size" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XSIZE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "Y-size" property
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YSIZE),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing background color
      if(FileWriteLong(file_handle,ObjectGetInteger(m_chart_id,m_name,OBJPROP_BGCOLOR))!=sizeof(long)) return(false);
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
bool CChartObjectEdit::Load(int file_handle)
  {
   bool   resutl;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObjectLabel::Load(file_handle);
   if(resutl)
     {
      //--- reading value of the "X-size" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_XSIZE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "Y-size" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_YSIZE,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading background color
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_BGCOLOR,FileReadLong(file_handle))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectButton.                                        |
//| Purpose: Class of the "Button" object of chart.                  |
//|          Derives from class CChartObjectEdit.                    |
//+------------------------------------------------------------------+
class CChartObjectButton : public CChartObjectEdit
  {
public:
   //--- methods of access to properties of the object
   bool              State() const;
   bool              State(bool state);
   //--- method of identifying the object
   virtual int       Type() const { return(OBJ_BUTTON); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Get state.                                                       |
//| INPUT:  no.                                                      |
//| OUTPUT: state.                                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectButton::State() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectGetInteger(m_chart_id,m_name,OBJPROP_STATE));
  }
//+------------------------------------------------------------------+
//| Set state.                                                       |
//| INPUT:  state - state.                                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectButton::State(bool state)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_STATE,state));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectButton::Save(int file_handle)
  {
   bool   resutl;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- writing
   resutl=CChartObjectEdit::Save(file_handle);
   if(resutl)
     {
      //--- writing state
      if(FileWriteLong(file_handle,ObjectGetInteger(m_chart_id,m_name,OBJPROP_STATE))!=sizeof(long)) return(false);
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
bool CChartObjectButton::Load(int file_handle)
  {
   bool   resutl;
   string str;
//--- checking
   if(file_handle<=0) return(false);
   if(m_chart_id==-1) return(false);
//--- reading
   resutl=CChartObjectEdit::Load(file_handle);
   if(resutl)
     {
      //--- reading state
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_STATE,FileReadLong(file_handle))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
