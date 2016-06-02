This guide is for anyone interested in developing a plugin for the Xill 
language in an organised and clean way or for those seeking to get a 
better understanding of the framework. In the first section of this 
guide we will not only explain how to set up and prepare a project for 
development, but also walk you through the process of using an automated 
tool to deploy a project within the [Xill git repository][1]. In the second 
section we will walk you through the basic components of the newly 
created plugin. Also we will show you how to create, use and test every 
component of it. Last but not least, we will cover some more advanced
topics in the third section and dig a little deeper into the 
architecture.

## Required Knowledge
To be able to build a plugin for the Xill language there is no need for 
advanced knowledge of programming. However, if you want to create a 
stable, maintainable and testable project it is recommended to read up 
on the Java conventions and design patterns. A good place to start there 
would be the book [Effective Java, Joshua Bloch][2], even though this book 
is for Java 6 it still has some good things to say that carry over to 
Java.

Basic knowledge of [Gradle 2][3] is required to be able to create a project 
and load dependencies.

## Helping Out
Working together to build something great is an amazing experience. The 
same applies to this guide, if you would like to see something explained 
in more detail or some subject is missing entirely then simply comment 
on the page or find someone to add it.

[1]: https://bitbucket.org/xillio/xill
[2]: https://books.google.nl/books?id=ka2VUBqHiWkC
[3]: https://gradle.org/