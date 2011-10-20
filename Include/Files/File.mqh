//+------------------------------------------------------------------+
//|                                                     MQL5File.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.08 |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CFile.                                                     |
//| Purpose: Base class of file operations.                          |
//|          Derives from class CObject.                             |
//+------------------------------------------------------------------+
class CFile : public CObject
  {
protected:
   int               m_handle;             // handle of file
   string            m_name;               // name of opened file
   int               m_flags;              // flags of opened file
public:
                     CFile();
                    ~CFile();
   //--- methods of access to protected data
   int               Handle()              { return(m_handle); };
   string            FileName()            { return(m_name);   };
   int               Flags()               { return(m_flags);  };
   void              SetUnicode(bool unicode);
   void              SetCommon(bool common);
   //--- general methods for working with files
   int               Open(const string file_name,int open_flags,short delimiter='\t');
   void              Close();
   void              Delete();
   void              Delete(const string file_name);
   bool              IsExist(const string file_name);
   bool              Copy(const string src_name,int common_flag,const string dst_name,int mode_flags);
   bool              Move(const string src_name,int common_flag,const string dst_name,int mode_flags);
   ulong             Size();
   ulong             Tell();
   void              Seek(long offset,ENUM_FILE_POSITION origin);
   void              Flush();
   bool              IsEnding();
   bool              IsLineEnding();
   //--- general methods of working with folders
   bool              FolderCreate(const string folder_name);
   bool              FolderDelete(const string folder_name);
   bool              FolderClean(const string folder_name);
   //--- general methods of finding files
   long              FileFindFirst(const string file_filter,string& returned_filename);
   bool              FileFindNext(long search_handle,string& returned_filename);
   void              FileFindClose(long search_handle);
  };
//+------------------------------------------------------------------+
//| Constructor CFile.                                               |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CFile::CFile()
  {
//--- initialize protected data
   m_handle=-1;
   m_name="";
//--- default text encoding - ANSI
   m_flags=FILE_ANSI;
  }
//+------------------------------------------------------------------+
//| Destructor CFile.                                                |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CFile::~CFile()
  {
   if(m_handle>=0) Close();
  }
//+------------------------------------------------------------------+
//| Set the FILE_UNICODE flag.                                       |
//| INPUT:  unicode - new value of the FILE_UNICODE flag.            |
//| OUTPUT: no.                                                      |
//| REMARK: flag cannot be changed if the file is already opened.    |
//+------------------------------------------------------------------+
void CFile::SetUnicode(bool unicode)
  {
//--- checking
   if(m_handle>=0) return;
//---
   if(unicode) m_flags|=FILE_UNICODE;
   else        m_flags^=FILE_UNICODE;
  }
//+------------------------------------------------------------------+
//| Set the "Common Folder" flag.                                    |
//| INPUT:  common - new value of the "Common Folder" flag.          |
//| OUTPUT: no.                                                      |
//| REMARK: flag cannot be changed if the file is already opened.    |
//+------------------------------------------------------------------+
void CFile::SetCommon(bool common)
  {
//--- checking
   if(m_handle>=0) return;
//---
   if(common) m_flags|=FILE_COMMON;
   else       m_flags^=FILE_COMMON;
  }
//+------------------------------------------------------------------+
//| Open file.                                                       |
//| INPUT:  file_name - name of file,                                |
//|         open_flags- flags of opening,                            |
//|         delimiter - separator for CSV-file.                      |
//| OUTPUT: handle of the opened file or -1.                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CFile::Open(const string file_name,int open_flags,short delimiter)
  {
//--- checking
   if(m_handle>=0) Close();
//---
   if((open_flags&(FILE_BIN|FILE_CSV))==0) open_flags|=FILE_TXT;
   m_handle=FileOpen(file_name,open_flags|m_flags,delimiter);
   if(m_handle>=0)
     {
      //--- store options of the opened file
      m_flags|=open_flags;
      m_name=file_name;
     }
//---
   return(m_handle);
  }
//+------------------------------------------------------------------+
//| Close file.                                                      |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CFile::Close()
  {
//--- checking
   if(m_handle<0) return;
//--- closing the file and resetting all the variables to the initial state
   FileClose(m_handle);
   m_handle=-1;
   m_name="";
//--- reset all flags except the text
   m_flags&=FILE_ANSI|FILE_UNICODE;
  }
//+------------------------------------------------------------------+
//| Deleting an open file.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CFile::Delete()
  {
//--- checking
   if(m_handle<0) return;
//---
   string file_name=m_name;
   Close();
   FileDelete(file_name,m_flags&FILE_COMMON);
  }
//+------------------------------------------------------------------+
//| Deleting a file.                                                 |
//| INPUT:  file_name - name of file.                                |
//| OUTPUT: no.                                                      |
//| REMARK: uses the FILE_COMMON flag in m_flags.                    |
//+------------------------------------------------------------------+
void CFile::Delete(const string file_name)
  {
//--- checking
   if(file_name==m_name) Close();
//---
   FileDelete(file_name,m_flags&FILE_COMMON);
  }
