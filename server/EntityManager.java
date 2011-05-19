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
    ArrayList<Player> players = new ArrayList<Player>();
    int currentID = 0;

    public AddPlayer addPlayer(String name) {
        AddPlayer add = new AddPlayer();
        for (int i = 0; i < players.size(); i++) {
            Player p = players.get(i);
            if (p.name.equals(name)) {
                add.success = false;
                add.id = 0;
                return add;
            }
        }
        add.id = currentID;
        add.success = true;
        Player p = new Player(currentID++, name);
        players.add(p);
        Constants.output.add(p.send());
        return add;
    }

    public void remove(int id) {
        for (int i = 0; i < players.size(); i++) {
            Player p = players.get(i);
            if (p.ID == id) {
                players.remove(p);
                break;
            }
        }
    }

    public void move(int id, float x, float y) {
        for (int i = 0; i < players.size(); i++) {
            Player p = players.get(i);
            if (p.ID == id) {
                p.velocityX = x;
                p.velocityY = y;
                break;
            }
        }
        Constants.output.add("move" + "," + id + "," + x + "," + y);
    }
    
    long lastTime = System.currentTimeMillis();
    @Override
    public void run() {
        while (true) {
            long time = System.currentTimeMillis();
            long elapsed = time - lastTime;
            lastTime = time;
            for (int i = 0; i < players.size(); i++) {
                try {
                    Player p = players.get(i);
                    if (p.update(elapsed)) Constants.output.add(p.send());
                } catch(Exception exc) {}
            }
            try {
                sleep(100);
            } catch(Exception exc) {}
        }
    }
}
