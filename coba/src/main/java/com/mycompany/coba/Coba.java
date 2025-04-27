/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.coba;

/**
 *
 * @author LENOVO
 */
public class Coba {

    public static void main(String[] args) {
        System.out.println("Celcius\tFahrenheit\t|\tFahrenheit\tCelcius");
		int f = 20;
		
		for(int c = 0; c < 100;c+=2,f+=5) {
			double fahrenheit = (9.0/5) * c + 32;
			double celcius = (5.0/9) * (f - 32);
			System.out.println(c + "\t\t" + String.format("%.2f",fahrenheit )+ "\t\t" + f + "\t" + String.format ("%.3f",celcius));
		}
    }
}
