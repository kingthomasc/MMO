/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import java.util.*;
/**
 *
 * @author Thomas
 */
public class EntityManager extends Thread{
    ArrayList<Player> players;
    Outputter out;
    
    public void addPlayer(String info) {
        
    }
    
    long lastTime = System.currentTimeMillis();
    @Override
    public void run() {
        while (true) {
            long time = System.currentTimeMillis();
            long elapsed = time - lastTime;
            lastTime = time;
            for (Player p : players) {
                if (p.update(elapsed)) out.add(p.send());
            }
        }
    }
}
