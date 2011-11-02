//+------------------------------------------------------------------+
//|                                      ChartObjectsBmpControls.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
//| All objects with "bmp" pictures.                                 |
//+------------------------------------------------------------------+
#include "ChartObject.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectBitmap.                                        |
//| Purpose: Class of the "Bitmap" object of chart.                  |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectBitmap : public CChartObject
  {
public:
   //--- methods of access to properties of the object
   string            BmpFile()    const;
   bool              BmpFile(string name);
   int               X_Offset()   const;
   bool              X_Offset(int X);
   int               Y_Offset()   const;
   bool              Y_Offset(int Y);
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,datetime time,double price);
   //--- method of identifying the object
   virtual int       Type()       const { return(OBJ_BITMAP); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Bitmapp".                                         |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         time     - time coordinate,                              |
//|         price    - price coordinate.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBitmap::Create(long chart_id,string name,int window,datetime time,double price)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_BITMAP,window,time,price);
   if(result) result&=Attach(chart_id,name,window,1);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get name of bmp-file.                                            |
//| INPUT:  no.                                                      |
//| OUTPUT: name of bmp-file.                                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObjectBitmap::BmpFile() const
  {
//--- checking
   if(m_chart_id==-1) return("");
//---
   return(ObjectGetString(m_chart_id,m_name,OBJPROP_BMPFILE));
  }
//+------------------------------------------------------------------+
//| Set name of bmp-file.                                            |
//| INPUT:  name - new name of bmp-file.                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBitmap::BmpFile(string name)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetString(m_chart_id,m_name,OBJPROP_BMPFILE,name));
  }
//+------------------------------------------------------------------+
//| Get the XOffset property.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: XOffset.                                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectBitmap::X_Offset() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XOFFSET));
  }
//+------------------------------------------------------------------+
//| Set the XOffset property.                                        |
//| INPUT:  X - new value.                                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBitmap::X_Offset(int X)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_XOFFSET,X));
  }
//+------------------------------------------------------------------+
//| Get the YOffset property.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: YOffset.                                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectBitmap::Y_Offset() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YOFFSET));
  }
//+------------------------------------------------------------------+
//| Set the YOffset property.                                        |
//| INPUT:  Y - new value.                                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBitmap::Y_Offset(int Y)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_YOFFSET,Y));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing file.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBitmap::Save(int file_handle)
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
      //--- writing value of the "name of bmp-file" property
      str=ObjectGetString(m_chart_id,m_name,OBJPROP_BMPFILE);
      len=StringLen(str);
      if(FileWriteInteger(file_handle,len,INT_VALUE)!=INT_VALUE) return(false);
      if(len!=0) if(FileWriteString(file_handle,str,len)!=len) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Reading parameters of object from file.                          |
//| INPUT:  file_handle - handle file previously opened              |
//|         for reading file.                                        |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBitmap::Load(int file_handle)
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
      //--- reading value of the "name of bmp-file" property
      len=FileReadInteger(file_handle,INT_VALUE);
      if(len!=0) str=FileReadString(file_handle,len);
      else       str="";
      if(!ObjectSetString(m_chart_id,m_name,OBJPROP_BMPFILE,str)) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectBmpLabel.                                      |
//| Purpose: Class of the "Bitmap label" object of chart.            |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectBmpLabel : public CChartObject
  {
public:
   //--- methods of access to properties of the object
   int               X_Distance() const;
   bool              X_Distance(int X);
   int               Y_Distance() const;
   bool              Y_Distance(int Y);
   int               X_Size()     const;
   int               Y_Size()     const;
   ENUM_BASE_CORNER  Corner()     const;
   bool              Corner(ENUM_BASE_CORNER corner);
   string            BmpFileOn()  const;
   bool              BmpFileOn(string name);
   string            BmpFileOff() const;
   bool              BmpFileOff(string name);
   bool              State()      const;
   bool              State(bool state);
   int               X_Offset()   const;
   bool              X_Offset(int X);
   int               Y_Offset()   const;
   bool              Y_Offset(int Y);
   //--- change of time/price coordinates is blocked
   bool              Time(datetime time) { return(false);            }
   bool              Price(double price) { return(false);            }
   //--- method of creating the object
   bool              Create(long chart_id,string name,int window,int X,int Y);
   //--- method of identifying the object
   virtual int       Type()       const  { return(OBJ_BITMAP_LABEL); }
   //--- methods for working with files
   virtual bool      Save(int file_handle);
   virtual bool      Load(int file_handle);
  };
