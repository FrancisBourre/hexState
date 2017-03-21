package hex.state.mock;

import haxe.Timer;
import hex.control.async.AsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class InviteForRegisterMockCommand extends AsyncCommand
{
	@Inject
	public var logger : IMockCommandLogger;

	override public function execute() : Void
	{
		Timer.delay( this._execute, 50 );
	}
	
	function _execute() : Void
	{
		this.logger.log( "IFR" );
		this._handleComplete();
	}
}