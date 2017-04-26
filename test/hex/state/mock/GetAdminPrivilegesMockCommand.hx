package hex.state.mock;

import hex.control.command.BasicCommand;

/**
 * ...
 * @author Francis Bourre
 */
class GetAdminPrivilegesMockCommand extends BasicCommand
{
	@Inject
	public var commandLogger : IMockCommandLogger;

	override public function execute() : Void
	{
		this.commandLogger.log( "GAP" );
	}
}