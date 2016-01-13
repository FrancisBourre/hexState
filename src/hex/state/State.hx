package hex.state;

import hex.collection.HashMap;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.event.DynamicHandler;
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

	private var _enterSubCommandMappings 	: Array<ICommandMapping> = [];
	private var _exitSubCommandMappings 	: Array<ICommandMapping> = [];

	private var _enterHandlers 				: Array<DynamicHandler> = [];
	private var _exitHandlers 				: Array<DynamicHandler> = [];

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

	public function getEnterHandlerList() : Array<DynamicHandler>
	{
		return this._enterHandlers;
	}

	public function getExitHandlerList() : Array<DynamicHandler>
	{
		return this._exitHandlers;
	}

	/*public function addEnterHandler( handler : DynamicHandler ) : Bool
	{
		return this._addHandler( this._enterHandlers, handler );
	}

	public function addExitHandler( handler : DynamicHandler ) : Bool
	{
		return this._addHandler( this._exitHandlers, handler );
	}*/
	
	public function addEnterHandler( scope : {}, callback : State->Void ) : Bool
	{
		return this._addHandler( this._enterHandlers, new DynamicHandler( scope, callback ) );
	}

	public function addExitHandler( scope : {}, callback : State->Void ) : Bool
	{
		return this._addHandler( this._exitHandlers, new DynamicHandler( scope, callback ) );
	}

	public function removeEnterHandler( handler : DynamicHandler ) : Bool
	{
		return this._removeHandler( this._enterHandlers, handler );
	}

	public function removeExitHandler( handler : DynamicHandler ) : Bool
	{
		return this._removeHandler( this._exitHandlers, handler );
	}

	public function addEnterCommand( commandClass : Class<ICommand>, ?module : Module ) : ICommandMapping
	{
		var mapping : ICommandMapping = new CommandMapping( commandClass );

		if ( module != null )
		{
			mapping.setInjector( module.getBasicInjector() );
		}

		this._enterSubCommandMappings.push( mapping );

		/*if ( this._stateMachine != null)
		{
			this._stateMachine.stateChanged( this );
		}*/

		return mapping;
	}

	public function addExitCommand( commandClass : Class<ICommand>, ?module : Module ) : ICommandMapping
	{
		var mapping : CommandMapping = new CommandMapping( commandClass );
		
		if ( module != null )
		{
			mapping.setInjector( module.getBasicInjector() );
		}

		this._exitSubCommandMappings.push( mapping );

		/*if ( this._stateMachine != null)
		 {
		 this._stateMachine.stateChanged( this );
		 }*/

		return mapping;
	}

	public function addTransition( messageType : MessageType, targetState: State) : Void
	{
		this._transitions.put( messageType, new Transition( this, messageType, targetState ) );

		/*if ( this._stateMachine != null )
		{
			this._stateMachine.stateChanged( this );
		}*/
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
		return this._enterSubCommandMappings;
	}

	public function getExitSubCommandMapping() : Array<ICommandMapping>
	{
		return this._exitSubCommandMappings;
	}

	public function toString() : String
	{
		return Stringifier.stringify( this ) + "::" + this._stateName;
	}

	private function _addHandler( handlers : Array<DynamicHandler>, handler : DynamicHandler ) : Bool
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

	private function _removeHandler( handlers : Array<DynamicHandler>, handler : DynamicHandler ) : Bool
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