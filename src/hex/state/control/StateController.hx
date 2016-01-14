package hex.state.control;

import hex.control.async.AsyncCommand;
import hex.control.command.ICommandMapping;
import hex.control.Request;
import hex.di.IDependencyInjector;
import hex.event.BasicHandler;
import hex.event.MessageType;
import hex.state.control.StateChangeMacro;

/**
 * ...
 * @author Francis Bourre
 */
class StateController
{
	private var _injector				: IDependencyInjector;

	private var _stateMachine			: StateMachine;
	private var _isInTransition			: Bool;
	private var _currentState			: State;
	private var _targetState			: State;

	private var _request				: Dynamic;

	public function new( injector : IDependencyInjector, stateMachine : StateMachine )
	{
		this._injector 			= injector;

		this._stateMachine 		= stateMachine;
		this._currentState 		= this._stateMachine.getStart();
		this._isInTransition 	= false;
	}

	private function transitionTo( target : State, ?request : Request ) : Void
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
				//this._injector.mapToValue( Request, request );
			}

			this._targetState 		= target;
			this._dispatchStateChange( this._currentState, this._currentState.getExitHandlerList() );
			this._triggerCommand( this._currentState.getExitSubCommandMapping(), this._onExitCurrentState );
		}
	}

	private function _triggerCommand( mappings : Array<ICommandMapping>, callback : AsyncCommand->Void ) : Void
	{
		if ( mappings.length > 0 )
		{
			var sm : StateChangeMacro = this._injector.instantiateUnmapped( StateChangeMacro );
			for ( mapping in mappings )
			{
				sm.addMapping( mapping );
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

	private function _onExitCurrentState( cmd : AsyncCommand ) : Void
	{
		this._triggerCommand( this._targetState.getEnterSubCommandMapping(), this._onEnterTargetState );
	}

	private function _onEnterTargetState( cmd : AsyncCommand ) : Void
	{
		if ( this._request )
		{
			//this._injector.unmap( Request );
			this._request = null;
		}

		this._currentState = this._targetState;
		this._isInTransition = false;
		this._dispatchStateChange( this._currentState, this._currentState.getEnterHandlerList() );
	}

	private function _dispatchStateChange( state : State, handlers : Array<BasicHandler> ) : Void
	{
		for ( handler in handlers )
		{
			Reflect.callMethod( handler.scope, handler.callback, [ state ] );
		}
	}
}