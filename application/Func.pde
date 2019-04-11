void help()
{
  int lines=22;
  fill(col_hl);
  stroke(0);
  rect(s(120),s(50),s(500),s(100+lines*20));
  fill(0);
  String txt = "HELP:\n";
  txt+="SPACE - show/hide hand\n";
  txt+="ENTER - draw\n";
  txt+="Shift - pointed card to table\n";
  txt+="BACKSPACE - return pointed card to hand\n";
  txt+="e - exist pointed card\n";
  txt+="r - use resourse\n";
  txt+="u - untap all\n";
  txt+="t - put token into play\n";
  txt+="-/+ - remove/add counter\n";
  txt+="d - draw 7 cards\n";
  txt+="m - put your hand back to deck\n";
  txt+="g - show grave\n";
  txt+="s - manual save\n";
  txt+="l (on deck choosing screen)- load latest AutoSave\n";
  txt+="l - load latest manual save\n";
  txt+="BUTTONS ON CARD:\n";
  txt+=" ^ - play a card\n";
  txt+=" R - put a card on ress\n";
  txt+=" D - return card to deck\n";
  txt+=" X - delete card to grave\n";
  txt+=" -/+ - change closest parameter\n";
  
  textAlign(LEFT,TOP);
  textSize(s(14));
  text(txt,s(145),s(65));
  fill(255);
}

void tables()
{
  stroke(passive.player_color);
    line(0,height*mid/2,width,height*mid/2);
    stroke(active.player_color);
    line(0,height*mid/2+s(3),width,height*mid/2+s(3));
    
    if(active.table.size()<=10)
      for(int i=0;i<active.table.size();i++)
        active.table.get(i).table(s(120+(i*120)),int(height*mid/2+s(50)),s(100));  
    else
        for(int i=0;i<active.table.size();i++)
          active.table.get(i).table(s(120+(i*100)),int(height*mid/2+s(40)),s(75));
          
    if(passive.table.size()<=10)
      for(int i=0;i<passive.table.size();i++)
        passive.table.get(i).table(s(60+(i*120)),s(50),s(100));  
    else
        for(int i=0;i<passive.table.size();i++)
         passive.table.get(i).table(s(60+(i*100)),s(40),s(75));
}

boolean choose_player()
{
  fill(active.player_color);
  noStroke();
  rect(s(100),s(100),width/2-s(100),height-s(200));
  fill(passive.player_color);
  rect(width/2,s(100),width/2-s(100),height-s(200));
  if(mousePressed)
  {
    
    if(mouseX>s(100) && mouseX<width/2 && mouseY>s(100) && mouseY<height-s(100))
     {
       if(active.p_num==2)
       {
         Player c=passive;
         passive=active;
         active=c;
       }
       return true;
     }
     if(mouseX>width/2 && mouseX<width-s(100) && mouseY>s(100) && mouseY<height-s(100))
     {
       if(active.p_num==1)
       {
         Player c=active;
         active=passive;
         passive=c;
       }
       return true;
     }
     int m=millis();
     while(millis()-m<200);
  }
  return false;
}


void slist(ArrayList<Card> data,int x,int y,int w,int off,color bck,String label) //scrollable list
{
  if(off>0) off=0;
  if(s(10+(data.size()*110)+off)<w) off=w-s(10+(data.size()*110));
  stroke(0);
  fill(bck);
  rect(x,y,w,s(300));
  fill(0);
  textSize(18);
  textAlign(LEFT,TOP);
  text(label,x+s(20),y+s(20));
  if(s(10+(data.size()*110))<w) off=0;
  else{
    float len=1.0*w/s(10+(data.size()*110))*w;
    int pos=int(map(s(10+(data.size()*110)+off),s(10+(data.size()*110)),w,0,w-len));
    fill(0);
    rect(x+pos,y+250+10,len,10);
  }
  for(int i=0;i<data.size();i++)
    if(s(10+i*110+off)>0 && s(10+i*110+off)<w-s(100))
      data.get(i).write(x+s(10+i*110+off),y+s(100),s(100));
   fill(255);
}


boolean button(float x,float y, float w , float h, String name)
{
  PFont font = createFont("DialogInput.bold",min(h*3/4,w/(name.length()*3/4)));
  textFont(font);
  noStroke();
  fill(17,24,103);
  rect(x,y,w,h);
  textAlign(CENTER,CENTER);
  fill(255);
  text(name,x+w/2,y+h*35/100);
  if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h)
   {
     fill(70,90,240);
     noStroke();
      rect(x,y,w,h);
      textAlign(CENTER,CENTER);
      fill(255);
      text(name,x+w/2,y+h*40/100);
    if(mousePressed)
    {
      int m=millis();
      while(millis()-m<200);
      return true;
    }
    else return false;
  } else return false;
}

void read(File selection)
{
  if(selection!=null)
  {
    String[] load = loadStrings(selection.getAbsolutePath());
    String[] input = split(load[0], '\t');
    active.deck_name=input[0];
    active.hero=input[1];
    active.heroHP=int(input[2]);
    for(int i=2;i<load.length;i++)
    {
      input = split(load[i], '\t');
          int q = int(input[0]);
      load[i]="";
        for(int j=1;j<input.length;j++)
          load[i]+=input[j]+"\t";
          for(int p=0;p<q;p++)
              active.deck.add(new Card(load[i],active));
    }
  }else
    active.is_deck=false;
}

String n()
{
  return System.lineSeparator();
}

int s(float a)
{
  return int(a*width/1366);
}
