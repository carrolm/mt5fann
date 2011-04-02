//+------------------------------------------------------------------+
//|                                                      FileBin.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.08 |
//+------------------------------------------------------------------+
#include "File.mqh"
//+------------------------------------------------------------------+
//| Class CFileBin.                                                  |
//| Purpose: Class of operations with binary files.                  |
//|          Derives from class CFile.                               |
//+------------------------------------------------------------------+
class CFileBin : public CFile
  {
public:
   //--- methods for working with files
   int               Open(string file_name,int open_flags);
   //--- methods for writing data
   uint              WriteChar(char value);
   uint              WriteShort(short value);
   uint              WriteInteger(int value);
   uint              WriteLong(long value);
   uint              WriteFloat(float value);
   uint              WriteDouble(double value);
   uint              WriteString(const string value);
   uint              WriteString(const string value,int size);
   uint              WriteCharArray(char& array[],int start_item=0,int items_count=-1);
   uint              WriteShortArray(short& array[],int start_item=0,int items_count=-1);
   uint              WriteIntegerArray(int& array[],int start_item=0,int items_count=-1);
   uint              WriteLongArray(long& array[],int start_item=0,int items_count=-1);
   uint              WriteFloatArray(float& array[],int start_item=0,int items_count=-1);
   uint              WriteDoubleArray(double& array[],int start_item=0,int items_count=-1);
   bool              WriteObject(CObject *object);
   //--- methods for reading data
   bool              ReadChar(char& value);
   bool              ReadShort(short& value);
   bool              ReadInteger(int& value);
   bool              ReadLong(long& value);
   bool              ReadFloat(float& value);
   bool              ReadDouble(double& value);
   bool              ReadString(string& value);
   bool              ReadString(string& value,int size);
   bool              ReadCharArray(char& array[],int start_item=0,int items_count=-1);
   bool              ReadShortArray(short& array[],int start_item=0,int items_count=-1);
   bool              ReadIntegerArray(int& array[],int start_item=0,int items_count=-1);
   bool              ReadLongArray(long& array[],int start_item=0,int items_count=-1);
   bool              ReadFloatArray(float& array[],int start_item=0,int items_count=-1);
   bool              ReadDoubleArray(double& array[],int start_item=0,int items_count=-1);
   bool              ReadObject(CObject *object);
  };
//+------------------------------------------------------------------+
//| Opening a binary file.                                           |
//| INPUT:  file_name - name of file,                                |
//|         open_flags - flags of opening.                           |
//| OUTPUT: handle of opened file, or -1.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CFileBin::Open(string file_name, int open_flags)
  {
   int result=CFile::Open(file_name,open_flags|FILE_BIN);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Write a variable of char or uchar type.                          |
//| INPUT: value - variable to write.                                |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteChar(char value)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteInteger(m_handle,value,sizeof(char)));
  }
//+------------------------------------------------------------------+
//| Write a variable of short or ushort type.                        |
//| INPUT:  value - variable to write.                               |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteShort(short value)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteInteger(m_handle,value,sizeof(short)));
  }
//+------------------------------------------------------------------+
//| Write a variable of int or uint type.                            |
//| INPUT:  value - variable to write.                               |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteInteger(int value)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteInteger(m_handle,value,sizeof(int)));
  }
//+------------------------------------------------------------------+
//| Write a variable of long or ulong type.                          |
//| INPUT:  value - variable to write.                               |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteLong(long value)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteLong(m_handle,value));
  }
//+------------------------------------------------------------------+
//| Write a variable of float type.                                  |
//| INPUT:  value - variable to write.                               |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteFloat(float value)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteFloat(m_handle,value));
  }
//+------------------------------------------------------------------+
//| Write a variable of double type.                                 |
//| INPUT:  value - variable to write.                               |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteDouble(double value)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteDouble(m_handle,value));
  }
//+------------------------------------------------------------------+
//| Write a variable of string type.                                 |
//| INPUT:  value - string to write.                                 |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteString(const string value)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   int size=StringLen(value);
   FileWriteInteger(m_handle,size);
//---
   return(FileWriteString(m_handle,value,size));
  }
//+------------------------------------------------------------------+
//| Write a part of string.                                          |
//| INPUT:  value - string to write,                                 |
//|         size   - number of characters in the string to write.    |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteString(const string value,int size)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteString(m_handle,value,size));
  }
//+------------------------------------------------------------------+
//| Write array variables of type char or uchar.                     |
//| INPUT:  array      -array to write,                              |
//|         start_item -starting element for write,                  |
//|         items_count-number of elements to write.                 |
//| OUTPUT: number of elements written.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteCharArray(char& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteArray(m_handle,array,start_item,items_count));
  }
//+------------------------------------------------------------------+
//| Write an array of variables of short or ushort type.             |
//| INPUT:  array       - array to write,                            |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to write.               |
//| OUTPUT: number of elements written.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteShortArray(short& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteArray(m_handle,array,start_item,items_count));
  }
//+------------------------------------------------------------------+
//| Write an array of variables of int or uint type.                 |
//| INPUT:  array       - array to write,                            |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to write.               |
//| OUTPUT: number of elements written.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteIntegerArray(int& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteArray(m_handle,array,start_item,items_count));
  }
//+------------------------------------------------------------------+
//| Write an array of variables of long or ulong type.               |
//| INPUT:  array       - array to write,                            |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to write.               |
//| OUTPUT: number of elements written.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteLongArray(long& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteArray(m_handle,array,start_item,items_count));
  }
