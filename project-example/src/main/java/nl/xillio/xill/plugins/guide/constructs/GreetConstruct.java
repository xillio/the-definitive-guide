package nl.xillio.xill.plugins.guide.constructs;

import nl.xillio.xill.api.components.MetaExpression;
import nl.xillio.xill.api.construct.Argument;
import nl.xillio.xill.api.construct.Construct;
import nl.xillio.xill.api.construct.ConstructContext;
import nl.xillio.xill.api.construct.ConstructProcessor;
import org.slf4j.Logger;

/**
 * This construct demonstrates the basic functionality of a construct.
 * It will simply print a message to the log.
 *
 * @author Thomas Biesaart
 */
public class GreetConstruct extends Construct {
    public ConstructProcessor prepareProcess(ConstructContext constructContext) {
        return new ConstructProcessor(
                name -> process(constructContext, name),
                new Argument("name", fromValue("World"), ATOMIC)
        );
    }

    private MetaExpression process(ConstructContext constructContext, MetaExpression name) {
        Logger logger = constructContext.getRootLogger();

        logger.info("Hello " + name.getStringValue() + "!");

        return NULL;
    }
}
