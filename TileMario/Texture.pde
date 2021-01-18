public class AnimatedTexture {
  private ArrayList<PImage> textures = new ArrayList<PImage>();
  private int ind = 0;
  
  public PImage next() {
    ind = (ind+1)%textures.size();
    return textures.get(ind);
  }
  
  public void add(PImage i) {
    textures.add(i);
  }

}