//+------------------------------------------------------------------+
//| Write an array of variables of float type.                       |
//| INPUT:  array       - array to write,                            |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to write.               |
//| OUTPUT: number of elements written.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteFloatArray(float& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteArray(m_handle,array,start_item,items_count));
  }
//+------------------------------------------------------------------+
//| Write an array of variables of double type.                      |
//| INPUT:  array       - array to write,                            |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to write.               |
//| OUTPUT: number of elements written.                              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileBin::WriteDoubleArray(double& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteArray(m_handle,array,start_item,items_count));
  }
//+------------------------------------------------------------------+
//| Write data of an instance of the CObject class.                  |
//| INPUT:  object - pointer to an instance of the CObject class.    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::WriteObject(CObject *object)
  {
//--- checking
   if(m_handle<0)            return(false);
   if(!CheckPointer(object)) return(false);
//---
   return(object.Save(m_handle));
  }
//+------------------------------------------------------------------+
//| Read a variable of char or uchar type.                           |
//| INPUT:  value - variable to read.                                |
//| OUTPUT: true if successful, false otherwise.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadChar(char& value)
  {
   bool result=true;
//--- checking
   if(m_handle<0) return(false);
//---
   ResetLastError();
   value=(char)FileReadInteger(m_handle,sizeof(char));
   if(GetLastError()!=0) result=false;
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Read a variable of short or ushort type.                         |
//| INPUT:  value - variable to read.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadShort(short& value)
  {
   bool result=true;
//--- checking
   if(m_handle<0) return(false);
//---
   ResetLastError();
   value=(short)FileReadInteger(m_handle,sizeof(short));
   if(GetLastError()!=0) result=false;
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Read a variable of int or uint type.                             |
//| INPUT:  value - variable to read.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadInteger(int& value)
  {
   bool result=true;
//--- checking
   if(m_handle<0) return(false);
//---
   ResetLastError();
   value=FileReadInteger(m_handle,sizeof(int));
   if(GetLastError()!=0) result=false;
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Read a variable of long or ulong type.                           |
//| INPUT:  value - variable to read.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadLong(long& value)
  {
   bool result=true;
//--- checking
   if(m_handle<0) return(false);
//---
   ResetLastError();
   value=FileReadLong(m_handle);
   if(GetLastError()!=0) result=false;
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Read a variable of float type.                                   |
//| INPUT:  value - variable to read.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadFloat(float& value)
  {
   bool result=true;
//--- checking
   if(m_handle<0) return(false);
//---
   ResetLastError();
   value=FileReadFloat(m_handle);
   if(GetLastError()!=0) result=false;
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Read a variable of double type.                                  |
//| INPUT:  value - variable to read.                                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadDouble(double& value)
  {
   bool result=true;
//--- checking
   if(m_handle<0) return(false);
//---
   ResetLastError();
   value=FileReadDouble(m_handle);
   if(GetLastError()!=0) result=false;
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Read an array of variables of string type.                       |
//| INPUT:  value - string to read.                                  |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadString(string& value)
  {
//--- checking
   if(m_handle<0) return(false);
//---
   int size=FileReadInteger(m_handle);
   value=FileReadString(m_handle,size);
//---
   return(size==StringLen(value));
  }
//+------------------------------------------------------------------+
//| Read a part of string.                                           |
//| INPUT:  value - string to read,                                  |
//|         size  - number of characters to read.                    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadString(string& value,int size)
  {
//--- checking
   if(m_handle<0) return(false);
//---
   value=FileReadString(m_handle,size);
//---
   return(size==StringLen(value));
  }
//+------------------------------------------------------------------+
//| Read an array of variables of char or uchar type.                |
//| INPUT:  array       - array to read,                             |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to read.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadCharArray(char& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(false);
//---
   return(FileReadArray(m_handle,array,start_item,items_count)!=0);
  }
//+------------------------------------------------------------------+
//| Read an array of variables of short or ushort type.              |
//| INPUT:  array       - array to read,                             |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to read.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadShortArray(short& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(false);
//---
   return(FileReadArray(m_handle,array,start_item,items_count)!=0);
  }
//+------------------------------------------------------------------+
//| Read an array of variables of int or uint type.                  |
//| INPUT:  array       - array to read,                             |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to read.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadIntegerArray(int& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(false);
//---
   return(FileReadArray(m_handle,array,start_item,items_count)!=0);
  }
//+------------------------------------------------------------------+
//| Read an array of variables of long or ulong type.                |
//| INPUT:  array       - array to read,                             |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to read.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadLongArray(long& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(false);
//---
   return(FileReadArray(m_handle,array,start_item,items_count)!=0);
  }
//+------------------------------------------------------------------+
//| Read an array of variables of float type.                        |
//| INPUT:  array       - array to read,                             |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to read.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadFloatArray(float& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(false);
//---
   return(FileReadArray(m_handle,array,start_item,items_count)!=0);
  }
//+------------------------------------------------------------------+
//| Read an array of variables of double type.                       |
//| INPUT:  array       - array to read,                             |
//|         start_item  - starting element,                          |
//|         items_count - number of elements to read.                |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadDoubleArray(double& array[],int start_item,int items_count)
  {
//--- checking
   if(m_handle<0) return(false);
//---
   return(FileReadArray(m_handle,array,start_item,items_count)!=0);
  }
//+------------------------------------------------------------------+
//| Read data of an instance of the CObject class.                   |
//| INPUT:  object - pointer to an instance of the CObject class.    |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFileBin::ReadObject(CObject *object)
  {
//--- checking
   if(m_handle<0)            return(false);
   if(!CheckPointer(object)) return(false);
//---
   return(object.Load(m_handle));
  }
//+------------------------------------------------------------------+
