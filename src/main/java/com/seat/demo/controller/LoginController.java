package com.seat.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {
	
	@GetMapping("/login")
	//public String greeting(@RequestParam(name="name", required=false, defaultValue="World") String name, Model model) {
	public String login(@RequestParam(name="email", required=false) String email, @RequestParam(name="pass", required=false) String pass) {
		String viewToShow = null;
		
		System.out.println(">> email: " + email);
		System.out.println(">> pass: " + pass);
		
		if(email != null && pass != null) {
			if(email.equalsIgnoreCase("inflexion69@gmail.com") && pass.equalsIgnoreCase("34FB==")) {
				viewToShow = "main";
			}			
		} else {
			viewToShow = "login";
		}
		
		System.out.println(">> viewToShow: " + viewToShow);
		
		return viewToShow;
	}

}
