# Advanced Topics
This section will cover several topics that are more specific for 
certain situations. These chapters are not required knowledge to make a 
plugin but usage of the subjects will improve the plugin quality.

## Working with Resources

> **Note:** This page is an extension 
  on [Communicating Between Constructs](#communicating-between-constructs), 
  if you haven't read that page yet it is advised to do so first.

When reading the [Communicating Between Constructs](#communicating-between-constructs) 
section you might have noticed that we never close our streams. This will 
cause problems when opening a lot of streams in a single script or when 
the file needs to be accessed. The solution to this problem is to work 
with a Resource.

### Define a Resource
To label a MetadataExpression as a resource it should implement the 
AutoCloseable interface. This will allow the MetadataExpressionPool 
to close the resource when the MetaExpression loses its last reference. 
In the example to the right you can see how this is used to close the 
streams once the MetaExpression leaves the scope.

```java
public class MyDataResource implements MetadataExpression, 
    AutoCloseable {
    
    private final FileInputStream stream;
    
    public MyDataResource(File file) throws FileNotFoundException {
        this.stream = new FileInputStream(file);
    }
    
    public FileInputStream getStream() {
        return stream;
    }
    
    @Override
    public void close() throws Exception {
        stream.close();
    }
}
```