class Player
{
int p_num;
String deck_name;
String hero=null;
int heroHP;
ArrayList<Card> deck = new ArrayList<Card>();
ArrayList<Card> hand = new ArrayList<Card>();
ArrayList<Card> table = new ArrayList<Card>();
ArrayList<Card> ress = new ArrayList<Card>();
ArrayList<Card> grave = new ArrayList<Card>();
boolean hand_show = false;
boolean grave_show=false;
int g_scroll=0;
boolean is_deck = false;
int ress_cnt = 0; //active: used ress, passive: total ress
int hand_get = 0; //used for passive hand size
int num_of_tokens=1;
color player_color = color(255);
int cards_online=0;

/*
METHOD LIST:
hand();
DRAW();
Rr();
Rm();
hero();
clear_cards();
loc_save_player();
player_data();
loc_load_player();
make_player();
getSync();
*/

Player(int n,color c)
{
  p_num=n;
  player_color = c;
}

void hand()
{
  stroke(player_color);
  if(this==active)
    {
      if(hand_show)
      {
        line(0,height*mid,width,height*mid);
        if(hero!=null) hero(s(20),int(height*mid-s(120)));
        if(hand.size()<=10)
          for(int i=0;i<hand.size();i++)
          {
            hand.get(i).hand(s(80+(i*120)),height*mid+s(50),s(100));
          }
        else
          for(int i=0;i<10;i++)
          {
            hand.get(i).hand(s(100+(i*110)),height*mid+s(40),s(80));
          }
          for(int i=0;i<hand.size()-10;i++)
          {
            hand.get(i+10).hand(s(100+(i*110)),height*mid+s(160),s(80));
          }
          textSize(s(16));
          textAlign(CENTER);
          fill(player_color);
          text(deck_name,width/2,height*mid+s(15));
          
          text(ress.size()-ress_cnt,width/2+s(240),height*mid+s(20));
          
          if(button(width/2+s(200),height*mid+s(5),s(20),s(20),"C"))  //ress reset
          {
            Rr();
            //sync("head");
          }
          if(button(width/2+s(170),height*mid+s(5),s(20),s(20),"-")) //ress minus
          {
            Rm();
            //sync("head");
          }
          if(button(width/2-s(200),height*mid+s(5),s(60),s(20),"DRAW"))  //draw
          {
            DRAW();
            //sync("head");
          }
          
          textAlign(LEFT);
          textSize(s(14));
          fill(col_gr);
          if(p_num==1) text("G - Grave",s(8),height-s(8));
          else text("G - Grave",width-s(80),height-s(8));
          fill(255);
      }
      else
      {
        fill(player_color);
        line(0,height-s(50),width,height-s(50));
        if(hero!=null) hero(s(20),height-s(170));
        fill(255);
        stroke(0);
        if(deck_name!=null)
        {
          for(int i=0;i<hand.size();i++)
            rect(s(10)+i*(width/20),height-s(30),width/20-s(10),s(31));
        }
        if(!is_deck)
        {
          if(button(s(20),height-s(85),s(130),s(25),"Select Deck")) 
          {
            is_deck=true;
            selectInput("Select deck file","read");
          }
          if(button(s(20),height-s(110),s(100),s(20),"Load Last")) 
          {
            this.loc_load_player();
          }
        }
      }
      if(grave_show) 
      {
        slist(active.grave,s(100),s(100),width-s(200),active.g_scroll,col_gr,"Grave");
        fill(0);
        textSize(12);
        textAlign(LEFT,CENTER);
        text("SPACE - return card to the hand",width-s(340),s(120));
      }  
    }else //P_2
      {
        if(deck_name!=null)
        {
          textSize(s(25));
          fill(player_color);
          textAlign(CENTER);
          text(ress_cnt,width-s(50),s(150));
          fill(255);
          stroke(0);
          for(int i=0;i<hand_get;i++)
            rect(s(10)+i*((width-100)/20),-1,(width-100)/20-s(10),s(26));
         stroke(player_color);
         fill(player_color);
         textAlign(RIGHT);
          textSize(s(16));
          text(deck_name,width-s(10),s(220));
          line(0,s(30),width-s(100),s(30));
        }else
          line(0,s(30),width,s(30));
        if(hero!=null) hero(width-s(80),s(20));
      }
}



public void DRAW() {
  if(deck.size()>0 && hand.size()<20)
  {
  int pos=int(random(0,deck.size()));
    hand.add(deck.get(pos));
    deck.remove(pos);
  }
}
public void Rm() {
 if(ress.size()-ress_cnt>0) ress_cnt++;
}
public void Rr() {
  ress_cnt=0;
}

void hero(int x, int y)
{
  stroke(player_color);
 fill(player_color); 
 rect(x,y,s(60),s(100));
 fill(255);
 stroke(0);
 textAlign(LEFT,TOP);
 textSize(s(12));
 text(hero,x+s(5),y+s(5));
 textSize(s(25));
 textAlign(CENTER,CENTER);
 text(heroHP,x+s(30),y+s(60));
 if(this==active)
 {
   if(button(x+s(1),y+s(80),s(20),s(20),"+"))
   {
     heroHP++;
     //sync("head");
   }
   if(button(x+s(40),y+s(80),s(20),s(20),"-"))
   {
     if(heroHP>1) heroHP--;
     //sync("head");
   }
 }
}

void clear_cards()
{
  hand.clear();
  table.clear();
  ress.clear();
  grave.clear();
  deck.clear();
}

void loc_save_player()
{
  print("Saving Player_"+p_num+" locally... ");
  PrintWriter writer = createWriter("data/save/Player_"+p_num+".txt");
   writer.print(player_data());
  writer.flush();
  println("Done");
}

String player_data()
{
  String str="";
  str+=deck_name + n();
  str+=hero + System.lineSeparator();
  str+=str(heroHP) + n();
  str+=str(ress_cnt) + n();
  str+=str(num_of_tokens) + n();
  str+="HAND" + n();
  for(int i=0;i<hand.size();i++)
    str+=hand.get(i).log() + n();
  str+="TABLE" + n();
  for(int i=0;i<table.size();i++)
   str+=table.get(i).log() + n();
  str+="RESS" + n();
  for(int i=0;i<ress.size();i++)
    str+=ress.get(i).log() + n();
  str+="GRAVE" + n();
  for(int i=0;i<grave.size();i++)
    str+=grave.get(i).log() + n();
  str+="DECK";
  for(int i=0;i<deck.size();i++)
    str+=n() + deck.get(i).log();
  return str;
}

void loc_load_player()
{
  print("Loading Player_"+p_num+" locally... ");
 String[] lines=loadStrings("data/save/Player_"+p_num+".txt");
 if(lines==null) return;
  if(lines.length<2) return;
  deck_name=lines[0];
  if(deck_name==null) return;
  if(deck_name.equals("null")) return;
  make_player(lines);
  is_deck=true;
  println("Done");
}

void make_player(String[] lines)
{
  hero=lines[1];
  heroHP=int(lines[2]);
  ress_cnt=int(lines[3]);
  num_of_tokens=int(lines[4]);
  clear_cards();
  int i=6;
  while(!lines[i].equals("TABLE"))
    {
    hand.add(new Card(lines[i],this));
    i++;
    }
    i++;
  while(!lines[i].equals("RESS"))
    {
    table.add(new Card(lines[i],this));
    i++;
    }
    i++;
  while(!lines[i].equals("GRAVE"))
    {
    ress.add(new Card(lines[i],this));
    i++;
    }
    i++;
  while(!lines[i].equals("DECK"))
    {
    grave.add(new Card(lines[i],this));
    i++;
    }
    i++;
  while(i<lines.length)
    {
    deck.add(new Card(lines[i],this));
    i++;
    }
}

void loadDeck(int deck_num)
{
  processing.data.JSONObject dData = JSON.make(RestClient.getReq(deck_num,"decks"));
  deck_name=dData.getString("name");
  hero=dData.getString("hero");
  heroHP=int(dData.getString("heroHP"));
  
  processing.data.JSONObject pData = JSON.make(RestClient.getReq(p_num-1,"players"));
  pData.setString("deck",str(deck_num));
  pData.setString("hero_hp",str(heroHP));
  String send=pData.toString();
  RestClient.putReq(p_num-1,"players",send);
  
  processing.data.JSONArray dcArray = JSON.makeArray(RestClient.getAllReq("deck_cards"));
  for(int i=0;i<dcArray.size();i++)
    if(dcArray.getJSONObject(i).getInt("deck_ID")==deck_num)
    {
      int cardID=int(dcArray.getJSONObject(i).getString("card_ID"));
      processing.data.JSONObject cObj = JSON.make(RestClient.getReq(cardID,"cards"));
      deck.add(new Card(this,cObj,cardID));
    }
  is_deck=true;
}

void sync()
{
  processing.data.JSONObject pData = JSON.make(RestClient.getReq(p_num-1,"players"));
  processing.data.JSONArray tArray = JSON.makeArray(RestClient.getAllReq("table"));
  
  if(pData==null) return;
  if(pData.size()<5) return;
  if(pData.getString("clear").equals("true")) return;
  
  if(this==active)
  {
      pData.setString("hero_hp",str(heroHP));
      pData.setString("ress",str(ress.size()-ress_cnt));
      pData.setString("on_hand",str(hand.size()));
      String send=pData.toString();
      RestClient.putReq(p_num-1,"players",send);
      
      int pZero=20*(p_num-1);
       
       for(int i=0;i<cards_online;i++)
       {
         if(i<table.size())
         {
            processing.data.JSONObject card = new processing.data.JSONObject();
            card.setString("player_ID",str(p_num-1));
            card.setString("card_ID",str(table.get(i).id));
            card.setString("hp",str(table.get(i).hp));
            card.setString("dmg",str(table.get(i).dmg));
            card.setString("counters",str(table.get(i).counter));
            card.setString("exsisted",str(table.get(i).exsisted));
            send=card.toString();
            RestClient.putReq(pZero+i,"table",send);
         }else
         {
           RestClient.putReq(pZero+i,"table",new processing.data.JSONObject().toString());
         }
       }
       cards_online=table.size();
  }else
  {    
    processing.data.JSONObject dData = JSON.make(RestClient.getReq(int(pData.getString("deck")),"decks"));     //DZIKIE NULL POINTERY
    
    heroHP=int(pData.getString("hero_hp"));
    ress_cnt=int(pData.getString("ress"));
    hand_get=int(pData.getString("on_hand"));
    deck_name=dData.getString("name");
    hero=dData.getString("hero");
    
    table.clear();
    int pZero=20*(p_num-1);
    for(int i=pZero;i<pZero+20;i++)
    {
      println(tArray.getJSONObject(i));
      if(tArray.getJSONObject(i).getString("card_ID")==null) return;
        int cardID=int(tArray.getJSONObject(i).getString("card_ID"));
        processing.data.JSONObject cData = JSON.make(RestClient.getReq(cardID,"cards"));
        processing.data.JSONObject card = new processing.data.JSONObject();
        card.setString("card_ID",str(cardID));
        card.setString("hp",tArray.getJSONObject(i).getString("hp"));
        card.setString("dmg",tArray.getJSONObject(i).getString("dmg"));
        card.setString("counters",tArray.getJSONObject(i).getString("counters"));
        card.setString("exsisted",tArray.getJSONObject(i).getString("exsisted"));
        card.setString("cost",cData.getString("cost"));
        card.setString("name",cData.getString("name"));
        card.setString("type",cData.getString("type"));
        table.add(new Card(this,card,cardID));
    }
  }
}

}//class
