# Getting Started
This guide is for anyone interested in developing a plugin for the Xill 
language in an organised and clean way or for those seeking to get a 
better understanding of the framework. In the first section of this 
guide we will not only explain how to set up and prepare a project for 
development, but also walk you through the process of using an automated 
tool to deploy a project within the [Xill repository][1]. In the second 
section we will walk you through the basic components of the newly 
created plugin. Also we will show you how to create, use and test every 
component of it. Last but not least, we will cover some more advanced
topics in the third section and dig a little deeper into the 
architecture.

## About Xill
Xill is a domain specific scripting language geared towards anything
content. It was developed as a solution to a migration consultant's need 
of resilience as well as flexibility. The current version is the third
iteration of this concept and focuses mainly on modularity and
extendability. To allow for this we introduced a plugin framework that
allows anyone to add functionality to the language.

### Required Knowledge
To be able to build a plugin for the Xill language there is no need for 
advanced knowledge of programming. However, if you want to create a 
stable, maintainable and testable project it is recommended to read up 
on the Java conventions and design patterns. A good place to start there 
would be the book [Effective Java, Joshua Bloch], even though this book 
is for Java 6 it still has some good things to say that carry over to 
Java.

Basic knowledge of [Gradle 2] is required to be able to create a project 
and load dependencies.

### Helping Out
Working together to build something great is an amazing experience. The 
same applies to this guide, if you would like to see something explained 
in more detail or some subject is missing entirely then simply comment 
on the page or find someone to add it.

### Building a plugin

To build your plugin using maven you can set a parent pom. This will
automatically add the Xill API to your dependencies as well as build a
zip distribution.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>nl.xillio.xill</groupId>
        <artifactId>plugins-parent</artifactId>
        <!-- Insert the latest version here -->
        <version>3.4.0</version>
    </parent>

    <groupId>io.xill
    <artifactId>plugin-guide</artifactId>
    <version>1.0.0-SNAPSHOT</version>

    <build>
        <plugins>
            <plugin>
                <!-- We enable this plugin to make zip packages -->
                <artifactId>maven-assembly-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

[Xill repository]: https://bitbucket.org/xillio/xill
[Effective Java, Joshua Bloch]: https://books.google.nl/books?id=ka2VUBqHiWkC
[Gradle 2]: https://gradle.org/
