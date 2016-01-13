package hex.state.mock;

import hex.control.command.BasicCommand;
import hex.control.Request;
import hex.data.IParser;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class AnotherMockCommandWithRequest extends BasicCommand
{
	@inject
	public var logger : IMockCommandLogger;
	
	@inject
	public var parser : IParser;
	
	override public function execute( ?request : Request ) : Void 
	{
		( cast request ).method( this.parser.parse( ( cast request ).code ) );
	}
}