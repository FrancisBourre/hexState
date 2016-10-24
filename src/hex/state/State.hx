package hex.state;

import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.di.IContextOwner;
import hex.event.MessageType;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class State
{
	var _stateName 					: String;
	var _stateMachine 				: StateMachine;

	var _transitions				= new Map<MessageType,Transition>();

	var _enterCommandMappings 		: Array<ICommandMapping> = [];
	var _exitCommandMappings 		: Array<ICommandMapping> = [];

	var _enterHandlers 				: Array<State->Void> = [];
	var _exitHandlers 				: Array<State->Void> = [];

	public function new( stateName : String )
	{
		this._stateName = stateName;
	}
	
	inline public function getName() : String
	{
		return this._stateName;
	}

	public function clearEnterHandler() : Void
	{
		this._enterHandlers = [];
	}

	public function clearExitHandler() : Void
	{
		this._exitHandlers = [];
	}

	public function getEnterHandlerList() : Array<State->Void>
	{
		return this._enterHandlers;
	}

	public function getExitHandlerList() : Array<State->Void>
	{
		return this._exitHandlers;
	}
	
	public function addEnterHandler( callback : State->Void ) : Bool
	{
		return this._addHandler( this._enterHandlers, callback );
	}

	public function addExitHandler( callback : State->Void ) : Bool
	{
		return this._addHandler( this._exitHandlers, callback );
	}

	public function removeEnterHandler( callback: State->Void ) : Bool
	{
		return this._removeHandler( this._enterHandlers, callback );
	}

	public function removeExitHandler( callback: State->Void ) : Bool
	{
		return this._removeHandler( this._exitHandlers, callback );
	}
	
	public function addEnterCommandMapping( mapping : ICommandMapping ) : Void
	{
		if ( this._enterCommandMappings.indexOf( mapping ) == -1 ) this._enterCommandMappings.push( mapping );
	}
	
	public function addExitCommandMapping( mapping : ICommandMapping ) : Void
	{
		if ( this._exitCommandMappings.indexOf( mapping ) == -1 ) this._exitCommandMappings.push( mapping );
	}
	
	public function removeEnterCommandMapping( mapping : ICommandMapping ) : Void
	{
		var i : Int = this._enterCommandMappings.indexOf( mapping );
		if ( i != -1 ) this._enterCommandMappings.splice( i, 1 );
	}
	
	public function removeExitCommandMapping( mapping : ICommandMapping ) : Void
	{
		var i : Int = this._exitCommandMappings.indexOf( mapping );
		if ( i != -1 ) this._exitCommandMappings.splice( i, 1 );
	}

	public function addEnterCommand( commandClass : Class<ICommand>, ?contextOwner : IContextOwner ) : ICommandMapping
	{
		var mapping = new CommandMapping( commandClass );
		mapping.setContextOwner( contextOwner );
		this._enterCommandMappings.push( mapping );
		return mapping;
	}

	public function addExitCommand( commandClass : Class<ICommand>, ?contextOwner : IContextOwner ) : ICommandMapping
	{
		var mapping = new CommandMapping( commandClass );
		mapping.setContextOwner( contextOwner );
		this._exitCommandMappings.push( mapping );
		return mapping;
	}

	public function addTransition( messageType : MessageType, targetState : State ) : Void
	{
		this._transitions.set( messageType, new Transition( this, messageType, targetState ) );
	}

	public function getMachine() : StateMachine
	{
		return this._stateMachine;
	}

	public function getEvents() : Array<MessageType>
	{
		var transitions : Array<Transition> = this.getTransitions();
		var result : Array<MessageType> 	= [];

		for ( transition in transitions )
		{
			result[ result.length ] = transition.getMessageType();
		}

		return result;
	}

	public function getAllTargets() : Array<State>
	{
		var transitions : Array<Transition> = this.getTransitions();
		var result : Array<State> 	= [];

		for ( transition in transitions )
		{
			result.push( transition.getTarget() );
		}

		return result;
	}

	public function getTransitions() : Array<Transition>
	{
		var i = this._transitions.iterator();
		var a = [];
		while ( i.hasNext() ) a.push( i.next() );
		return a;
	}

	public function hasTransition( messageType : MessageType ) : Bool
	{
		return this._transitions.exists( messageType );
	}

	public function targetState( messageType : MessageType ) : State
	{
		return this._transitions.get( messageType ).getTarget();
	}

	public function getEnterCommandMapping() : Array<ICommandMapping>
	{
		return this._enterCommandMappings;
	}

	public function getExitCommandMapping() : Array<ICommandMapping>
	{
		return this._exitCommandMappings;
	}

	public function toString() : String
	{
		return Stringifier.stringify( this ) + "::" + this._stateName;
	}

	inline function _addHandler( handlers : Array<State->Void>, callback : State->Void ) : Bool
	{
		if ( handlers.indexOf( callback ) == -1 )
		{
			handlers.push( callback );
			return true;
		}
		else
		{
			return false;
		}
	}

	inline function _removeHandler( handlers : Array<State->Void>, callback : State->Void ) : Bool
	{
		var id : Int = handlers.indexOf( callback );
		if (  id != -1 )
		{
			handlers.splice( id, 1 );
			return true;
		}
		else
		{
			return false;
		}
	}
}