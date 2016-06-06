## Components of Xill
Xill is built on a modular framework with modules that have very clear
responsibilities. 

![Components of the Xill Ecosystem](resources/xill_components.png)

### Language
The language module is where the xill syntax is defined and where scripts
are converted to token trees. These trees contain all information and
references that can be resolved later to add functionality. No processing
is done in this module other than syntax and sanity checking of the scripts.

### Processor
The processor module is where the magic happens. This module is responsible
for the execution of scripts. It will take a syntax tree and parse it to
a processable object. It does most of the required resource management and
is mainly responsible for error handling and debugging.

### API
The API contains all shared classes. This module does not have a functional
responsibility other than to provide a shared interface for plugins to
talk to. It contains essential classes like the [`MetaExpression`](#metaexpression)
and all the shared data types like XML, Date and more.

### Plugins
Now this is what this guide is about. The plugins add actual functionality
to Xill. They allow calls to other Java libraries or perform specific
operations. They are represented in the Xill language as a package that
contains a collection of *constructs*. 

A *construct* in Xill is a function that takes a fixed amount of expressions
(with defaults) as input and performs a specific operation. All these
*construct* are connected to each other in their own sandbox inside the
plugin package. This means the will not affect *constructs* in other plugins.

The plugin packages are managed by the Xill processor module.

```javascript
use System;
// In this case `System` is a plugin package.

// And System.print is a construct.
System.print("Hello World");
```
