package hex.state.config.stateful;

import hex.config.stateful.IStatefulConfig;
import hex.di.Dependency;
import hex.di.IDependencyInjector;
import hex.event.IDispatcher;
import hex.module.IContextModule;
import hex.state.control.StateController;

using hex.di.util.InjectorUtil;

/**
 * ...
 * @author Francis Bourre
 */
class StatefulStateMachineConfig implements IStatefulConfig
{
	var _stateMachine 		: StateMachine;
	var _stateController 	: StateController;
	var _startState 		: State;

	public function new( startState : State ) 
	{
		this._startState = startState;
	}
	
	public function configure( injector : IDependencyInjector, module : IContextModule ) : Void
	{
		this._stateMachine = new StateMachine( this._startState );
		this._stateController = new StateController( injector, this._stateMachine );

		injector.mapToValue( StateMachine, this._stateMachine );
		injector.mapToValue( StateController, this._stateController );

		injector.getDependencyInstance( new Dependency<IDispatcher<{}>>() ).addListener( this._stateController );
	}
}