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
public class Main {
    public static void main(String args[]) {
        ConnectionListener connector = new ConnectionListener();
        connector.start();
        Constants.output.start();
        Constants.manager.start();
        Scanner scan = new Scanner(System.in);
        while (!scan.next().equals("q")) continue;
        System.exit(0);
    }
}
