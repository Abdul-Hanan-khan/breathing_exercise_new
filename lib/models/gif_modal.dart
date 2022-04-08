import 'dart:math';

class GIFModal {

  List<double> _frames = [0,47,39,78,170,100,209,77];
  List<int> _speeds = [0,3000,2000,5000,5000,3000,10000,3000];
  List<int> _paddings = [0,80,120,80,0,30,0,0,];

  int gifID;
  double frames;
  int speedInSeconds;
  int padding;

  GIFModal(){
    Random rnd;
    int min = 1;
    int max = 8;
    rnd = new Random();
    gifID = min + rnd.nextInt(max - min);
    frames = _frames[gifID];
    speedInSeconds=_speeds[gifID];
    padding = _paddings [gifID];
  }

}