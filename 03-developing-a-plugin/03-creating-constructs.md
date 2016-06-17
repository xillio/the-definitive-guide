## Creating Constructs
That should be enough theory now. It's time to get our hands dirty.
The first thing we will do, is create a simple construct that does not
really do anything useful. Then we will get a little bit more in-depth
by doing a little bit more useful operation.

### Hello World
Let's create our `GreetConstruct`. This construct should print **Hello World**
whenever it is called.

> **Note:** As we mentioned while describing [the project structure](#the-project-structure),
> all constructs should be created in the `constructs` package under the
> plugin package root.

```java
package nl.xillio.xill.plugins.guide.constructs;

import ...;

public class GreetConstruct extends Construct {
    public ConstructProcessor prepareProcess(ConstructContext constructContext) {
        return new ConstructProcessor(
                name -> process(constructContext, name),
                new Argument("name", fromValue("World"), ATOMIC)
        );
    }

    private MetaExpression process(ConstructContext constructContext, 
            MetaExpression name) {
        Logger logger = constructContext.getRootLogger();

        logger.info("Hello " + name.getStringValue() + "!");

        return NULL;
    }
}
```

Let's take a step back and see what's going on here. We created a subclass
of `Construct` and placed it in the `constructs` subpackage. Next we have
to implement the `prepareProcess(ConstructContext)` method.
This `ConstructProcessor` needs all the information required for executing
the construct: the process method and the input parameters.

In the `process(ConstructContext, MetaExpression)` method you can see
how we grab the *logger* and use it to print a message. Something you might
notice is how we always return `NULL`. This is because every Xill construct
requires an output value.

> **Note:** For the more experienced software developers, you might notice
> that the `GreetConstruct` class is actually an implementation of a
> `ConstructProcessor` factory.

