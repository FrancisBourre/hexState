package hex.state.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;

/**
 * ...
 * @author Francis Bourre
 */
class StoreUserActivityMockCommand extends BasicCommand
{
	@Inject
	public var logger : IMockCommandLogger;

	override public function execute() : Void
	{
		this.logger.log( "SUA" );
	}
}