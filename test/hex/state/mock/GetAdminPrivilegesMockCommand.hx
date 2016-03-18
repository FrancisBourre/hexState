package hex.state.mock;

import hex.di.ISpeedInjectorContainer;
import hex.control.command.BasicCommand;
import hex.control.Request;

/**
 * ...
 * @author Francis Bourre
 */
class GetAdminPrivilegesMockCommand extends BasicCommand implements ISpeedInjectorContainer
{
	@Inject
	public var logger : IMockCommandLogger;

	override public function execute( ?request : Request ) : Void
	{
		this.logger.log( "GAP" );
	}
}