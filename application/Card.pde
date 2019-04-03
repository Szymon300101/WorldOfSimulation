class Card
{
  Player p;    //owner
  int id;      //id of original card in 'cards'
  String name;
  int cost;
  int hp;
  int dmg;
  String type; //type: Ally, Ability, token or other (should be corrected)
  boolean exsisted=false; 
  int counter=0; //number of counters on this card
    
    Card(String line,Player player)  //constructor for reading card from file  (propably should be removed)
    {
      String[] input = split(line, '\t');
      if(input==null)
      {
        println("Error while reading card: null");
        return;
      }
      if(input.length<4)
      {
        println("Error while reading file: not complete data");
        return;
      }
      hp = int(input[0]);
      dmg = int(input[1]);
      cost = int(input[2]);
      name = input[3];
      if(!input[4].equals(null) && input[4].length()>2)
      {
        type= input[4];
        exsisted = boolean(input[5]);
        counter = int(input[6]);
        id=int(input[7]);
      }else{
        if(hp==0)
        {
          type = "ability";
          hp=1;  
        }
        else type= "ally";
      }
      p=player;
    }
    
    Card(Player player, processing.data.JSONObject data,int ID)  //JSON constructor  (owner player, card in JSON, ID in 'cards')
    {
      if(data==null) return; //dealing with errors
      if(data.size()<4) return;
      p=player;
      id = ID;
      //reading data from JSON
      hp = int(data.getString("hp"));
      dmg = int(data.getString("dmg"));
      cost = int(data.getString("cost"));
      name = data.getString("name");
      type= data.getString("type");
      //propertys readen only if card is given from 'table'
      int c=int(data.getString("counters","-1"));
        if(c!=-1) counter=c;
      boolean e=boolean(data.getString("exsisted","false"));
        exsisted=e;
    }
    
    Card(Player player) //token constructor
    {
      id=0;
      p=player;
      type="token";
      hp=1;
      dmg=0;
      cost=0;
      name="token "+p.num_of_tokens;
      p.num_of_tokens++;
    }
    
    //drawing card without any buttons
    void write(float x,float y, float w)
    {
      //color border if pointed
      if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+w*4/3)
          {
            cc = this;
            stroke(p.player_color);
          }else  stroke(0);
          
      //drawing background
      if(!exsisted) 
        if(type.equals("token")) fill(col_tn);
        else fill(255);
      else if(type.equals("token")) fill(col_tx);
            else fill(col_ex);
      rect(x,y,w,w*4/3);
      
      //writing czrd propertis
        fill(0);
        textAlign(LEFT,TOP);
        textSize(min(12,w/(name.length()*3/4)));
        text(name,x+s(5),y+s(5));  //name
        textSize(s(16));
        textAlign(CENTER,BOTTOM);
        fill(col_ct);
        if(counter!=0) text(counter,x+s(10),y+s(50));  //counters
        fill(0);
        if(cost==-1) text('X',x+w-s(10),y+s(50));  //cost
        else text(cost,x+w-s(10),y+s(50));
        if(type.equals("ally") || type.equals("token"))
        {
        if(hp==-1) text('X',x+w-s(10),y+w*4/3-s(10));  //hp
        else text(hp,x+w-s(10),y+w*4/3-s(10));
        if(dmg==-1) text('X',x+s(10),y+w*4/3-s(10));  //dmg
        else text(dmg,x+s(10),y+w*4/3-s(10));
        }else
        {
        textSize(12);
        text(type,x+w/2,y+w*4/3-s(10));  //type other than ally or token
        }
        stroke(255);
          fill(255);
    }
    
    //drawing card with buttons used in hand
    void hand(float x,float y, float w)
    {
        write(x,y,w);
          
           if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+w*4/3)
          {
            if(button(x+w-s(30),y+s(10),s(20),s(20),"^")) toTable();
            if(button(x+w-s(30),y+(w*4/3)-s(50),s(20),s(20),"R")) toRess();
            if(button(x+w/2-s(10),y+(w*4/3)-s(50),s(20),s(20),"X")) toGrave();
            if(button(x+s(10),y+(w*4/3)-s(50),s(20),s(20),"D")) toDeck();
              
          }
      exsisted=false;
    }  
    
    //drawing card with buttons used on the table
    void table(int x,int y, int w)
    {
        write(x,y,w);
        
      if(p==active)  
       if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+w*4/3)
      {
        if(type.equals("ally") || type.equals("token"))
        {
        if(button(x+w-s(34),y+w*3/4,s(15),s(15),"+")) hpp();
        if(button(x+w-s(17),y+w*3/4,s(15),s(15),"-")) hpm();
        if(button(x+s(2),y+w*3/4,s(15),s(15),"+"))  dmgp();
        if(button(x+s(19),y+w*3/4,s(15),s(15),"-")) dmgm(); 
        }else
        {
          if(button(x+w/2-s(10),y+w*2/3-s(10),s(20),s(20),"X"))  //erase ability
          {
                if(p.table.indexOf(self())!=-1)
              {
                p.grave.add(p.table.get(p.table.indexOf(self())));
                p.table.remove(self());
              }
          }
        }
    }
    }  
    
    //functions menaging cards
    void toTable() //hand->table
      {
        if(p.table.size()<12)
          {
            if(p.hand.indexOf(self())!=-1)
            {
            p.table.add(p.hand.get(p.hand.indexOf(self())));
            p.hand.remove(self());
            //p.sync("both");
            }
          }
      }
    void toRess()  //hand->ress
      {
        if(p.hand.indexOf(self())!=-1)
          {
            p.ress.add(p.hand.get(p.hand.indexOf(self())));
            p.hand.remove(self());
            //p.sync("head");
          } 
      }
    void toGrave() //hand->grave
      {
        if(p.hand.indexOf(self())!=-1)
          {
            p.grave.add(p.hand.get(p.hand.indexOf(self())));
            p.hand.remove(self());
            //p.sync("both");
          } 
      }
    void toDeck()  //hand->deck
      {
        if(p.hand.indexOf(self())!=-1)
          {
            p.deck.add(p.hand.get(p.hand.indexOf(self())));
            p.hand.remove(self());
            //p.sync("head");
          } 
      }
    void toHand() //table->hand
      {
        if(p.table.indexOf(self())!=-1)
          {
            p.hand.add(p.table.get(p.table.indexOf(self())));
            p.table.remove(self());
            //p.sync("both");
          } 
      }
    void hpp() //hp plus
      {
        if(hp!=-1) hp++;
        else hp=1;
      }
    void hpm() //hp minus
      {
          if(hp>1)
            hp--;
          else if(hp==1)
          {
            exsisted=false;
            if(p.table.indexOf(self())!=-1)
            {
              p.grave.add(p.table.get(p.table.indexOf(self())));
              p.table.remove(self());
            }
          }
         //p.sync("table");
      }
    void dmgp() //dmg plus
      {
        if(dmg!=-1) dmg++;
        else dmg=1;
        //p.sync("table");
      }
    void dmgm() //dmg minus
      {
        if(dmg>0)
        dmg--;
        //p.sync("table");
      }
    
    String log()
    {
      String line="";
      line+=hp;
      line+='\t';
      line+=dmg;
      line+='\t';
      line+=cost;
      line+='\t';
      line+=name;
      line+='\t';
      line+=type;
      line+='\t';
      line+=exsisted;
      line+='\t';
      line+=counter;
      line+='\t';
      line+=id;
      return line;
    }
    
    Card self()
    {
      return this;
    }    
}
