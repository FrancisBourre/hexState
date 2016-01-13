package hex.state.mock;

import hex.control.command.BasicCommand;
import hex.control.Request;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class PrepareUserInfosMockCommand extends BasicCommand
{
	@inject
	public var logger : IMockCommandLogger;

	override public function execute( ?request : Request ) : Void
	{
		this.logger.log( "PUI" );
	}
}