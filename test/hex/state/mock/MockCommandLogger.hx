package hex.state.mock;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandLogger implements IMockCommandLogger
{
	var _logs : Array<String> = [];
	
	public function new() 
	{
		
	}

	public function log( commandCode : String ) : Void
	{
		this._logs.push( commandCode );
	}

	public function getLogs() : Array<String>
	{
		return this._logs.copy();
	}
}