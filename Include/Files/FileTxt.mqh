//+------------------------------------------------------------------+
//|                                                      FileTxt.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.08 |
//+------------------------------------------------------------------+
#include "File.mqh"
//+------------------------------------------------------------------+
//| Class CFileTxt.                                                  |
//| Purpose: Class of operations with text files.                    |
//|          Derives from class CFile.                               |
//+------------------------------------------------------------------+
class CFileTxt : public CFile
  {
public:
   //--- methods for working with files
   int               Open(const string file_name,int open_flags);
   //--- methods to access data
   uint              WriteString(const string value);
   string            ReadString();
  };
//+------------------------------------------------------------------+
//| Open the text file.                                              |
//| INPUT:  file_name  - name of file,                               |
//|         open_flags - flags ofopening.                            |
//| OUTPUT: handle of opened file, or -1.                            |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CFileTxt::Open(const string file_name,int open_flags)
  {
   int result=CFile::Open(file_name,open_flags|FILE_TXT);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| Writing string to file.                                          |
//| INPUT:  value - string to write.                                 |
//| OUTPUT: number of bytes written.                                 |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
uint CFileTxt::WriteString(const string value)
  {
//--- checking
   if(m_handle<0) return(0);
//---
   return(FileWriteString(m_handle,value));
  }
//+------------------------------------------------------------------+
//| Reading string from file.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: string that is read.                                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
string CFileTxt::ReadString()
  {
//--- checking
   if(m_handle<0) return("");
//---
   return(FileReadString(m_handle));
  }
//+------------------------------------------------------------------+
