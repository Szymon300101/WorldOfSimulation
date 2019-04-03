//1269 lines
Player active; //you
Player passive; //your opponent
Card cc; //card pointed with a mouse

boolean help_show=false;
boolean chosen_player=false;  //false at the start, before chosing player
float mid = 6/10.0; // hand height / screen height
int sync_clk=250;  //millis between syncs
boolean toWrite=false;

boolean connected;   //connection to server

//COLOR PALLETE
color col_p1 = #AF4319;  //player 1
color col_p2 = #00958A;  //player 2
color col_gr = #603F67;  //grave
color col_tn = #72B72A;  //token
color col_tx = #9DBC7B;  //exsisted token
color col_ex = #B7B7B7;  //exsisted card
color col_ct = #8D48D8;  //counter on card
color col_hl = #7F8900;  //help


void setup()
{
   //fullScreen();
   size(890,500);
    
    active = new Player(1,col_p1);   //constructing 1st player (default as active)
    passive = new Player(2,col_p2);  //constructing 2nd player (default as passive)
    
    connected=checkConnection();  //checking connection
}

void draw()
{
  background(0);
  stroke(255);
  cc=null;
  
  if(active.deck_name!=null)  //main loop (while deck is choosen)
  {
    tables();   //drawing whole table
    active.hand();   //active hand (at the bottom)
    passive.hand();  //passive hand (at the top)
    
    if(millis()%sync_clk<60)  //synchronizing all data
    {
      active.sync();
      passive.sync();
    }
  }else if(!chosen_player)  //1st screen after lounch
  {
    if(connected)
    {
      textSize(s(10));
      fill(0,255,0);
      textAlign(LEFT,TOP);
      text("online",1,1);
    }
    else 
    {
      textSize(s(35));
      fill(255,0,0);
      textAlign(CENTER,CENTER);
      text("CONNECTION ERROR",width/2,height/2);
      while(!checkConnection());  //waiting for reconnect
    }
    
    //choosing player
    fill(255);
    textSize(s(20));
    textAlign(CENTER,TOP);
    text("choose player",width/2,s(50));
    
    chosen_player=choose_player(); //chooseplayer() paints these big rects and switches active/passive if required
    if(chosen_player) create(active);  //if player is choosen, set all variables for this user
    
  }else //2nd screen, choosing deck from a list
    {
      fill(255);
      textSize(20);
      textAlign(CENTER,TOP);
      text("choose player",width/2,s(10));
      fill(255);
      String[] list = listEntity("decks","name");  //downloading list of decks from server
      for(int i=0;i<list.length;i++)
        if(button(s(100)+(i/8)*250,s(100)+(i%8)*s(50),s(200),s(40),list[i]))
            active.loadDeck(i);  //if deck is clicked, load it to your player
    }
  
  //handling help
  fill(255);
  textSize(s(12));
  textAlign(RIGHT,CENTER);
  text("h - HELP",width-s(50),s(10));
  if(help_show) help();
    fill(255);

}


void keyPressed()
{
  //process();
  toWrite=true;
  
  //println(keyCode);
  switch(keyCode)
  {
    case 107:  //+ - add counter to pointed card
      if(cc!=null) cc.counter+=1; 
    break;
    case 109:   //- - remove counter
      if(cc!=null) 
        if(cc.counter>0) 
          cc.counter-=1; 
    break;
    case 72:  //h - show/hide help
      help_show=!help_show; 
    break;
    case 83: //s - save player locally
      if(active.is_deck) active.loc_save_player(); 
    break;
    case 76: //l - load player from local files
      active.loc_load_player();
    break;
    case 71: //g - show grave
      active.grave_show=!active.grave_show; 
      active.g_scroll=0;
    break;
    case 68: //d - draw default hand
      if(active.hand.size()==0)
        for(int i=0;i<7;i++)
          active.DRAW();
    break;
    case 77: //m - remove all cards from hand (back to deck)
      for(int i=active.hand.size()-1;i>=0;i--)
        active.hand.get(i).toDeck();
    break;
    case 85: //u - untap (all exsisted cards and ress)
      for(int i=0;i<active.table.size();i++)
        active.table.get(i).exsisted=false;
      active.Rr();
    break;
    case 69: //e - exsist pointed card
    if(cc!=null) cc.exsisted=true; 
    break;
    case 84: //t - create token
        active.table.add(new Card(active)); 
    break; 
    case 10: //ENTER - draw a card / return card form grave
      if(cc!=null)
      {
        if(active.grave.indexOf(cc)!=-1)
        {
          active.hand.add(active.grave.get(active.grave.indexOf(cc)));
          active.grave.remove(cc);
        }else active.DRAW();
      }else active.DRAW(); 
    break; 
    case 16: //Shift - play pointed card
      if(cc!=null) cc.toTable(); 
    break; 
    case 82: //r - use ress
        active.Rm(); 
    break;
    case 32: //SPACE - show hand
      if(active.is_deck)
          active.hand_show=!active.hand_show;
    break;
  case 27: //ESC - destructor
    format(active);
    break;
  }
}

void mousePressed()
{
  //process();
  toWrite=true;
}

//scroll event only for scrollable grave list
void mouseWheel(MouseEvent event) {
  if(active!=null) 
        if(active.grave_show) 
          active.g_scroll+=s(event.getCount()*8);
}
