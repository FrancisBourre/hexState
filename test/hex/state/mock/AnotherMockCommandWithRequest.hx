package hex.state.mock;

import hex.control.command.BasicCommand;
import hex.data.IParser;

/**
 * ...
 * @author Francis Bourre
 */
class AnotherMockCommandWithRequest extends BasicCommand
{
	@Inject
	public var code : String;
	
	@Inject
	public var commandLogger : IMockCommandLogger;
	
	@Inject
	public var parser : IParser<String>;
	
	override public function execute() : Void
	{
		this.commandLogger.log( this.parser.parse( this.code ) );
	}
}