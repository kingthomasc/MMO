/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import java.io.*;
import java.net.*;
import java.util.*;
/**
 *
 * @author Thomas
 */
public class ConnectionListener extends Thread {
    ArrayList<ClientListener> listeners = new ArrayList<ClientListener>();

    @Override
    public void run() {
        ServerSocket server;
        try {
            server = new ServerSocket(4568);
        } catch (Exception exc) {
            return;
        }
        while (true) {
            try {
                System.out.println("Waiting for connection...");
                Socket client = server.accept();
                Constants.output.add(
                        new DataOutputStream(client.getOutputStream()));
                ClientListener listener = new ClientListener(client);
                listeners.add(listener);
                listener.start();
                System.out.println("Client added!!!");
            } catch(Exception exc) {
                System.err.println(exc.getMessage());
            }
            for (int i = 0; i < listeners.size(); i++) {
                if (!listeners.get(i).running) {
                    listeners.remove(i);
                    i--;
                }
            }
        }
    }
}
