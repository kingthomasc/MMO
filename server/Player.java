/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import java.awt.*;
import java.io.*;

/**
 *
 * @author Thomas
 */
public class Player {
    public float x = 0;
    public float y = 0;
    public int ID;
    public String name;
    public float health = 100;
    public float velocityX = 0;
    public float velocityY = 0;
    
    public Player(int id, String nm) {
        ID = id;
        name = nm;
    }
    
    long timeSinceSent = 0;
    long timePerSend = 500;
    public boolean update(long elapsed) {
        x += velocityX * elapsed / 1000;
        y += velocityY * elapsed / 1000;
        timeSinceSent += elapsed;
        if (timeSinceSent > timePerSend) {
            timeSinceSent -= timePerSend;
            return true;
        }
        return false;
    }
    
    public String send() {
        String str = "";
        str += Constants.PLAYER + "," + ID + "," + x + "," + y + "," + 
                health + "," + name;
        return str;
    }
}
