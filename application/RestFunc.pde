 boolean checkConnection()
{
  RestClient.setAddress();
  println(RestClient.url);
  String req = RestClient.getReq(0,"players");
  if(req==null)
    return false;
  else
    return true;
}

void defragment(String entity)
{
  int pos=0;
  int cnt=0;
  int len=JSON.makeArray(RestClient.getAllReq(entity)).size();
  String[] lines = new String[len];
  while(cnt<len)
  {
    String file = RestClient.getReq(pos,entity);
    RestClient.delReq(pos,entity);
    if(file!=null)
      if(file.length()>2)
      {
        lines[cnt]=file;
        cnt++;
      }
    if(pos>100) break;
    pos++;
  }
  for(int i=0;i<cnt;i++)
  {
    if(lines[i].length()>5)
    {
     processing.data.JSONObject data = JSON.make(lines[i]);
     data.setString("id",null);
    RestClient.postReq(entity,data.toString());
    }
  }
}

void process()
{
  processing.data.JSONObject pData = JSON.make(RestClient.getReq(active.p_num-1,"players"));
  pData.setString("process","true");
  String send=pData.toString();
  RestClient.putReq(active.p_num-1,"players",send);
  //println("set to true");
}
    
    void clearEntity(String entity)
    {
      String raw = RestClient.getAllReq(entity);
      processing.data.JSONArray data = JSON.makeArray(raw);
      int len=data.size();
      for(int i=len-1;i>=0;i--)
        RestClient.delReq(i,entity);
      println(RestClient.getAllReq(entity));
    }
    
    public static String[] listEntity(String entity, String param)
    {
      String raw=RestClient.getAllReq(entity);
      processing.data.JSONArray data = JSON.makeArray(raw);
      String[] labels=new String[data.size()];
      for(int i=0;i<data.size();i++)
        labels[i]=data.getJSONObject(i).getString(param);
        return labels;
    }
    
    void format(Player p)
    {
      processing.data.JSONArray dcArray = JSON.makeArray(RestClient.getAllReq("deck_cards"));
      processing.data.JSONObject pData = JSON.make(RestClient.getReq(p.p_num-1,"players"));
      
      String send=pData.toString();
      RestClient.putReq(p.p_num-1,"players",send);
      
     if(pData.getString("clear").equals("true")) return;
        
      processing.data.JSONArray tArray = JSON.makeArray(RestClient.getAllReq("table"));
      
      int pZero=20*(p.p_num-1);
      
      for(int i=pZero;i<pZero+20;i++)
      {
          RestClient.putReq(i,"table",new processing.data.JSONObject().toString());
      }
      
      pData.setString("deck",null);
      pData.setString("hero_hp",null);
      pData.setString("ress",null);
      pData.setString("on_hand",null);
      pData.setString("clear","true");
      pData.setString("process","false");
      send=pData.toString();
      RestClient.putReq(p.p_num-1,"players",send);
    }
    
    void create(Player p)
    {
      processing.data.JSONObject pData = JSON.make(RestClient.getReq(p.p_num-1,"players"));
      if(pData.getString("clear").equals("false")) format(p);
      
      pData.setString("clear","false");
      pData.setString("ress","0");
      pData.setString("on_hand","0");
      
      String send=pData.toString();
      RestClient.putReq(p.p_num-1,"players",send);
    }
    
    
    
    
    
    
    
