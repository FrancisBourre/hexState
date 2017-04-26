package hex.state.mock;

import hex.control.command.BasicCommand;

/**
 * ...
 * @author Francis Bourre
 */
class DeleteAllCookiesMockCommand extends BasicCommand
{
	@Inject
	public var commandLogger : IMockCommandLogger;

	override public function execute() : Void
	{
		this.commandLogger.log( "DAC" );
	}
}