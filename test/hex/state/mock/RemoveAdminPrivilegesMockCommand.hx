package hex.state.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;

/**
 * ...
 * @author Francis Bourre
 */
class RemoveAdminPrivilegesMockCommand extends BasicCommand
{
	@Inject
	public var logger : IMockCommandLogger;

	public function execute( ?request : Request ) : Void
	{
		this.logger.log( "RAP" );
	}
}