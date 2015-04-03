//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2010, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
input bool MultiplayCurr=false;// MultiPair ÃÌÓ„Ó Ô‡
input bool _EURUSD_=true;//Euro vs US Dollar
input bool _GBPUSD_=false;//Great Britain Pound vs US Dollar
input bool _USDCHF_=false;//US Dollar vs Swiss Franc
input bool _USDJPY_=false;//US Dollar vs Japanese Yen
input bool _USDCAD_=false;//US Dollar vs Canadian Dollar
input bool _AUDUSD_=false;//Australian Dollar vs US Dollar
//input bool _NZDUSD_=false;//New Zealand Dollar vs US Dollar
                          //input bool _USDSEK_=false;//US Dollar vs Sweden Kronor
// crosses
/////input bool _AUDNZD_=true;//Australian Dollar vs New Zealand Dollar
/////input bool _AUDCAD_=true;//Australian Dollar vs Canadian Dollar
//input bool _AUDCHF_=true;//Australian Dollar vs Swiss Franc
input bool _AUDJPY_=false;//Australian Dollar vs Japanese Yen
//input bool _CHFJPY_=false;//Swiss Frank vs Japanese Yen
input bool _EURGBP_=false;//Euro vs Great Britain Pound 
//input bool _EURAUD_=false;//Euro vs Australian Dollar
input bool _EURCHF_=false;//Euro vs Swiss Franc
input bool _EURJPY_=false;//Euro vs Japanese Yen

input bool _USDSEK_=false;//US Dollar vs Sweden Kronor
// crosses
input bool _AUDNZD_=false;//Australian Dollar vs New Zealand Dollar
input bool _AUDCAD_=false;//Australian Dollar vs Canadian Dollar
input bool _AUDCHF_=false;//Australian Dollar vs Swiss Franc
input bool _CHFJPY_=false;//Swiss Frank vs Japanese Yen
input bool _EURAUD_=false;//Euro vs Australian Dollar
input bool _EURNZD_=false;//Euro vs New Zealand Dollar
input bool _EURCAD_=false;//Euro vs Canadian Dollar
input bool _GBPCHF_=false;//Great Britain Pound vs Swiss Franc
input bool _GBPJPY_=false;//Great Britain Pound vs Japanese Yen
input bool _CADCHF_=false;//Canadian Dollar vs Swiss Franc
string SymbolsArray[30];
int MaxSymbols=0;
//+------------------------------------------------------------------+
//| —Œ«ƒ¿®“ —œ»—Œ  ƒŒ—“”œÕ€’ ¬¿Àﬁ“Õ€’ —»Ã¬ŒÀŒ¬ |
//+------------------------------------------------------------------+
void CPInit()
  {
   if(MultiplayCurr)
     {
      if(_EURUSD_) SymbolsArray[MaxSymbols++]="EURUSD";//Euro vs US Dollar
      if(_GBPUSD_) SymbolsArray[MaxSymbols++]="GBPUSD";//Euro vs US Dollar
      if(_AUDUSD_) SymbolsArray[MaxSymbols++]="AUDUSD";//Euro vs US Dollar
//      if(_NZDUSD_) SymbolsArray[MaxSymbols++]="NZDUSD";//Euro vs US Dollar
      if(_USDCHF_) SymbolsArray[MaxSymbols++]="USDCHF";//Euro vs US Dollar
      if(_USDJPY_) SymbolsArray[MaxSymbols++]="USDJPY";//Euro vs US Dollar
      if(_USDCAD_) SymbolsArray[MaxSymbols++]="USDCAD";//Euro vs US Dollar
      if(_USDSEK_) SymbolsArray[MaxSymbols++]="USDSEK";//Euro vs US Dollar
      if(_AUDNZD_) SymbolsArray[MaxSymbols++]="AUDNZD";//Euro vs US Dollar
      if(_AUDCAD_) SymbolsArray[MaxSymbols++]="AUDCAD";//Euro vs US Dollar
      if(_AUDCHF_) SymbolsArray[MaxSymbols++]="AUDCHF";//Euro vs US Dollar
      if(_AUDJPY_) SymbolsArray[MaxSymbols++]="AUDJPY";//Euro vs US Dollar
      if(_CHFJPY_) SymbolsArray[MaxSymbols++]="CHFJPY";//Euro vs US Dollar
      if(_EURGBP_) SymbolsArray[MaxSymbols++]="EURGBP";//Euro vs US Dollar
      if(_EURAUD_) SymbolsArray[MaxSymbols++]="EURAUD";//Euro vs US Dollar
      if(_EURCHF_) SymbolsArray[MaxSymbols++]="EURCHF";//Euro vs US Dollar
      if(_EURJPY_) SymbolsArray[MaxSymbols++]="EURJPY";//Euro vs US Dollar
      if(_EURNZD_) SymbolsArray[MaxSymbols++]="EURNZD";//Euro vs US Dollar
      if(_EURCAD_) SymbolsArray[MaxSymbols++]="EURCAD";//Euro vs US Dollar
      if(_GBPCHF_) SymbolsArray[MaxSymbols++]="GBPCHF";//Euro vs US Dollar
      if(_GBPJPY_) SymbolsArray[MaxSymbols++]="GBPJPY";//Euro vs US Dollar
      if(_CADCHF_) SymbolsArray[MaxSymbols++]="CADCHF";//Euro vs US Dollar
     }
   else
     {
      SymbolsArray[MaxSymbols++]=_Symbol;
     }
  }
//+------------------------------------------------------------------+
