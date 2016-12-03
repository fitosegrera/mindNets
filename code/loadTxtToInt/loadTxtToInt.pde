String [] data;

void setup() {
  size(300, 300);
  data = loadStrings("attention.txt");
  
  String[] s = split(data[0], ',');
  for (int i=0; i<s.length; i++) {
    int converted = int(s[i]);
    println(converted);
  }
}