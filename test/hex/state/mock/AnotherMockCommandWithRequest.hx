package hex.state.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;
import hex.data.IParser;

/**
 * ...
 * @author Francis Bourre
 */
class AnotherMockCommandWithRequest extends BasicCommand
{
	@Inject
	public var logger : IMockCommandLogger;
	
	@Inject
	public var parser : IParser<String>;
	
	public function execute( ?request : Request ) : Void 
	{
		( cast request ).method( this.parser.parse( ( cast request ).code ) );
	}
}