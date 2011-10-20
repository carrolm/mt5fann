//+------------------------------------------------------------------+
//|                                                   icq_visual.mq5 |
//|                        Copyright 2009, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Charts\Chart.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>
#include <icq_mql5.mqh>

#define NUM_WND    3
#define NUM_EDT    4
#define NUM_BTN    8
#define NUM_LBL    9

#define clwnd   Silver     // цвет фона окна
#define cltext  Black      // цвет текста


#define pas_str "********" // маска для пароля

enum logstate {_disconnected = 0, _processed = 1, _connected = 2};
const string namestate[3]  = {"Sign in", "Cancel", "Sign out"};

//+------------------------------------------------------------------+
void StringCopy(string &dest, string src, uint num) // копирование строки
//+------------------------------------------------------------------+
{
  uint count;
  
  if (num == 0) count = StringLen(src);
  else count = MathMin(num, StringLen(src));
  
  StringInit(dest,num+1,0);
  for (uint i=0; i < count; i++)
  StringSetCharacter(dest,i, StringGetCharacter(src,i));
}

//+------------------------------------------------------------------+
struct ar2str // структура для хранения данных о пользователе
//+------------------------------------------------------------------+
{
   string data[][2];                            // хранилище данных
   
   bool Add(uint UIN, string pass)              // добавление данных в массив
   {
      uint range = ArrayRange(data,0); 
      if (ArrayResize(data,range+1) > 0)
      {
         data[range][0]= IntegerToString(UIN);
         data[range][1]= pass; return(true);
      }
      else return(false);
   }
   
   string FindNickName(string uin) // поиск ника в массиве контактов
   {
      string ret=uin;
      
      if (ArrayRange(data,0))
         {
            for(int i=0; i < ArrayRange(data,0); i++)
               if (data[i][0] == uin)
                  if (data[i][1]!="") ret = data[i][1];
         }   
      return(ret);
   }
      
   uint  Total(){return(ArrayRange(data,0));};  // количество элементов массива
   void  Clear(){ArrayFree(data);};             // Удаление всех эл. массива
};

//+------------------------------------------------------------------+
class CIcqChart
//+------------------------------------------------------------------+
{
protected:
   
   CChart                      *chart; // обьект окна
   CChartObjectEdit     *wnd[NUM_WND]; // элементы окна
   CChartObjectEdit     *edt[NUM_EDT]; // поля
   CChartObjectButton   *btn[NUM_BTN]; // кнопки
   CChartObjectLabel    *lbl[NUM_LBL]; // метки
   
   logstate              state;
   COscarClient          icq;
   
public:
   
   bool     go_close;  // флаг закрытия формы
   ar2str   acinfo,    // учетные записи ICQ
            sendto;    // адресная книга 
   
   bool  Init();       // начало программы
   void  Deinit();     // завершение программы
   void  Processing(); // тело программы
   
   void  CIcqChart();  // констрктор
   void ~CIcqChart();  // деструктор
   

};

//координаты и размеры
//Поля ввода(фон)                     0    1     2  
const int          w_x[NUM_WND] = {    0,   0,   20 };
const int          w_y[NUM_WND] = {    0,  20,   80 };
const int      w_sizeX[NUM_WND] = {  440, 440,  400 };
const int      w_sizeY[NUM_WND] = {   20, 220,   60 };
const color    w_color[NUM_WND] = { Navy, clwnd, LightGray};

//Поля ввода(элементы управления)     0      1      2      3 
const int         ed_x[NUM_EDT] = {  120,   260,   120,    20 };
const int         ed_y[NUM_EDT] = {   40,    40,   160,   200 };
const int     ed_sizeX[NUM_EDT] = {  100,   100,   100,   340 };
const int     ed_sizeY[NUM_EDT] = {   20,    20,    20,    20 };
const color  ed_bcolor[NUM_EDT] = {clwnd, clwnd, clwnd, clwnd };

