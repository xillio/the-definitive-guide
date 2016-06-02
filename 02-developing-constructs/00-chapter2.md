# Developing Constructs

If everything went well in the previous section, you should now have a 
functioning project to develop your plugin. This is the point where you 
will have to think about how the Xill user will use the functionality 
provided by your plugin. To define this, you will build constructs in 
the next section. A construct is a function which is added to the Xill 
language by a plugin.

Let's start by explaining the MetaExpression. This class is the most 
important class you will use in your plugin as it represents an 
expression in the Xill language. There are a couple of things you need 
to know.

## MetaExpression

### The Three Musketeers

The language contains three main structures for ordering expressions. 
These structures all behave in their own way.

```java
MetaExpression expression = fromValue(data);
ExpressionDataType type = expression.getType();
```

#### ATOMIC
An atomic expression represents a single value. Some examples of this 
would be '5', "Hello World" or true. This expression has no additional 
behavior you should be aware of.

##### Getting Values from an ATOMIC Expression

```java
String stringValue = expression.getStringValue();
double doubleValue = expression.getNumberValue().doubleValue();
  
// Check if the input is a number
if(Double.isNaN(doubleValue)) {
    //This is not a number
}
```

#### LIST
The LIST type represents a list of MetaExpressions. They can be accessed 
in Xill using the [] operator (like list[5] to get element at index 5).

##### Getting the List of Values from an Expression
```java
if(expression.getType() == ExpressionDataType.LIST) {
    List<MetaExpression> children = expression.getValue();
}
```

> Note that getValue() will automatically cast to whatever you assign
> so it is very important that you perform the type check first.

#### OBJECT
The OBJECT type represents a list of MetaExpressions indexed by String. 
They can be accessed in Xill using the [] operator or the . operator 
(object.value gets the expression in the object with key value).

##### Getting the Map of Values from an Expression
```java
if(expression.getType() == ExpressionDataType.OBJECT) {
    Map<String, MetaExpression> children = expression.getValue();
}
```

### Every Expression has Every Type
That's right, every single expression has every type. This means that 
every expression has a String, Number and Boolean representation.

**Type**    **String**            **Boolean**                  **Number**
---------   -------------------   --------------------------   -------------------------------
*ATOMIC*    Actual Value          false if null, false or 0,   Actual value if it is a number, 
                                  otherwise true               otherwise Double.NaN 
*LIST*      Json Representation   true                         Length of list
*OBJECT*    Json Representation   true                         Size of object

This principle allows the user to not worry about typing while making the 
language stable without casting around the types. Note that this means 
that it is not possible to check whether the input of a construct was a 
String, Number or Boolean. For 
example: There is no difference between the expressions 5 and "5" once 
you receive it at the construct level.

## Construct Overview
![Construct Stage of Plugin Structure](resources/construct_overview_flow_chart.png)

The above diagram shows a representation of the flow from a script to 
functionality. This is done through input parameters. In Xill a 
programmer will call a construct using the package syntax: 
`System.print(....)` with input parameters. These parameters are all 
MetaExpressions from which the construct extracts information.

> **Best Practice:** All required information is acquired from the 
  MetaExpressions this means that generally the construct is the last 
  point where Xill logic exists. From this point on all components should 
  not be using any object from the Xill platform.

### Creating a Construct
A construct is actually a factory that builds ConstructProcessors. This 
ConstructProcessor is an object that will process a lambda expression 
with parameters passed from the language. Let's see how we make a 
processor like this.

#### Construct with one Argument
```java
import nl.xillio.xill.api.components.MetaExpression;
import nl.xillio.xill.api.construct.Argument;
import nl.xillio.xill.api.construct.Construct;
import nl.xillio.xill.api.construct.ConstructContext;
import nl.xillio.xill.api.construct.ConstructProcessor;
 
public class MinimalConstruct extends Construct {
 
    @Override
    public ConstructProcessor prepareProcess(final ConstructContext context) {
        return new ConstructProcessor(
            input -> fromValue(input.getNumberValue().doubleValue() + 1),
            new Argument("input", fromValue(100), ATOMIC)
        );
    }
 
}
```

The first thing you should do is extend the Construct class from the 
api. This will add auto configuration to your construct giving it a 
name, find documentation and load all services. The next thing that must 
be done is implement the prepareProcess mehod. This method will be called 
by the Xill Processor when compiling the script. This is the factory 
method for the ConstructProcessor. It takes a function and Argument 
object as input. Let's walk through this step by step.

```java
public class MinimalConstruct extends Construct
```
Here we extend the Construct class to gain the auto configuration 
functionality.

```java
return new ConstructProcessor
```
Here we create the new ConstructProcessor for the Xill compiler to use.

```java
input -> fromValue(input.getNumberValue().doubleValue() + 1)
```
The first argument of the ConstructProcessor constructor is the function. 
This function takes one argument, gets the double value stored in this 
argument and adds 1.

```java
new Argument("input", fromValue(100), ATOMIC)
```
Here we initialize a new Argument called 'input' with the default value 
100 which only accepts ATOMIC values.

