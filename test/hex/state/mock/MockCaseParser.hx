package hex.state.mock;

import hex.data.IParser;

/**
 * ...
 * @author Francis Bourre
 */
class MockCaseParser implements IParser<String>
{
	public function new() 
	{
		
	}
	
	public function parse( serializedContent : Dynamic, target:Dynamic = null ) : String 
	{
		return ( cast serializedContent ).toUpperCase();
	}
	
}