package hex.state.mock;

import hex.control.payload.ExecutionPayload;
import hex.control.Request;

/**
 * ...
 * @author Francis Bourre
 */
class MockRequest extends Request
{
	public var code 	: String 		= null;
	public var method 	: String->Void 	= null;
		
	public function new( executionPayloads : Array<ExecutionPayload> ) 
	{
		super( executionPayloads );
	}
}