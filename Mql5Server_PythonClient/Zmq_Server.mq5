//+------------------------------------------------------------------+
//|                                                   Zmq_Server.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Zmq/Zmq.mqh>

extern string PROJECT_NAME = "TradeServer";
// CREATE ZeroMQ Context
Context context(PROJECT_NAME);

// CREATE ZMQ_REP SOCKET
Socket socket(context,ZMQ_REP);

//-- OnInit
int OnInit()
  {
   Print("Connecting to hello world server…");
   socket.bind("tcp://*:5555");
   return(INIT_SUCCEEDED);
  }
//-- OnDeinit
void OnDeinit(const int reason)
  {
   socket.unbind("tcp://*:5555");
  }
//-- OnTick
void OnTick()
  {
   ZmqMsg request;
   socket.recv(request,true);

   if(request.size() > 0)
     {
      uchar myData[];
      // Get data from request
      ArrayResize(myData, request.size());
      request.getData(myData);
      string dataStr = CharArrayToString(myData);
      Print(dataStr);

      // envia dados
      ZmqMsg reply(TimeToString(TimeCurrent()));
      socket.send(reply);
     }
  }
//+------------------------------------------------------------------+
