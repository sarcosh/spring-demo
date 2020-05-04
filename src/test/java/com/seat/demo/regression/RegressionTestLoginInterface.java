package com.seat.demo.regression;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.fail;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.concurrent.TimeUnit;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class RegressionTestLoginInterface {
  private WebDriver driver;
  private StringBuffer verificationErrors = new StringBuffer();
  
  @Before
  public void setUp() throws Exception {
    driver = new FirefoxDriver();
    driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
  }
	
  @Test
  public void testLoginInterface() throws Exception {
	assertThat(driver).isNotNull();
    driver.get("http://localhost:8081/login");
    Thread.sleep(1000);
    driver.findElement(By.name("pass")).click();
    driver.findElement(By.name("pass")).clear();
    driver.findElement(By.name("pass")).sendKeys("1111");
    driver.findElement(By.xpath("//button")).click();
    Thread.sleep(1000);
    assertEquals("LOGIN", driver.findElement(By.xpath("//button")).getText());
    driver.findElement(By.name("email")).click();
    driver.findElement(By.name("email")).clear();
    driver.findElement(By.name("email")).sendKeys("sergio.arcos@gmail.com");
    driver.findElement(By.xpath("//div/div/div")).click();
    driver.findElement(By.xpath("//button")).click();
    driver.findElement(By.xpath("//img[@alt='IMG']")).click();
    Thread.sleep(1000);
    assertEquals("LOGIN", driver.findElement(By.xpath("//button")).getText());
    driver.findElement(By.name("email")).click();
    driver.findElement(By.name("email")).clear();
    driver.findElement(By.name("email")).sendKeys("sergio.arcos@seat.es");
    driver.findElement(By.name("pass")).click();
    driver.findElement(By.name("pass")).clear();
    driver.findElement(By.name("pass")).sendKeys("34FB==");
    driver.findElement(By.xpath("//button")).click();
    Thread.sleep(1000);
    //assertEquals("HR Dashboard", driver.findElement(By.linkText("HR Dashboard")).getText());
    assertEquals("DEMO", driver.findElement(By.linkText("DEMO")).getText());
  }

  @After
  public void tearDown() throws Exception {
    driver.quit();
    String verificationErrorString = verificationErrors.toString();
    if (!"".equals(verificationErrorString)) {
      fail(verificationErrorString);
    }
  }
}
