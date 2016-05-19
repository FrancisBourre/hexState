package hex.state.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;
import hex.data.IParser;
import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandWithRequest extends BasicCommand implements IInjectorContainer
{
	@Inject
	public var logger : IMockCommandLogger;
	
	@Inject
	public var parser : IParser<String>;
	
	public function execute( ?request : Request ) : Void 
	{
		this.logger.log( this.parser.parse( ( cast request ).code ) );
	}
}