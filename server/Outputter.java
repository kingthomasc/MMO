/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import java.io.*;
import java.util.*;
/**
 *
 * @author Thomas
 */
public class Outputter extends Thread {
    Queue<String> strings;
    ArrayList<DataOutputStream> outputs;
    
    public void add(String str) {
        strings.add(str);
    }
    
    @Override
    public void run() {
        while (true) {
            while (!strings.isEmpty()) {
                String s = strings.remove();
                for (DataOutputStream out : outputs) {
                    try {
                        out.writeUTF(s);
                        out.flush();
                    } catch(Exception exc) {}
                }
            }
            try {
                sleep(100);
            } catch(Exception exc) {}
        }
    }
}
