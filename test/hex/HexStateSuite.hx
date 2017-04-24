package hex;

import hex.state.StateMachineTest;

/**
 * ...
 * @author Francis Bourre
 */
class HexStateSuite
{
	@Suite( "HexState" )
    public var list : Array<Class<Dynamic>> = [StateMachineTest];
}