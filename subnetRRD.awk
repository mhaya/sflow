#!/bin/awk -f

BEGIN{ lastInt = 0; }
/unixSecondsUTC/{
  currentInt = $2 - ($2 % 300);
  if(currentInt != lastInt) {
    cmd="rrdtool update subnet.rrd";
    templates = "--template ";
    values=lastInt;
    i=0;
    for(key in count) {
      templates=templates"n"key":";
      values=values":"count[key];
      i++;
    }
    sub( /.$/, "", templates );
    if(i>0){
	print cmd" "templates" "values;
    }
    lastInt = currentInt;
    delete count;
  }
}
/dstIP/{
    vlan = $2;
    split(vlan,tmp,".");
    key = tmp[3];
    count[key] = count[key] + 1;
}
END{}