//+------------------------------------------------------------------+
//| Create object "Bitmap label".                                    |
//| INPUT:  chart_id - chart identifier,                             |
//|         name     - object name,                                  |
//|         window   - subwindow number,                             |
//|         X        - X coordinate,                                 |
//|         Y        - Y coordinate.                                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::Create(long chart_id,string name,int window,int X,int Y)
  {
   bool result=ObjectCreate(chart_id,name,OBJ_BITMAP_LABEL,window,0,0.0);
//---
   if(result) result&=Attach(chart_id,name,window,1);
   result&=X_Distance(X);
   result&=Y_Distance(Y);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Get the X-distance property.                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: X-distance.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectBmpLabel::X_Distance() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE));
  }
//+------------------------------------------------------------------+
//| Set the X-distance property.                                     |
//| INPUT:  X - new X-distance.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::X_Distance(int X)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_XDISTANCE,X));
  }
//+------------------------------------------------------------------+
//| Get the Y-distance property.                                     |
//| INPUT:  no.                                                      |
//| OUTPUT: Y-distance.                                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectBmpLabel::Y_Distance() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YDISTANCE));
  }
//+------------------------------------------------------------------+
//| Set the Y-distance property.                                     |
//| INPUT:  Y - new Y-distance.                                      |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::Y_Distance(int Y)
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
int CChartObjectBmpLabel::X_Size() const
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
int CChartObjectBmpLabel::Y_Size() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YSIZE));
  }
//+------------------------------------------------------------------+
//| Get the Corner property.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: corner.                                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ENUM_BASE_CORNER CChartObjectBmpLabel::Corner() const
  {
//--- checking
   if(m_chart_id==-1) return(WRONG_VALUE);
//---
   return((ENUM_BASE_CORNER)ObjectGetInteger(m_chart_id,m_name,OBJPROP_CORNER));
  }
//+------------------------------------------------------------------+
//| Set the Corner property.                                         |
//| INPUT:  corner - new corner.                                     |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::Corner(ENUM_BASE_CORNER corner)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_CORNER,corner));
  }
//+------------------------------------------------------------------+
//| Get filename of the "bmp-ON" property.                           |
//| INPUT:  no.                                                      |
//| OUTPUT: filename.                                                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObjectBmpLabel::BmpFileOn() const
  {
//--- checking
   if(m_chart_id==-1) return("");
//---
   return(ObjectGetString(m_chart_id,m_name,OBJPROP_BMPFILE,0));
  }
//+------------------------------------------------------------------+
//| Set filename for the "bmp-ON" property.                          |
//| INPUT:  name - new filename.                                     |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::BmpFileOn(string name)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetString(m_chart_id,m_name,OBJPROP_BMPFILE,0,name));
  }
//+------------------------------------------------------------------+
//| Get filename of the "bmp-OFF" property.                          |
//| INPUT:  no.                                                      |
//| OUTPUT: filename.                                                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CChartObjectBmpLabel::BmpFileOff() const
  {
//--- checking
   if(m_chart_id==-1) return("");
//---
   return(ObjectGetString(m_chart_id,m_name,OBJPROP_BMPFILE,1));
  }
