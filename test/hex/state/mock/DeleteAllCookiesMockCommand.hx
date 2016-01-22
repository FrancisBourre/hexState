package hex.state.mock;

import hex.control.command.BasicCommand;
import hex.control.Request;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class DeleteAllCookiesMockCommand extends BasicCommand
{
	@Inject
	public var logger : IMockCommandLogger;

	override public function execute( ?request : Request ) : Void
	{
		this.logger.log( "DAC" );
	}
}