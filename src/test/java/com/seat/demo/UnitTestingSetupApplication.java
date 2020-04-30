package com.seat.demo;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.seat.demo.controller.LoginController;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
public class UnitTestingSetupApplication {
	
	@Autowired
	private LoginController controller;

	@Test
	@Order(1)
	public void contextLoads() {
		assertThat(controller).isNotNull();
	}
}
