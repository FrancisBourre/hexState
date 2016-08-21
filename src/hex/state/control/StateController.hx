package hex.state.control;

import hex.control.Request;
import hex.control.async.AsyncCommand;
import hex.control.command.ICommandMapping;
import hex.di.IBasicInjector;
import hex.event.BasicHandler;
import hex.event.MessageType;
import hex.state.control.StateChangeMacro;

/**
 * ...
 * @author Francis Bourre
 */
@:keepSub
class StateController
{
	var _injector				: IBasicInjector;

	var _stateMachine			: StateMachine;
	var _isInTransition			: Bool;
	var _currentState			: State;
	var _targetedState			: State;

	var _request				: Request;

	public function new( injector : IBasicInjector, stateMachine : StateMachine )
	{
		this._injector 			= injector;

		this._stateMachine 		= stateMachine;
		this._currentState 		= this._stateMachine.getStart();
		this._isInTransition 	= false;
	}

	function transitionTo( target : State, ?request : Request ) : Void
	{
		if ( this._isInTransition )
		{
			//store
		}
		else
		{
			this._isInTransition 	= true;

			if ( request != null )
			{
				this._request 	= request;
			}

			this._targetedState 		= target;
			this._dispatchStateChange( this._currentState, this._currentState.getExitHandlerList() );
			this._triggerCommand( this._currentState.getExitCommandMapping(), this._onExitCurrentState );
		}
	}

	function _triggerCommand( mappings : Array<ICommandMapping>, callback : AsyncCommand->Void ) : Void
	{
		if ( mappings.length > 0 )
		{
			var sm : StateChangeMacro = this._injector.instantiateUnmapped( StateChangeMacro );
			
			var mappingToRemove : Array<ICommandMapping> = [];
			for ( mapping in mappings )
			{
				if ( mapping.isFiredOnce )
				{
					mappingToRemove.push( mapping );
				}
				
				sm.addMapping( mapping );
			}
			
			for ( mapping in mappingToRemove )
			{
				mappings.splice( mappings.indexOf( mapping), 1 );
			}

			sm.addCompleteHandler( this, callback );
			sm.addFailHandler( this, callback );
			sm.addCancelHandler( this, callback );
			sm.preExecute();
			sm.execute( this._request );
		}
		else
		{
			callback( null );
		}
	}

	public function handleMessage( messageType : MessageType, ?request : Request ) : Void
	{
		if ( this._currentState.hasTransition( messageType ) )
		{
			this.transitionTo( this._currentState.targetState( messageType ), request );
		}
		else if ( this._stateMachine.isResetMessageType( messageType ) )
		{
			this.transitionTo( this._stateMachine.getStart(), request );
		}
	}

	public function getCurrentState() : State
	{
		return this._currentState;
	}
	
	public function getTargetedState() : State
	{
		return this._targetedState;
	}

	function _onExitCurrentState( cmd : AsyncCommand ) : Void
	{
		this._triggerCommand( this._targetedState.getEnterCommandMapping(), this._onEnterTargetState );
	}

	function _onEnterTargetState( cmd : AsyncCommand ) : Void
	{
		if ( this._request != null )
		{
			this._request = null;
		}

		this._currentState = this._targetedState;
		this._isInTransition = false;
		this._dispatchStateChange( this._currentState, this._currentState.getEnterHandlerList() );
	}

	function _dispatchStateChange( state : State, handlers : Array<BasicHandler> ) : Void
	{
		for ( handler in handlers )
		{
			Reflect.callMethod( handler.scope, handler.callback, [ state ] );
		}
	}
}