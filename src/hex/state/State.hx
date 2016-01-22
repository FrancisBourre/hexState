package hex.state;

import hex.collection.HashMap;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.di.IBasicInjector;
import hex.di.IContextOwner;
import hex.event.BasicHandler;
import hex.event.MessageType;
import hex.log.Stringifier;
import hex.module.Module;

/**
 * ...
 * @author Francis Bourre
 */
class State
{
	private var _stateName 					: String;
	private var _stateMachine 				: StateMachine;

	private var _transitions				: HashMap<MessageType, Transition> = new HashMap();

	private var _enterCommandMappings 	: Array<ICommandMapping> = [];
	private var _exitCommandMappings 	: Array<ICommandMapping> = [];

	private var _enterHandlers 				: Array<BasicHandler> = [];
	private var _exitHandlers 				: Array<BasicHandler> = [];

	public function new( stateName : String )
	{
		this._stateName = stateName;
	}

	public function clearEnterHandler() : Void
	{
		this._enterHandlers = [];
	}

	public function clearExitHandler() : Void
	{
		this._exitHandlers = [];
	}

	public function getEnterHandlerList() : Array<BasicHandler>
	{
		return this._enterHandlers;
	}

	public function getExitHandlerList() : Array<BasicHandler>
	{
		return this._exitHandlers;
	}
	
	public function addEnterHandler( scope : {}, callback : State->Void ) : Bool
	{
		return this._addHandler( this._enterHandlers, new BasicHandler( scope, callback ) );
	}

	public function addExitHandler( scope : {}, callback : State->Void ) : Bool
	{
		return this._addHandler( this._exitHandlers, new BasicHandler( scope, callback ) );
	}

	public function removeEnterHandler( handler : BasicHandler ) : Bool
	{
		return this._removeHandler( this._enterHandlers, handler );
	}

	public function removeExitHandler( handler : BasicHandler ) : Bool
	{
		return this._removeHandler( this._exitHandlers, handler );
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
		var mapping : ICommandMapping = new CommandMapping( commandClass );
		mapping.setContextOwner( contextOwner );
		this._enterCommandMappings.push( mapping );
		return mapping;
	}

	public function addExitCommand( commandClass : Class<ICommand>, ?contextOwner : IContextOwner ) : ICommandMapping
	{
		var mapping : CommandMapping = new CommandMapping( commandClass );
		mapping.setContextOwner( contextOwner );
		this._exitCommandMappings.push( mapping );
		return mapping;
	}

	public function addTransition( messageType : MessageType, targetState : State ) : Void
	{
		this._transitions.put( messageType, new Transition( this, messageType, targetState ) );
	}

	public function getMachine() : StateMachine
	{
		return this._stateMachine;
	}

	public function getEvents() : Array<MessageType>
	{
		var transitions : Array<Transition> = this._transitions.getValues();
		var result : Array<MessageType> 	= [];

		for ( transition in transitions )
		{
			result[ result.length ] = transition.getMessageType();
		}

		return result;
	}

	public function getAllTargets() : Array<State>
	{
		var transitions : Array<Transition> = this._transitions.getValues();
		var result : Array<State> 	= [];

		for ( transition in transitions )
		{
			result.push( transition.getTarget() );
		}

		return result;
	}

	public function getTransitions() : Array<Transition>
	{
		return this._transitions.getValues();
	}

	public function hasTransition( messageType : MessageType ) : Bool
	{
		return this._transitions.containsKey( messageType );
	}

	public function targetState( messageType : MessageType ) : State
	{
		return this._transitions.get( messageType ).getTarget();
	}

	public function getEnterSubCommandMapping() : Array<ICommandMapping>
	{
		return this._enterCommandMappings;
	}

	public function getExitSubCommandMapping() : Array<ICommandMapping>
	{
		return this._exitCommandMappings;
	}

	public function toString() : String
	{
		return Stringifier.stringify( this ) + "::" + this._stateName;
	}

	private function _addHandler( handlers : Array<BasicHandler>, handler : BasicHandler ) : Bool
	{
		if ( handlers.indexOf( handler ) == -1 )
		{
			handlers.push( handler );
			return true;
		}
		else
		{
			return false;
		}
	}

	private function _removeHandler( handlers : Array<BasicHandler>, handler : BasicHandler ) : Bool
	{
		var id : Int = handlers.indexOf( handler );
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