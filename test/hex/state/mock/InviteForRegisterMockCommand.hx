package hex.state.mock;

import haxe.Timer;
import hex.control.async.AsyncCommand;
import hex.control.command.BasicCommand;
import hex.control.Request;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class InviteForRegisterMockCommand extends AsyncCommand
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