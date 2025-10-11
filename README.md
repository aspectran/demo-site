# Demo Site for Servlet-Based Aspectran

A web application to guide the traditional way of building web applications using the Servlet-based Aspectran framework.

This project serves as a practical example for developers looking to understand the core concepts of Aspectran in a classic servlet environment. It demonstrates how to set up a project, define translets, and integrate with view technologies like JSP.

## Features

*   Demonstrates basic setup for an Aspectran web application.
*   Examples of Translet definitions for handling requests.
*   Integration with JSP and JSTL for the view layer.
*   Clear, conventional project structure for a Maven-based web application.

## Prerequisites

*   Java Development Kit (JDK) 21 or later.
*   Apache Maven 3.9.4 or later.
*   A Jakarta EE 10 compatible servlet container (e.g., Tomcat 10.1+, Jetty 12+).

## How to Build

To build the project, run the following Maven command from the root directory. This will compile the source code and package it into a `war` file in the `target/` directory.

```shell
mvn clean package
```

## How to Run

1.  Build the project as described above.
2.  Deploy the generated `demo-site-1.0.0-SNAPSHOT.war` file from the `target/` directory to your servlet container.
3.  Once deployed, access the application at `http://localhost:8080/` (the exact URL may vary depending on your container's configuration).

## License

This project is licensed under the Apache License 2.0. See the [LICENSE.txt](LICENSE.txt) file for details.
