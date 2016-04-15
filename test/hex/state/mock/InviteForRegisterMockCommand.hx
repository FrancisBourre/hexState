package hex.state.mock;

import haxe.Timer;
import hex.control.Request;
import hex.control.async.AsyncCommand;
import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class InviteForRegisterMockCommand extends AsyncCommand implements IInjectorContainer
{
	@Inject
	public var logger : IMockCommandLogger;

	public function execute( ?request : Request ) : Void
	{
		Timer.delay( this._execute, 50 );
	}
	
	function _execute() : Void
	{
		this.logger.log( "IFR" );
		this._handleComplete();
	}
}