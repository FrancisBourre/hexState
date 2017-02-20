package hex.state.mock;

import hex.control.command.BasicCommand;
import hex.data.IParser;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandWithRequest extends BasicCommand
{
	@Inject
	public var code : String;
	
	@Inject
	public var logger : IMockCommandLogger;
	
	@Inject
	public var parser : IParser<String>;
	
	override public function execute() : Void
	{
		this.logger.log( this.parser.parse( this.code ) );
	}
}