> **Tip:** If you want to accept multiple types you can provide them in 
  the constructor too: new Argument("input", fromValue(100), ATOMIC, LIST)

### More Functionality
Of course most of the constructs you will be building aren't anywhere 
near as simple as the example above so here is an explanation on how to 
add different functionality.

#### Larger Process Functions
Generally a process method will not be a one-liner so it is good practice 
to extract this function to a method.

```java
import nl.xillio.xill.api.components.MetaExpression;
import nl.xillio.xill.api.construct.Argument;
import nl.xillio.xill.api.construct.Construct;
import nl.xillio.xill.api.construct.ConstructContext;
import nl.xillio.xill.api.construct.ConstructProcessor;
 
public class MinimalConstruct extends Construct {
     
    @Override
    public ConstructProcessor prepareProcess(final ConstructContext context) {
        return new ConstructProcessor(
            this::process,
            //Or input -> process(input)
            new Argument("input", fromValue(100), ATOMIC)
        );
    }
    
    private MetaExpression process(MetaExpression input) {
        double value = input.getNumberValue().doubleValue() + 1;
        return fromValue(value);
    }
 
}
```

#### Overriding the default name
By default the name of the construct is set to the class name without 
the Construct suffix. This behavior can be overridden.

```java
public class MinimalConstruct extends Construct {
  
    @Override
    public String getName() {
        return "min";
    }

}
```

## Services
![Service Stage of Plugin Structure](resources/construct_overview_flow_chart_service.png)

Services are the gatekeepers between the library logic and the constructs. 
These classes make sure that the plugin will remain testable and 
modular. Even in the case of replacing a whole library it shouldn't 
be required to change any code in the constructs. This also means that 
the Xill programmer might not even notice the change of library.

### Building a Service
Services can be loaded using dependency injection. To make this possible
we use [Google Guice].
Let's create a service class.

> **Best Practice:** It is convention to create all service classes in
  a subpackage called 'services'. This way all plugins have the same
  structure.

```java
package your.namespace.here.services;

import java.util.Date;
import java.util.Random;

public class MyNewService {
    private static final Random RANDOM = new Random();
    
    public String getRandomString() {
        StringBuilder builder = new StringBuilder();
        for (int i = RANDOM.nextInt(100) + 50; i > 0; i--) {
            builder.append((char) (64 + RANDOM.nextInt(26)));
        }
        
        return builder.toString();
    }
}
```

This service we just created can generate a string containing random
letters.
Now we can use the service we defined above in our construct and use 
the @Inject annotation to instruct the injector to give us an 
implementation of our service.

```java
package your.namespace.here.services;
 
import com.google.inject.Inject;
import nl.xillio.xill.api.components.MetaExpression;
import nl.xillio.xill.api.construct.Argument;
import nl.xillio.xill.api.construct.Construct;
import nl.xillio.xill.api.construct.ConstructContext;
import nl.xillio.xill.api.construct.ConstructProcessor;
 
public class MinimalConstruct extends Construct {
    private final MyNewService myNewService;
    
    @Inject
    MinimalConstruct(MyNewService myNewService) {
        this.myNewService = myNewService;
    }
    
    @Override
    public ConstructProcessor prepareProcess(final ConstructContext context) {
        return new ConstructProcessor(
            this::process,
            //Or input -> process(input)
            new Argument("input", fromValue(100), ATOMIC)
        );
    }
    
    private MetaExpression process(MetaExpression input) {
        String value = input.getStringValue() + myNewService.getRandomString();
        return fromValue(value);
    }

}

```

## Errors & Warnings
With great power comes great responsibility, and this platform is no 
exception. No matter how bullet proof you have designed your software 
there will always be this clever developer who can break it. To prevent 
this from happening there are two error systems in place.

### Logging
In the constructs you will have access to a *ConstructContext* this 
context is an object that contains various pieces of information about 
the robot that is currently running, like the path to the robot and the 
path to the project root. One of the key pieces is the root logger. 
This logger is tied into the error system and will trigger all kinds of 
responses that have been set by the user. You can use this logger do 
display errors, warnings or simple notifications to the Xill programmer. 
In the example in the right you can see how this logger is used to 
generate errors. The benefit of logging this way is that you can still 
try to recover from the error by returning something sensible.

However, by default the Xill processor does not listen to these 
messages. It is up to the debugger you are using whether or not to 
stop, pause or ignore these errors.

```java
public class ErrorConstruct extends Construct {
    @Override 
    public ConstructProcessor prepareProcess(ConstructContext context) {
        return new ConstructProcessor(
            input -> process(input, context.getRootLogger()),
            new Argument("input", fromValue(""), ATOMIC)
        );
    }
    
    private MetaExpression process(MetaExpression input, Logger logger) {
        String message = input.getStringValue();
        logger.error(logger);
        return fromValue("Errror: " + message);
    }
}
```

