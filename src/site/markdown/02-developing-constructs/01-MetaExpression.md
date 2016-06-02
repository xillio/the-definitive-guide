Let's start by explaining the MetaExpression. This class is the most 
important class you will use in your plugin as it represents an 
expression in the Xill language. There are a couple of things you need 
to know.

## The Three Musketeers

The language contains three main structures for ordering expressions. 
These structures all behave in their own way.

```java
MetaExpression expression = fromValue(data);
ExpressionDataType type = expression.getType();
```

### ATOMIC
An atomic expression represents a single value. Some examples of this 
would be '5', "Hello World" or true. This expression has no additional 
behavior you should be aware of.

#### Getting Values from an ATOMIC Expression

```java
String stringValue = expression.getStringValue();
double doubleValue = expression.getNumberValue().doubleValue();
  
// Check if the input is a number
if(Double.isNaN(doubleValue)) {
    //This is not a number
}
```

### LIST
The LIST type represents a list of MetaExpressions. They can be accessed 
in Xill using the [] operator (like list[5] to get element at index 5).

#### Getting the List of Values from an Expression
```java
if(expression.getType() == ExpressionDataType.LIST) {
    List<MetaExpression> children = expression.getValue();
}
```

> Note that getValue() will automatically cast to whatever you assign
> so it is very important that you perform the type check first.

### OBJECT
The OBJECT type represents a list of MetaExpressions indexed by String. 
They can be accessed in Xill using the [] operator or the . operator 
(object.value gets the expression in the object with key value).

#### Getting the Map of Values from an Expression
```java
if(expression.getType() == ExpressionDataType.OBJECT) {
    Map<String, MetaExpression> children = (Map<String, MetaExpression>)expression.getValue();
}
```

## Every Expression has Every Type
That's right, every single expression has every type. This means that 
every expression has a String, Number and Boolean representation. This 
is how we try to overcome the continuous casting between those types.

|  | String | Boolean | Number |
| ATOMIC | Actual Value | | |
| LIST | | | |
| OBJECT | | | |