//+------------------------------------------------------------------+
//| Check if file exists.                                            |
//| INPUT:  file_name - name of file.                                |
//| OUTPUT: true if the file exists, false if not.                   |
//| REMARK: uses the FILE_COMMON flag in m_flags.                    |
//+------------------------------------------------------------------+
bool CFile::IsExist(const string file_name)
  {
   return(FileIsExist(file_name,m_flags&FILE_COMMON));
  }
//+------------------------------------------------------------------+
//| Copying file.                                                    |
//| INPUT:  src_name    - name of source file,                       |
//|         common_flag - common flag of source file,                |
//|         dst_name    - name of destination file,                  |
//|         mode_flags  - flags of destination file.                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFile::Copy(const string src_name,int common_flag,const string dst_name,int mode_flags)
  {
   return(FileCopy(src_name,common_flag,dst_name,mode_flags));
  }
//+------------------------------------------------------------------+
//| Move/rename file.                                                |
//| INPUT:  src_name    - name of source file,                       |
//|         common_flag - common flag of source file,                |
//|         dst_name    - name of destination file,                  |
//|         mode_flags  - flags of destination file.                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFile::Move(const string src_name,int common_flag,const string dst_name,int mode_flags)
  {
   return(FileMove(src_name,common_flag,dst_name,mode_flags));
  }
//+------------------------------------------------------------------+
//| Get size of opened file.                                         |
//| INPUT:  no.                                                      |
//| OUTPUT: size of opened file.                                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ulong CFile::Size()
  {
//--- checking
   if(m_handle<0) return(ULONG_MAX);
//---
   return(FileSize(m_handle));
  }
//+------------------------------------------------------------------+
//| Get current position of pointer in file.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: current position of pointer in file.                     |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
ulong CFile::Tell()
  {
//--- checking
   if(m_handle<0) return(ULONG_MAX);
//---
   return(FileTell(m_handle));
  }
//+------------------------------------------------------------------+
//| Set position of pointer in file.                                 |
//| INPUT:  offset - offset in bytes,                                |
//|         origin - start point for the offset.                     |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CFile::Seek(long offset,ENUM_FILE_POSITION origin)
  {
//--- checking
   if(m_handle<0) return;
//---
   FileSeek(m_handle,offset,origin);
  }
//+------------------------------------------------------------------+
//| Flush data from the file buffer of input-output to disk.         |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CFile::Flush()
  {
//--- checking
   if(m_handle<0) return;
//---
   FileFlush(m_handle);
  }
//+------------------------------------------------------------------+
//| Detect the end of file.                                          |
//| INPUT:  no.                                                      |
//| OUTPUT: true - if the end of file is reached, false if not.      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFile::IsEnding()
  {
//--- checking
   if(m_handle<0) return(false);
//---
   return(FileIsEnding(m_handle));
  }
//+------------------------------------------------------------------+
//| Detect the end of string.                                        |
//| INPUT:  no.                                                      |
//| OUTPUT: true - if the end of string is reached, false if not.    |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFile::IsLineEnding()
  {
//--- checking
   if(m_handle<0)            return(false);
   if((m_flags&FILE_BIN)!=0) return(false);
//---
   return(FileIsLineEnding(m_handle));
  }
//+------------------------------------------------------------------+
//| Create folder.                                                   |
//| INPUT:  folder_name - name of folder.                            |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: uses the FILE_COMMON flag in m_flags.                    |
//+------------------------------------------------------------------+
bool CFile::FolderCreate(const string folder_name)
  {
   return(FolderCreate(folder_name,m_flags&FILE_COMMON));
  }
//+------------------------------------------------------------------+
//| Delete folder.                                                   |
//| INPUT:  folder_name - name of folder.                            |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: uses the FILE_COMMON flag in m_flags.                    |
//+------------------------------------------------------------------+
bool CFile::FolderDelete(const string folder_name)
  {
   return(FolderDelete(folder_name,m_flags&FILE_COMMON));
  }
//+------------------------------------------------------------------+
//| Clean folder.                                                    |
//| INPUT:  folder_name - name of folder.                            |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: uses the FILE_COMMON flag in m_flags.                    |
//+------------------------------------------------------------------+
bool CFile::FolderClean(const string folder_name)
  {
   return(FolderClean(folder_name,m_flags&FILE_COMMON));
  }
//+------------------------------------------------------------------+
//| Start search of files.                                           |
//| INPUT:  file_filter - search filter,                             |
//|         returned_filename - reference to the string in which the |
//|         name of the first found file will be returned.           |
//| OUTPUT: search handle if successful, otherwise -1.               |
//| REMARK: uses the FILE_COMMON flag in m_flags.                    |
//+------------------------------------------------------------------+
long CFile::FileFindFirst(const string file_filter,string& returned_filename)
  {
   return(FileFindFirst(file_filter,returned_filename,m_flags&FILE_COMMON));
  }
//+------------------------------------------------------------------+
//| Continue search of files.                                        |
//| INPUT:  search_handle - search handle,                           |
//|         returned_filename - reference to the string in which the |
//|         name of the found file will be returned.                 |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CFile::FileFindNext(long search_handle,string& returned_filename)
  {
   return(FileFindNext(search_handle,returned_filename));
  }
//+------------------------------------------------------------------+
//| End search of files.                                             |
//| INPUT:  search_handle - search handle.                           |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CFile::FileFindClose(long search_handle)
  {
   FileFindClose(search_handle);
  }
//+------------------------------------------------------------------+
