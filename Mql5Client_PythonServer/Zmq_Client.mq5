// https://zeromq.org/languages/python/
// https://github.com/dingmaotu/mql-zmq#introduction

#include <Zmq/Zmq.mqh>

extern string PROJECT_NAME = "TradeServer";
// CREATE ZeroMQ Context
Context context(PROJECT_NAME);

// CREATE ZMQ_REP SOCKET
Socket socket(context,ZMQ_REQ);

//OnInit
int OnInit()
  {
   Print("Connecting to hello world server…");
   socket.connect("tcp://127.0.0.1:5555");

   return(INIT_SUCCEEDED);
  }
//-- OnDeinit
void OnDeinit(const int reason)
  {
   socket.unbind("tcp://127.0.0.1:5555");
  }
//-- OnTick
void OnTick()
  {
   int rnd = 1000 + MathRand()%1000;
   string messge_send = "MQL5 Client " + IntegerToString(rnd);
   
   ZmqMsg request(messge_send);
   socket.send(request);

   ZmqMsg reply;
   socket.recv(reply, false);             // Get the reply.

   if(reply.size() > 0)
     {
      uchar myData[];
      // Get data from request
      ArrayResize(myData, reply.size());
      reply.getData(myData);
      string dataStr = CharArrayToString(myData);
      Print(dataStr);
     }
   Sleep(1000);
  }
//+------------------------------------------------------------------+
