double od_forecast(datetime time,string smb)  
 {
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 10:03:00")) return(-1);
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 10:13:00")) return(-1);
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 12:01:00")) return(1);
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 16:33:00")) return(-1);
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 16:37:00")) return(-1);
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 16:38:00")) return(-1);
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 16:39:00")) return(-1);
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 16:54:00")) return(-1);
  if(smb=="EURUSD" && time==StringToTime("2015.06.01 16:59:00")) return(-1);
  return(0);
 }
