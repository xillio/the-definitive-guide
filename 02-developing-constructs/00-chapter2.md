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
![Construct FlowChart](resources/construct_overview_flow_chart.png)
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