<!-- TODO: Maven Parent POM -->
## Setting up the Project
Let's get our hands dirty and prepare a project for our code. Currently
we support two ways of building a plugin. You can do this using *Gradle*
or *Maven*. Please note that the examples below might not use the
latest versions of the Xill API.

If you get a little confused or you simply want to see an example you
can head over to [GitHub](https://github.com/xillio/definitive-guide/tree/master/project-example)
and take a look at the project code that supports this guide.

### Building with Gradle

1. Make sure you have [Gradle 2+](http://gradle.org/gradle-download/) installed
   or run an IDE with an embedded gradle installation.
2. Create a `build.gradle` file containing the code below.

    ```groovy
    
    repositories {
      jcenter()
    }
    dependencies {
      compile 'nl.xillio.xill:api:3.3.19'
    }
    ```

3. Import your project into your IDE.

### Building with Maven

1. Make sure you have [Maven 3+](https://maven.apache.org/download.cgi)
   installed or run an IDE with an embedded maven installation.
2. Create a `pom.xml` file containing the configuration below.

    ```xml
    
    ```

3. Import your project into your IDE.

### Package Definition
Now we have a build set up we can start creating files. The first thing
we will do is create our package definition. This is fairly easy and only
requires us to simply create a file at `META-INF/services/nl.xillio.plugins.XillPlugin`
in your resources folder. So from your project root this will lead to a
file at `src/main/resources/META-INF/services/nl.xillio.plugins.XillPlugin`.

This file should contain 1 full class name per line of the implementations
of the `XillPlugin` class. For the purpose of this guide we will create
a plugin called *Guide* so we will add the following class name:
```
nl.xillio.xill.plugins.guide.GuideXillPlugin
```
The name of the class is important as it will reflect the name in Xill.

### Package Implementation
Let's create the implementation of the package we declared above. To do
this simply create the class file and have the class implement `XillPlugin`.

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
