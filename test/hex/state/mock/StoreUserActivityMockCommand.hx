package hex.state.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;
import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class StoreUserActivityMockCommand extends BasicCommand implements IInjectorContainer
{
	@Inject
	public var logger : IMockCommandLogger;

	override public function execute( ?request : Request ) : Void
	{
		this.logger.log( "SUA" );
	}
}