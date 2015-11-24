public class Creature2 extends Creature {
    public int power;

    public Creature2(float x, float y, float w, float h, int b) {
        super(x, y, w, h, b);
        power = 0;
    }   

    public void setPower(int _power) {
        power = _power;
    }   
}