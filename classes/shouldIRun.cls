public class shouldIRun{
 
Public Static boolean allow = true;
Public Static boolean doubOptallow = true;//PD-11641

public static void stopTrigger(){
   allow = false;
}
 
public static boolean canIRun(){
  return allow;
    
}

}