//Кнопки                             0    1    2    3    4    5    6    
const int         bt_x[NUM_BTN] = {  80, 100, 360,  80, 100, 360, 360, 420 };
const int         bt_y[NUM_BTN] = {  40,  40,  40, 160, 160, 140, 200,   0 };
const int     bt_sizeX[NUM_BTN] = {  20,  20,  60,  20,  20,  60,  60,  20 };
const int     bt_sizeY[NUM_BTN] = {  20,  20,  20,  20,  20,  20,  20,  20 };
const string   bt_cap[NUM_BTN]  = {"<",">","Sign in","<",">","Clear","Send","x" };

//Текстовые метки                    0    1    2    3    4    5    6    7     8
const int         lb_x[NUM_LBL] = {   0,  20, 220,  20,  20,  20,  20, 220 , 260 };
const int         lb_y[NUM_LBL] = {   0,  40,  40,  80, 100, 120, 160, 160 , 160 };
const string     l_cap[NUM_LBL] = {" ICQ Client","User ID:"," Pass:"," "," "," ","Send To:"," Nick:"," "};
const color    l_color[NUM_LBL] = {White,cltext,cltext,cltext,cltext,cltext,cltext,cltext,Blue};

//+------------------------------------------------------------------+
void  CIcqChart::CIcqChart(void)
//+------------------------------------------------------------------+
{  
   state        = _disconnected;
   go_close     = false;
   icq.autocon  = false;
   icq.server   = "login.icq.com";
   icq.port     = 5190;
}

//+------------------------------------------------------------------+
void CIcqChart::~CIcqChart()
//+------------------------------------------------------------------+
{
    int i;
   
    sendto.Clear();
    acinfo.Clear();
       
    for(i=0; i<NUM_WND; i++){delete wnd[i];}
    for(i=0; i<NUM_BTN; i++){delete btn[i];}
    for(i=0; i<NUM_EDT; i++){delete edt[i];}
    for(i=0; i<NUM_LBL; i++){delete lbl[i];} 
        
    delete chart;
}

//+------------------------------------------------------------------+
bool CIcqChart::Init(void)
//+------------------------------------------------------------------+
{

   int i;   
   printf("Load Icq Form");
 
   // m_chart
   if ((chart = new CChart) == NULL)
   {printf("Chart not created"); return(false);}
   
  
   //if (chart.Open(Symbol(), Period())==0)
   chart.Attach();
   if (chart.ChartId()==0)
   {printf("Chart not opened");return(false);}
        
   //Поля ввода(фон)
   for(i=0; i < NUM_WND; i++)
   {
      if((wnd[i]= new CChartObjectEdit) == NULL) return(false);
      wnd[i].Create(chart.ChartId(),"BackEdit" + IntegerToString(i),0,w_x[i],w_y[i],w_sizeX[i],w_sizeY[i]);
      wnd[i].Color(w_color[i]);
      wnd[i].BackColor(w_color[i]);      
      wnd[i].SetInteger(OBJPROP_READONLY,true);
      wnd[i].Attach(chart.ChartId(),wnd[i].Description(),0,0);
   }

             
   //Поля ввода(элементы управления)
   for(i=0; i<NUM_EDT; i++)
   {
      if((edt[i]= new CChartObjectEdit)==NULL) return(false);
      edt[i].Create(chart.ChartId(),"Edit" + IntegerToString(i),0,ed_x[i],ed_y[i],ed_sizeX[i],ed_sizeY[i]);
      edt[i].Color(cltext);
      edt[i].BackColor(ed_bcolor[i]);
      //edt[i].SetString(OBJPROP_TEXT, ed_text[i]);      
      edt[i].SetInteger(OBJPROP_READONLY, false);
      edt[i].Attach(chart.ChartId(),edt[i].Description(),0,0);
   }
   
            
   //Кнопки 
   for(i=0; i<NUM_BTN; i++)
   {
      if((btn[i]= new CChartObjectButton)==NULL) return(false);
      btn[i].Create(chart.ChartId(),"Button" + IntegerToString(i),0,bt_x[i],bt_y[i],bt_sizeX[i],bt_sizeY[i]);
      btn[i].Color(cltext);
      btn[i].BackColor(clwnd);      
      btn[i].SetString(OBJPROP_TEXT,bt_cap[i]);
      btn[i].Font("Arial");
      btn[i].FontSize(10);
      btn[i].Attach(chart.ChartId(),btn[i].Description(),0,0);
   }
    

   //Текстовые метки 
   for(i=0; i < NUM_LBL; i++)
   {
      if((lbl[i]= new CChartObjectEdit) == NULL) return(false);
      lbl[i].Create(chart.ChartId(),"Label" + IntegerToString(i),0,lb_x[i],lb_y[i]);
      lbl[i].Color(l_color[i]);
      lbl[i].SetString(OBJPROP_TEXT, l_cap[i]);
      lbl[i].SetInteger(OBJPROP_READONLY, true);
      lbl[i].Attach(chart.ChartId(),lbl[i].Description(),0,0);
   }
   
   // заполнение полей для отображения при старте формы
   if (sendto.Total() > 0) 
   {
      edt[2].SetString(OBJPROP_TEXT, sendto.data[0][0]);
      lbl[8].SetString(OBJPROP_TEXT, sendto.data[0][1]);
   }   
   if (acinfo.Total() > 0) 
   { 
      edt[0].SetString(OBJPROP_TEXT, acinfo.data[0][0]);
      edt[1].SetString(OBJPROP_TEXT, "********");
   }
      
   
   
   return(true);
}

