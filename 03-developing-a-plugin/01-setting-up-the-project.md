<!-- TODO: Maven Parent POM -->
## Setting up the Project
Let's get our hands dirty and prepare a project for our code. Currently
we support two ways of building a plugin. You can do this using *Gradle*
or *Maven*. Please note that the examples below might not use the
latest versions of the Xill API.

If you get a little confused or you simply want to see an example you
can head over to [GitHub](https://github.com/xillio/definitive-guide/tree/master/project-example)
and take a look at the project code that supports this guide.

### Step 1: Setting up the build

1. Make sure you have [Maven 3+](https://maven.apache.org/download.cgi)
   installed or run an IDE with an embedded maven installation.
2. Create a `pom.xml` file containing the configuration below.

    ```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>

        <parent>
            <groupId>nl.xillio.xill</groupId>
            <artifactId>plugins-parent</artifactId>
            <!-- Replace this with the latest API version -->
            <version>3.4.0</version>
        </parent>

        <artifactId>plugin-guide</artifactId>

        <dependencies>
            <!-- Here you declare your maven dependencies -->
        </dependencies>

        <build>
            <plugins>
                <plugin>
                    <artifactId>maven-assembly-plugin</artifactId>
                </plugin>
            </plugins>
        </build>
    </project>	
    ```

3. Import your project into your IDE.

### Step 2: Package Implementation
Now to create your plugin you should create a subclass of `XillPlugin`. The
Maven build wil automatically pick it up and present it to the plugin framework.

```java
package nl.xillio.xill.plugins.guide;

import nl.xillio.plugins.XillPlugin;

/**
 * This class represents the Guide Xill package.
 */
public class GuideXillPlugin extends XillPlugin {

}

```

This class is empty for now because we do not have any configuration
that we have to do here.

This concludes the initial project setup. We are now ready to start adding
functionality to the plugin.
