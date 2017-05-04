package hex.state;

import hex.collection.ArrayMap;
import hex.control.command.ICommandMapping;

/**
 * ...
 * @author Francis Bourre
 */
class StateUnmapper
{
	static var _stateUnmapper : ArrayMap<State, StateUnmapper> = new ArrayMap();
	
	var _state 			: State;
	var _enterMappings 	: Array<ICommandMapping> = [];
	var _exitMappings 	: Array<ICommandMapping> = [];
	
	public function new( state : State )
	{
		this._state = state;
	}
	
	public function unmap() : Void
	{
		for ( m in this._enterMappings ) this._state.removeEnterCommandMapping( m );
		for ( m in this._exitMappings ) this._state.removeExitCommandMapping( m );
		
		this._state 		= null;
		this._enterMappings = null;
		this._exitMappings 	= null;
	}
	
	public function addEnterMapping( mapping : ICommandMapping ) : Void
	{
		this._enterMappings.push( mapping );
	}
	
	public function addExitMapping( mapping : ICommandMapping ) : Void
	{
		this._exitMappings.push( mapping );
	}
	
	static public function register( state : State ) : StateUnmapper
	{
		var stateUnmapper : StateUnmapper = null;
		
		if ( !StateUnmapper._stateUnmapper.containsKey( state ) )
		{
			stateUnmapper = new StateUnmapper( state );
			StateUnmapper._stateUnmapper.put( state, stateUnmapper );
		}
		else
		{
			stateUnmapper = StateUnmapper._stateUnmapper.get( state );
		}
		
		return stateUnmapper;
	}
	
	static public function release() : Void
	{
		var stateUnmappers : Array<StateUnmapper> = StateUnmapper._stateUnmapper.getValues();
		for ( unmapper in stateUnmappers ) unmapper.unmap();
		StateUnmapper._stateUnmapper = new ArrayMap();
	}
}