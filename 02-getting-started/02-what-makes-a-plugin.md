## What Makes a Plugin

Let's take a more detailed look at the things a plugin contains.
We saw earlier that it contains a *package* and some *constructs*, but
there is a little bit more to it than that. If you want to know how to
implement these specific parts then skip to [Developing a Plugin](#developing-a-plugin).

### Package Declaration
The first requirement of a plugin is that it has a *package declaration*.
This declaration specifies where the Processor can find the plugin so it
can be loaded into the framework. If you use our maven build this declaration
will be automatically generated.

### Package Implementation
The second requirement is the actual implementation of the package. This
implementation is the class referenced by the package declaration and is 
usually a subclass of `XillPlugin`.

### Constructs
Now strictly speaking we do not need *constructs* to form a plugin, however
without any your plugin will be fairly boring. 
These *constructs* are implementations of the abstract `Construct` class
and they provide a way for the processor module to perform any operation.

They are loaded by the package implementation and kept in the same sandbox
as the other constructs in that package.

> **Note:** For the more advanced Java developers, when we are talking
> about a sandbox what we really mean is that they have their own
> classloader.