//+------------------------------------------------------------------+
//| Set filename for the "bmp-OFF" property.                         |
//| INPUT:  name - new filename.                                     |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::BmpFileOff(string name)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetString(m_chart_id,m_name,OBJPROP_BMPFILE,1,name));
  }
//+------------------------------------------------------------------+
//| Get the State property.                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: state.                                                   |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::State() const
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_STATE));
  }
//+------------------------------------------------------------------+
//| Set the State property.                                          |
//| INPUT:  state - new state.                                       |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::State(bool state)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_STATE,state));
  }
//+------------------------------------------------------------------+
//| Get the XOffset property.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: XOffset.                                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectBmpLabel::X_Offset() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_XOFFSET));
  }
//+------------------------------------------------------------------+
//| Set the XOffset property.                                        |
//| INPUT:  X - new value.                                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::X_Offset(int X)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_XOFFSET,X));
  }
//+------------------------------------------------------------------+
//| Get the YOffset property.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: YOffset.                                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CChartObjectBmpLabel::Y_Offset() const
  {
//--- checking
   if(m_chart_id==-1) return(0);
//---
   return((int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_YOFFSET));
  }
//+------------------------------------------------------------------+
//| Set the YOffset property.                                        |
//| INPUT:  Y - new value.                                           |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::Y_Offset(int Y)
  {
//--- checking
   if(m_chart_id==-1) return(false);
//---
   return(ObjectSetInteger(m_chart_id,m_name,OBJPROP_YOFFSET,Y));
  }
//+------------------------------------------------------------------+
//| Writing parameters of object to file.                            |
//| INPUT:  file_handle - handle file previously opened              |
//|         for writing file.                                        |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::Save(int file_handle)
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
      //--- writing value of the "Corner" property 
      if(FileWriteInteger(file_handle,(int)ObjectGetInteger(m_chart_id,m_name,OBJPROP_CORNER),INT_VALUE)!=sizeof(int)) return(false);
      //--- writing value of the "filename bmp-ON" property 
      str=ObjectGetString(m_chart_id,m_name,OBJPROP_BMPFILE,0);
      len=StringLen(str);
      if(FileWriteInteger(file_handle,len,INT_VALUE)!=INT_VALUE) return(false);
      if(len!=0) if(FileWriteString(file_handle,str,len)!=len) return(false);
      //--- writing value of the "filename bmp-OFF" property
      str=ObjectGetString(m_chart_id,m_name,OBJPROP_BMPFILE,1);
      len=StringLen(str);
      if(FileWriteInteger(file_handle,len,INT_VALUE)!=INT_VALUE) return(false);
      if(len!=0) if(FileWriteString(file_handle,str,len)!=len) return(false);
      //--- writing state
      if(FileWriteLong(file_handle,ObjectGetInteger(m_chart_id,m_name,OBJPROP_STATE))!=sizeof(long)) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
//| Reading object parameters from file.                             |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading file.                                        |
//| OUTPUT: true-if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CChartObjectBmpLabel::Load(int file_handle)
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
      //--- reading value of "Corner" property
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_CORNER,FileReadInteger(file_handle,INT_VALUE))) return(false);
      //--- reading value of the "filename bmp-ON" property
      len=FileReadInteger(file_handle,INT_VALUE);
      if(len!=0) str=FileReadString(file_handle,len);
      else       str="";
      if(!ObjectSetString(m_chart_id,m_name,OBJPROP_BMPFILE,0,str)) return(false);
      //--- reading value of the "filename bmp-OFF" property
      len=FileReadInteger(file_handle,INT_VALUE);
      if(len!=0) str=FileReadString(file_handle,len);
      else       str="";
      if(!ObjectSetString(m_chart_id,m_name,OBJPROP_BMPFILE,1,str)) return(false);
      //--- reading state
      if(!ObjectSetInteger(m_chart_id,m_name,OBJPROP_STATE,FileReadLong(file_handle))) return(false);
     }
//---
   return(resutl);
  }
//+------------------------------------------------------------------+