//+------------------------------------------------------------------+
void CIcqChart::Deinit(void)
//+------------------------------------------------------------------+
{
   if (state==_connected) icq.Disconnect();
   chart.Detach();
   ExpertRemove(); // выгрузка эксперта
   printf("Remove Icq Form");
}

//+------------------------------------------------------------------+
void CIcqChart::Processing(void)
//+------------------------------------------------------------------+
{
  static uint index_con = 0; 
  static uint index_acc = 0;
  static datetime savetime;
  int i;
  string strbuf, msg; 
  
  
  //--- Обработчик отправки сообщений -----
  if (state==_connected)
  {
      strbuf = edt[3].GetString(OBJPROP_TEXT);
      if (strbuf != "")
      {
         icq.SendMessage(edt[2].GetString(OBJPROP_TEXT), strbuf);
       //  printf("Send: ", edt[2].GetString(OBJPROP_TEXT),",", strbuf);
         edt[3].SetString(OBJPROP_TEXT,"");
      }
  }
  //---------------------------------------

  // Обработка нажатий кнопок  
  for(i=0; i < NUM_BTN; i++)
  {
   if (btn[i].State())
   {
      btn[i].State(false); // отжатие кнопки
      
      switch(i)
      {
         
         case 0:{ // предыдущий аккаунт
                  
                  if (index_acc > 0 )
                  { 
                     edt[0].SetString(OBJPROP_TEXT, 0, acinfo.data[--index_acc][0] );
                     edt[1].SetString(OBJPROP_TEXT, 0, pas_str );
                  }
                  break;
                } 

         case 1:{ // последующий  аккаунт 
                   if (acinfo.Total() == 0) break;
                   if (index_acc < acinfo.Total() - 1 )
                   { 
                     edt[0].SetString(OBJPROP_TEXT, 0, acinfo.data[++index_acc][0]);
                     edt[1].SetString(OBJPROP_TEXT, 0, pas_str );
                   }
                   break;
                }

         case 2:{ // Кнопка Login
                   switch(state)
                   {
                     
                   case _disconnected:{   // подключение к серверу столько если есть связь
                                       if (TerminalInfoInteger(TERMINAL_CONNECTED)) state = _processed; 
                                       else lbl[0].SetString(OBJPROP_TEXT, l_cap[0] +" Offline"); 
                                       break;
                                    }
                     
                   case _processed:   { state = _disconnected; break; }
                                   
                   case _connected:   { 
                                       state = _disconnected;
                                       icq.Disconnect(); 
                                       break;
                                    }
                    }
                
                }
         
         case 3:{ // предыдущий контакт
                  if (index_con > 0 )
                  { 
                     edt[2].SetString(OBJPROP_TEXT, sendto.data[--index_con][0]);
                     lbl[8].SetString(OBJPROP_TEXT, sendto.data[index_con][1] );
                  }
                  break;
                 } 
         case 4:{ // последующий контакт
                  if (sendto.Total() == 0) break;
                  if (index_con < sendto.Total() -1 )
                  { 
                     edt[2].SetString(OBJPROP_TEXT, sendto.data[++index_con][0]);
                     lbl[8].SetString(OBJPROP_TEXT,sendto.data[index_con][1]);
                  }
                  break;
                } 
         
         case 5:{// очистка истории сообщений
                  lbl[3].SetString( OBJPROP_TEXT, " ");
                  lbl[4].SetString( OBJPROP_TEXT, " ");
                  lbl[5].SetString( OBJPROP_TEXT, " ");
                  break;
                } 
         
         case 6:{break;} 
         
         case 7:{ // закрыть окно компонента
                  if (state==_connected) icq.Disconnect();
                  go_close = true;
                  break;
                 }
      }// end switch
      
   }// end if
  }// end for
  
  
  // подключение к серверу или чтение сообщений
  if (TimeLocal() != savetime) // выполнение операций каждую секунду
  {    
         savetime = TimeLocal(); 
      
         // обновление надписи на кнопке
         btn[2].SetString(OBJPROP_TEXT, namestate[state] );
         lbl[0].SetString(OBJPROP_TEXT, l_cap[0]);
         
         // Подключение к серверу
         if(state == _processed)
         {
                 
            icq.login = edt[0].GetString(OBJPROP_TEXT);
            
            if (edt[1].GetString(OBJPROP_TEXT) != pas_str) 
               icq.password = edt[1].GetString(OBJPROP_TEXT);
            else 
               icq.password = Chart.acinfo.data[index_acc][1];
            if (icq.Connect()) state = _connected;
            
         }
         
         else if(state == _connected)
         {

          //  edt[1].SetString(OBJPROP_TEXT,pas_str); //!
            
            lbl[0].SetString(OBJPROP_TEXT, l_cap[0] +" : " +icq.login);
           
           
            while(icq.ReadMessage(icq.uin, icq.msg, icq.len))
            {
               lbl[5].SetString( OBJPROP_TEXT, 0, lbl[4].GetString(OBJPROP_TEXT) );
               lbl[4].SetString( OBJPROP_TEXT, 0, lbl[3].GetString(OBJPROP_TEXT) ); 
               
               StringCopy(msg,icq.msg,37);// обрезка длины сообщения
               lbl[3].SetString( OBJPROP_TEXT, 0, sendto.FindNickName(icq.uin) + " (" + TimeToString(savetime,TIME_MINUTES) + "): " + msg );
            }  
           
         }
                  
  }

  chart.Redraw(); // перерисовка формы
  Sleep(50);
}


CIcqChart Chart;

//+------------------------------------------------------------------+
int OnStart()
//+------------------------------------------------------------------+
{
   // список учетных записей ICQ 
   Chart.acinfo.Add(266690424, "password");
   Chart.acinfo.Add(641848065, "password");
   Chart.acinfo.Add(610043094, "password");   
   
   // Список контактов
   Chart.sendto.Add(266690424, "avoitenko");
   Chart.sendto.Add(610043094, "meduza");
   Chart.sendto.Add(641848065, "mail");
   

   if(Chart.Init()) // инициализация
   {
      // выполнение тела цикла до принудительного останова - закрытия
      while(!IsStopped()&&(!Chart.go_close))Chart.Processing(); 
   }
   Chart.Deinit();  // деинициализация
   
   return(0);
}
