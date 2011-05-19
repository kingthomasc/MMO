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
    Queue<String> strings = new LinkedList<String>();
    ArrayList<DataOutputStream> outputs = new ArrayList<DataOutputStream>();
    
    public void add(String str) {
        strings.add(str);
    }

    public void add(DataOutputStream out) {
        outputs.add(out);
    }
    
    @Override
    public void run() {
        System.out.println("running");
        while (true) {
            while (!strings.isEmpty()) {
                String s = strings.remove();
                System.out.println(s);
                for (int i = 0; i < outputs.size(); i++) {
                    DataOutputStream out = null;
                    try {
                        out = outputs.get(i);
                        out.writeUTF(s);
                        out.flush();
                    } catch(Exception exc) {
                        System.err.println(exc.getMessage());
                        if (out != null)
                            outputs.remove(out);
                        i--;
                    }
                }
            }
        }
    }
}
