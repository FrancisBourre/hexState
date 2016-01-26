package hex.state;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class StateMachine
{
	var _start : State;

	public function new( start : State )
	{
		this._start = start;
	}

	public function addResetMessageType( messageTypes : Array<MessageType> ) : Void
	{
		for ( messageType in messageTypes )
		{
			if ( messageType != null )
			{
				this._addResetMessageType_byAddingTransition( messageType );
			}
		}
	}

	function _addResetMessageType_byAddingTransition( messageType : MessageType ) : Void
	{
		var states : Array<State> = this.getStates();

		for ( state in states)
		{
			if ( state.hasTransition( messageType ) )
			{
				state.addTransition( messageType, this._start );
			}
		}
	}

	public function getStates() : Array<State>
	{
		var result : Array<State> = [];
		this._collectStates( result, this._start );
		return result;
	}

	function _collectStates( result : Array<State>, state : State ) : Void
	{
		if ( this._start == null || result.indexOf( state ) != -1 )
		{
			return;
		}
		else
		{
			result.push( state );

			var targets : Array<State> 	= state.getAllTargets();
			for ( target in targets )
			{
				this._collectStates( result, target );
			}
		}
	}

	public function getStart() : State
	{
		return this._start;
	}

	public function isResetMessageType( messageType : MessageType ) : Bool
	{
		var states : Array<State> = this.getStates();

		for ( state in states )
		{
			if ( state.hasTransition( messageType ) && state.targetState( messageType ) == this._start )
			{
				return true;
			}
		}

		return false;
	}
	
}