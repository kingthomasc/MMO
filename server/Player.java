/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import java.io.*;

/**
 *
 * @author Thomas
 */
public class Player {
    int x;
    int y;
    int ID;
    String name;
    int health;
    
    public Player(int id, String nm) {
        ID = id;
        name = nm;
    }
    
    long timeSinceSent = 0;
    long timePerSend = 1000;
    public boolean update(long elapsed) {
        timeSinceSent += elapsed;
        if (timeSinceSent > timePerSend) {
            timeSinceSent -= timePerSend;
            return true;
        }
        return false;
    }
    
    public String send() {
        String str = "";
        str += Constants.PLAYER + "," + ID + "," + "," + x + "," + y + "," + 
                health + "," + name;
        return str;
    }
}
