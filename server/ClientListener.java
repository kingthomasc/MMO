/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import java.io.*;
import java.net.*;
/**
 *
 * @author Thomas
 */
public class ClientListener extends Thread {
    Socket c;
    DataInputStream in;
    int ID;
    public boolean running = true;

    public ClientListener(Socket client) {
        c = client;
        try {
            in = new DataInputStream(client.getInputStream());
            String name = in.readUTF();
            System.out.println(name);
            AddPlayer p = Constants.manager.addPlayer(name);
            ID = p.id;
            DataOutputStream out = new DataOutputStream(
                    client.getOutputStream());
            out.writeBoolean(p.success);
            out.flush();
        } catch (Exception exc) {}
    }

    @Override
    public void run() {
        while (true) {
            try {
                String data = in.readUTF();
                if (data.startsWith("close")) {
                    Constants.manager.remove(ID);
                }
                else if (data.startsWith("move")) {
                    String[] d = data.split(",");
                    Constants.manager.move(ID, Float.parseFloat(d[1]),
                            Float.parseFloat(d[2]));
                }
                else if (data.startsWith("chat")) {
                    Constants.output.add(data);
                }
            } catch(Exception exc) {
                Constants.manager.remove(ID);
                System.out.println("socket closed");
                break;
            }
        }
        running = false;
    }
}
