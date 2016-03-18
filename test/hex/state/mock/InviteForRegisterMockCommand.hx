package hex.state.mock;

import hex.di.ISpeedInjectorContainer;
import haxe.Timer;
import hex.control.async.AsyncCommand;
import hex.control.Request;

/**
 * ...
 * @author Francis Bourre
 */
class InviteForRegisterMockCommand extends AsyncCommand implements ISpeedInjectorContainer
{
	@Inject
	public var logger : IMockCommandLogger;

	override public function execute( ?request : Request ) : Void
	{
		Timer.delay( this._execute, 50 );
	}
	
	function _execute() : Void
	{
		this.logger.log( "IFR" );
		this._handleComplete();
	}
}