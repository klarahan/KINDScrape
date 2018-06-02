# How to use

## System setup

### Install JRE
You have to install [Java Runtime Environment 8](http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html) to use this package. JRE is required to run the Selenium server. The JRE 9 is the latest, but it tend to have problem with Selenium.

### Start Selenium server
You have to run the Selenium sever *before* using this package. Selenium Standalone Server is available at [SeleniumHQ](http://www.seleniumhq.org/download/). This repository also contains Selenium Standalone Sever (selenium-server-standalone-3.4.0.jar) in [a sub-directory](https://github.com/koheiw/Nexis/tree/master/bin) for download, but not a web driver for Firefox (**geckodriver**). Please download  [**geckodriver**](https://github.com/mozilla/geckodriver/releases) and save it to the same directory as the Selenium server.

To start Selenium Standalone Sever, you only need to run the following command in the console:
```
java -jar selenium-server-standalone-3.4.0.jar
```
Sometimes, you have to tell **Selenium** the location of **geckodriver** (in the same directory, in this example):
```
java -jar -Dwebdriver.gecko.driver=./geckodriver selenium-server-standalone-3.4.0.jar
```
On Windows, the command looks slightly different:
```
java.exe -Dwebdriver.gecko.driver=./geckodriver.exe -jar selenium-server-standalone-3.4.0.jar
```
Note that you have the directory that contains Java executable in the system path. On Windows, `java.exe` is usually located in `C:\Program Files (x86)\Java\jre1.8.0_144\bin`. Please refer to [other source](https://www.howtogeek.com/118594/how-to-edit-your-system-path-for-easy-command-line-access/) for how to add a directory to the system path. After adding to the system path, your Windows needs restart.

You can stop the Selenium server by pressing `Ctrl + C`.
