import org.json.*;
class JSON
{
static processing.data.JSONObject make(String data)
{
  processing.data.JSONObject jfile=new processing.data.JSONObject();
  if(data==null) return jfile;
  if(data.length()<2) return jfile;
  if(data.charAt(0)!='[')
  {
    int pos=0;
    int cnt=-1;
    while(pos!=-1)
    {
      cnt++;
      pos=data.indexOf(':',pos+1);
    }
    pos=2;
    for(int i=0;i<cnt;i++)
    {
      while(data.charAt(pos)!=':') pos++;
      int shift=pos-2;
      while(data.charAt(shift)!='"') shift--;
      String name = data.substring(shift+1,pos-1);
      if(data.charAt(pos+1)=='"')
      {
        shift=pos+2;
        while(data.charAt(shift)!='"') shift++;
        pos++;
      }else
      {
        shift=pos+1;
        while(data.charAt(shift)!=',' && data.charAt(shift)!='}') shift++;
      }
      String val = data.substring(pos+1,shift);
      if(!name.equals("id")) jfile.setString(name,val);
      pos++;
    }
  }
  return jfile;
}

static processing.data.JSONArray makeArray(String data)
{
  processing.data.JSONArray jarray= new processing.data.JSONArray();
  if(data==null) return jarray;
  if(data.length()<2) return jarray;
  if(data.charAt(0)=='[')
  {
    int pos=0;
    int cnt=-1;
    while(pos!=-1)
    {
      cnt++;
      pos=data.indexOf('{',pos+1);
    }
    pos=0;
    for(int i=0;i<cnt;i++)
    {
      pos++;
      int shift=pos;
      while(data.charAt(shift)!='}') shift++;
      shift++;
      String sub=data.substring(pos,shift);
      jarray.setJSONObject(i,make(sub));
      pos=shift;
    }
  }
  return jarray;
}

static int ArrayLen(processing.data.JSONArray file)
{
  int cnt=0;
  while(!file.isNull(cnt)) cnt++;
  return cnt;
}
} //CLASS