### Exceptions
A more drastic way of throwing errors is by throwing the 
RobotRuntimeException. In the example to below you can see how this 
construct is used in combination with the logger. However, throwing the 
exception means that you can no longer return a value so `null` will be 
returned.

This is generally **only** good practice if your construct cannot 
continue it's execution.

```java
public class LogSafeConstruct extends Construct {
    @Override 
    public ConstructProcessor prepareProcess(ConstructContext context) {
        return new ConstructProcessor(
            input -> process(input, context.getRootLogger()),
            new Argument("input", fromValue(""), ATOMIC)
        );
    }
    
    private MetaExpression process(MetaExpression input, Logger logger) {
        String message = input.getStringValue();
        
        if(message.matches(".*[p|P]assword.*")) {
            throw new RobotRuntimeException("Tried to log the word password!");
        }
        
        logger.info(message);
        
        return fromValue("Safe: " + message);
    }
}
```

### Communicating Between Constructs
Sometimes the simple data types that the MetaExpression provides aren't 
enough to build your plugin. You might want to communicate between your 
constructs. This is made possible by the empty MetadataExpression 
interface.

The MetaExpression has two methods called storeMeta and getMeta. These 
methods can be used to store MetadataExpressions. Let's take a close 
look at an example.

> **Best Practice:** To ensure consistency in all plugins it is good 
  practice to create a subpackage called 'data' in the plugin project.

The first thing we need to do to make this communication happen is 
creating a MetadataExpression. This object will be passed into a 
MetaExpression as hidden information.

This is done by implementing the MetadataExpression interface. In our 
example we will be wrapping a FileInputStream. An observant developer 
will notice that this wrapper is not able to close the stream (if you 
want to know more about that check out [Working with Resources](#working-with-resources).
The reason that the MetadataExpression should be implemented is because 
this is the framework's way of enforcing the creation of data wrappers. 
If this was not the case then a developer could for instance push String 
objects into the MetaExpression which might interfere with 
other plugins.

```java
public class MyDataResource implements MetadataExpression {
    private final FileInputStream stream;
    
    public MyDataResource(File file) throws FileNotFoundException {
        this.stream = new FileInputStream(file);
    }
    
    public FileInputStream getStream() {
        return stream;
    }
}
```

The next step is making the communication. To demonstrate this I have 
created two constructs: one that loads the stream we just created and 
one that reads all text from it. Let's walk through them

```java
public class LoadConstruct extends Construct {
    @Override 
    public ConstructProcessor prepareProcess(ConstructContext context) {
        return new ConstructProcessor(
            path -> process(path, context.getRobotID()),
            new Argument("path", ATOMIC)
        );
    }
    
    private MetaExpression process(MetaExpression path, RobotID robotID) {
        File file = getFile(robotID, path.getStringValue());
        
        // Create the expression
        MetaExpression result;
        
        try {
            result = fromValue(file.getCanonicalPath());
        } catch (IOException e) {
            throw new RobotRuntimeException("Failed to open stream: " + e.getMessage(), e);
        }
    
        // Push the stream
        MyDataResource resource;
        try {
            resource = new MyDataResource(file);
            result.storeMeta(MyDataResource.class, resource);
        } catch (FileNotFoundException e) {
            throw new RobotRuntimeException("File " + result.getStringValue() + " could not be found.");
        }
    
        return result;
    }
}
```

```java
public class ReadTextConstruct extends Construct {
    @Override 
    public ConstructProcessor prepareProcess(ConstructContext context) {
        return new ConstructProcessor(
            this::process,
            new Argument("stream", ATOMIC)
        );
    }
    
    private MetaExpression process(MetaExpression stream) {
        MyDataResource resource = assertMeta(stream, "stream", MyDataResource.class, "File Resource");
        
        try {
            String contents = IOUtils.toString(resource.getStream());
            return fromValue(contents);
        } catch (IOException e) {
            throw new RobotRuntimeException("Failed to read stream: " + e.getMessage(), e);
        }
    }
}
```
#### Loading the Resource

In the LoadConstruct we initialize a MyDataResource from the path 
provided by the xill programmer. This resource is then pushed into the 
result MetaExpression.

> **Best Practice:** Generally the construct should not be instantiating 
  the resources, this job belongs to the service. However, for brevity 
  and demonstration purposes we instantiate it here now.

This resource will now remain inside the MetaExpression until it loses 
all it's references. Then it will be disposed.

#### Using the Resource
When this MetaExpression is passed to another construct (in our case the 
ReadTextConstruct) it will still contain the resource so we can get it 
using `assertMeta` while we also provide some friendly names for the 
error message. This method will throw a RobotRuntimeException when 
the expected resource is not available. If you do not want this behaviour
you can also use `MetaExpression.getMeta` to extract the data by itself.

#### Running
So now once we run this plugin in the Xill IDE application then 
we can run the following xill code and it will print the text that 
was present in the file.

```
use Guide;
use System;
var stream = Guide.load("...path to text file...");
var text = Guide.readText(stream);
System.print(text);
```

[Google Guice]: https://github.com/google/guice/wiki/Motivation