package hex.state.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;
import hex.data.IParser;
import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class AnotherMockCommandWithRequest extends BasicCommand implements IInjectorContainer
{
	@Inject
	public var logger : IMockCommandLogger;
	
	@Inject
	public var parser : IParser;
	
	override public function execute( ?request : Request ) : Void 
	{
		( cast request ).method( this.parser.parse( ( cast request ).code ) );
	}
}