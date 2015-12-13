class Note {
 AudioPlayer[] buffer;
 int count;
 int copies = 3;
 Note(Minim minim, String path) {
   buffer = new AudioPlayer[copies];
   count = 0;
   for (int i = 0; i < buffer.length; i++) {
     buffer[i] = minim.loadFile(path, 256);
   }
 }
 
 void play() {
   buffer[count].rewind();
   buffer[count].play();
   count = (count + 1) % copies;
 }
}