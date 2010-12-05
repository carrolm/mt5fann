//+------------------------------------------------------------------+
//|                                                     TreeNode.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                                              Revision 2010.02.22 |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CTreeNode.                                                 |
//| Purpose: Base class of node of binary tree CTree.                |
//|          Derives from class CObject.                             |
//+------------------------------------------------------------------+
class CTreeNode : public CObject
  {
protected:
   CTreeNode        *m_p_node;             // link to node up
   CTreeNode        *m_l_node;             // link to node left
   CTreeNode        *m_r_node;             // link to node right
   //---
   uint              m_balance;            // balance of node
   uint              m_l_balance;          // balance of the left branch
   uint              m_r_balance;          // balance of the right branch
public:
                     CTreeNode();
                    ~CTreeNode();
   //--- methods of access to protected data
   CTreeNode        *Parent()                { return(m_p_node);    }
   void              Parent(CTreeNode *node) { m_p_node=node;       }
   CTreeNode        *Left()                  { return(m_l_node);    }
   void              Left(CTreeNode *node)   { m_l_node=node;       }
   CTreeNode        *Right()                 { return(m_r_node);    }
   void              Right(CTreeNode *node)  { m_r_node=node;       }
   int               Balance() const         { return(m_balance);   }
   int               BalanceL() const        { return(m_l_balance); }
   int               BalanceR() const        { return(m_r_balance); }
   //--- method of identifying the object
   virtual int       Type() const            { return(0x8888);      }
   //--- methods for controlling
   int               RefreshBalance();
   CTreeNode*        GetNext(CTreeNode *node);
   //--- methods for working with files
   bool              SaveNode(int file_handle);
   bool              LoadNode(int file_handle,CTreeNode *main);
protected:
   //--- method for creating an instance of class
   virtual CTreeNode* CreateSample()         { return(NULL);        }
  };
  
//+------------------------------------------------------------------+
//| Constructor CTreeNode.                                           |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTreeNode::CTreeNode()
  {
//--- initialize protected data
   m_p_node   =NULL;
   m_l_node   =NULL;
   m_r_node   =NULL;
   m_balance  =0;
   m_l_balance=0;
   m_r_balance=0;
  }
//+------------------------------------------------------------------+
//| Destructor CTreeNode.                                            |
//| INPUT:  no.                                                      |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CTreeNode::~CTreeNode()
  {
//--- deleting nodes of the next level
   if(m_l_node!=NULL) delete m_l_node;
   if(m_r_node!=NULL) delete m_r_node;
  }
//+------------------------------------------------------------------+
//| Calculating the balance of the node.                             |
//| INPUT:  no.                                                      |
//| OUTPUT: balance of node.                                         |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CTreeNode::RefreshBalance()
  {
//--- calculating the balance of the left branch
   if(m_l_node==NULL) m_l_balance=0;
   else               m_l_balance=m_l_node.RefreshBalance();
//--- calculating the balance of the right branch
   if(m_r_node==NULL) m_r_balance=0;
   else               m_r_balance=m_r_node.RefreshBalance();
//--- calculating the balance of the node
   if(m_r_balance>m_l_balance) m_balance=m_r_balance+1;
   else                        m_balance=m_l_balance+1;
//---
   return(m_balance);
  }
//+------------------------------------------------------------------+
//| Selecting next node.                                             |
//| INPUT:  node - pointer to the base node.                         |
//| OUTPUT: pointer of the next node.                                |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
CTreeNode* CTreeNode::GetNext(CTreeNode *node)
  {
   if(Compare(node)>0) return(m_l_node);
//---
   return(m_r_node);
  }
//+------------------------------------------------------------------+
//| Writing node data to file.                                       |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for writing.                                             |
//| OUTPUT: true if OK, else false.                                  |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTreeNode::SaveNode(int file_handle)
  {
   bool result=true;
//--- checking
   if(file_handle<0) return(false);
//--- writing left node (if it is available)
   if(m_l_node!=NULL)
     {
      FileWriteInteger(file_handle,'L',SHORT_VALUE);
      result&=m_l_node.SaveNode(file_handle);
     }
   else
      FileWriteInteger(file_handle,'X',SHORT_VALUE);
//--- writing data of current node
   result&=Save(file_handle);
//--- writing right node (if it is available)
   if(m_r_node!=NULL)
     {
      FileWriteInteger(file_handle,'R',SHORT_VALUE);
      result&=m_r_node.SaveNode(file_handle);
     }
   else
      FileWriteInteger(file_handle,'X',SHORT_VALUE);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Reading node data from file.                                     |
//| INPUT:  file_handle - handle of file previously opened           |
//|         for reading.                                             |
//| OUTPUT: true if successful, false if not.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
bool CTreeNode::LoadNode(int file_handle,CTreeNode *main)
  {
   bool       result=true;
   short      s_val;
   CTreeNode *node;
//--- checking
   if(file_handle<0) return(false);
//--- reading directions
   s_val=(short)FileReadInteger(file_handle,SHORT_VALUE);
   if(s_val=='L')
     {
//--- reading left node (if there is data)
      node=CreateSample();
      if(node==NULL) return(false);
      m_l_node=node;
      node.Parent(main);
      result&=node.LoadNode(file_handle,node);
     }
//--- reading data of current node
   result&=Load(file_handle);
//--- reading directions
   s_val=(short)FileReadInteger(file_handle,SHORT_VALUE);
   if(s_val=='R')
     {
//--- reading right node (if there is data)
      node=CreateSample();
      if(node==NULL) return(false);
      m_r_node=node;
      node.Parent(main);
      result&=node.LoadNode(file_handle,node);
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
  
