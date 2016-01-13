package hex.state.mock;

import hex.data.IParser;

/**
 * ...
 * @author Francis Bourre
 */
class MockCaseParser implements IParser
{

	public function new() 
	{
		
	}
	
	public function parse( serializedContent : Dynamic, target:Dynamic = null ) : Dynamic 
	{
		return ( cast serializedContent ).toUpperCase();
	}
	
}