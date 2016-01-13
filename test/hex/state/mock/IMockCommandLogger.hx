package hex.state.mock;

/**
 * @author Francis Bourre
 */

interface IMockCommandLogger 
{
	function log( commandCode : String ) : Void;
	function getLogs() : Array<String>;
}