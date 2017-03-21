package hex.state;

import haxe.Timer;
import hex.control.Request;
import hex.control.macro.IMacroExecutor;
import hex.control.macro.MacroExecutor;
import hex.control.payload.ExecutionPayload;
import hex.data.IParser;
import hex.di.IBasicInjector;
import hex.di.Injector;
import hex.event.Dispatcher;
import hex.event.MessageType;
import hex.state.control.StateController;
import hex.state.mock.*;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

/**
 * ...
 * @author Francis Bourre
 */
class StateMachineTest
{
	var _injector			: Injector;
	var _stateMachine 		: StateMachine;
	var _controller			: StateController;
	var _commandLogger		: IMockCommandLogger;
	var _transitionListener	: MockTransitionListener;
	
	// States
	var anonymous			: State;
	var guest				: State;
	var user				: State;
	var administrator		: State;
	
	// MessageTypes
	var logAsUser			: MessageType;
	var logAsGuest			: MessageType;
	var logout				: MessageType;
	var logAsAdministrator	: MessageType;

	@Before
    public function setUp() : Void
    {
		this._injector 		= new Injector();
		this._commandLogger = new MockCommandLogger();
		
		this._injector.map( IMockCommandLogger ).toValue( this._commandLogger );
		this._injector.map( IBasicInjector ).toValue( this._injector );
		this._injector.map( IMacroExecutor ).toType( MacroExecutor );
		
		// MessageTypes
		this.logAsUser 			= new MessageType( "onLogin" );
		this.logAsGuest 		= new MessageType( "onLogAsGuest" );
		this.logout 			= new MessageType( "onLogout" );
		this.logAsAdministrator = new MessageType( "onLogAsAdministrator" );
		
		// States
		this.anonymous 		= new State( "anonymous" );
		this.guest 			= new State( "guest" );
		this.user 			= new State( "user" );
		this.administrator 	= new State( "administrator" );
			
        this._stateMachine 	= new StateMachine( this.anonymous );
		this._controller 	= new StateController( this._injector, this._stateMachine );
		
		this.anonymous.addEnterCommand( DeleteAllCookiesMockCommand );
		this.anonymous.addEnterCommand( DisplayAddBannerMockCommand );
		this.anonymous.addTransition( this.logAsUser, this.user );
		this.anonymous.addTransition( this.logAsGuest, this.guest );

		this.user.addEnterCommand( PrepareUserInfosMockCommand );
		this.user.addEnterCommand( DisplayWelcomeMessageMockCommand );
		this.user.addExitCommand( StoreUserActivityMockCommand );
		this.user.addTransition( this.logAsAdministrator, this.administrator );

		this.guest.addEnterCommand( DisplayAddBannerMockCommand );
		this.guest.addEnterCommand( InviteForRegisterMockCommand );
		this.guest.addTransition( this.logAsUser, this.user );
		this.guest.addTransition( this.logout, this.anonymous );

		this.administrator.addEnterCommand( GetAdminPrivilegesMockCommand );
		this.administrator.addExitCommand( RemoveAdminPrivilegesMockCommand );

		this._stateMachine.addResetMessageType( [ this.logout ] );
    }
	
	function _fireMessage( messageType : MessageType ) : Void
	{
		this._controller.handleMessage( messageType );
	}

    @After
    public function tearDown() : Void
    {
        this._stateMachine = null;
    }
	
	@Test( "Test 'getStates' behavior" )
    public function testGetStates() : Void
    {
		Assert.equals( 4, this._stateMachine.getStates().length, "" );
	}
	
	@Test( "Test 'addResetMessageType' behavior" )
	public function testAddResetMessageType() : Void
	{
		Assert.isTrue( this._stateMachine.isResetMessageType( this.logout ), "'logout' should be reset messageType" );

		this._fireMessage( this.logAsUser );
		Assert.equals( this.user, this._controller.getCurrentState(), "'user' should be current state" );

		this._fireMessage( this.logout );
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );
	}
	
	@Test( "Test StateController" )
	public function testStateController() : Void
	{
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );

		var dispatcher = new Dispatcher<StateController>();
		dispatcher.addListener( this._controller );

		dispatcher.dispatch( this.logAsUser );
		Assert.equals( this.user, this._controller.getCurrentState(), "'user' should be current state" );
	}
	
	@Test( "Test messages trigger state change with injection" )
	public function testMessagesTriggerStateChangeWithInjection() : Void
	{
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );

		this._fireMessage( this.logAsUser );
		Assert.equals( this.user, this._controller.getCurrentState(), "'user' should be current state" );

		this._fireMessage( this.logAsAdministrator );
		Assert.equals( this.administrator, this._controller.getCurrentState(), "'administrator' should be current state" );

		this._fireMessage( this.logout );
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );

		var logs : Array<String> = [ "PUI","DWM","SUA","GAP","RAP","DAC","DAB" ];
		Assert.deepEquals( logs, this._commandLogger.getLogs(), "logs should be the same" );
	}
	
	@Test( "Test messages are ignored when there is no transition" )
	public function testMessagesAreIgnoredWhenThereIsNoTransition() : Void
	{
		this._fireMessage( this.logAsAdministrator );
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );
	}

	@Async( "Test asynchronous transitions with handlers" )
	public function testAsyncTransitionsWithHandlers() : Void
	{
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );
		this._transitionListener = new MockTransitionListener( this._controller );

		this.anonymous.addExitHandler( this._transitionListener.testExitCallback );
		this.guest.addEnterHandler( this._transitionListener.testEnterCallback );
		
		this._fireMessage( this.logAsGuest );

		// Guest change is asynchronous, so at this time it stills in 'anonymous' state
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );
		
		Timer.delay( MethodRunner.asyncHandler( this._onCompleteTestAsyncTransitionsWithHandlers ), 200 );
	}
	
	function _onCompleteTestAsyncTransitionsWithHandlers() : Void
	{
		Assert.equals( this.anonymous, this._transitionListener.exitState, "'anonymous' should be exit state" );
		Assert.equals( this.guest, this._transitionListener.enterState, "'guest' should be enter state" );
	}
	
	@Test( "Test state change with payload" )
	public function testStateChangeWithPayload() : Void
	{
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );
		
		this.anonymous.addExitCommand( MockCommandWithRequest );
		var mockStringRequest = new Request( 
		[
			new ExecutionPayload( new MockCaseParser() ).withClassName( "hex.data.IParser<String>" ), 
			new ExecutionPayload( "cwr", String )
		] );

		this._controller.handleMessage( this.logAsUser, mockStringRequest );

		Assert.equals( this.user, this._controller.getCurrentState(), "'user' should be current state" );
		var logs : Array<String> = [ "CWR","PUI","DWM" ];
		Assert.deepEquals( logs, this._commandLogger.getLogs(), "logs should be the same" );

		this.user.addExitCommand( AnotherMockCommandWithRequest );

		mockStringRequest = new Request( [new ExecutionPayload( new MockCaseParser() ).withClassName( "hex.data.IParser<String>" ), new ExecutionPayload( "cwa", String ) ] );
		this._controller.handleMessage( this.logAsAdministrator, mockStringRequest );

		var logs : Array<String> = [ "CWR","PUI","DWM","SUA","CWA","GAP" ];
		Assert.deepEquals( logs, this._commandLogger.getLogs(), "logs should be the same" );
	}
	
	@Test( "Test state change with module callback" )
	public function testStateChangeWithModuleCallback() : Void
	{
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );

		var moduleA = new MockModuleWithStringParameter( "A" );
		var moduleB = new MockModuleWithStringParameter( "B" );

		this.anonymous.addExitCommand( MockCommandWithStringInjection, moduleA );
		this.anonymous.addExitCommand( MockCommandWithStringInjection, moduleB );

		this._fireMessage( this.logAsUser );

		Assert.equals( "A", moduleA.getName(), "module's name should be 'A'" );
		Assert.equals( "B", moduleB.getName(), "module's name should be 'B'" );
	}
	
	@Test( "Test state change with module guards" )
	public function testStateChangeWithGuards() : Void
	{
		Assert.equals( this.anonymous, this._controller.getCurrentState(), "'anonymous' should be current state" );
		
		this.user.addExitCommand( PrepareUserInfosMockCommand ).withGuard( function approve() : Bool { return false; } );
		this.user.addEnterCommand( PrepareUserInfosMockCommand ).withGuard( function approve() : Bool { return false; } );
		
		this._fireMessage( this.logAsUser );
		
		Assert.equals( this.user, this._controller.getCurrentState(), "'user' should be current state" );
	}
}

private class MockTransitionListener
{
	var _controller	: StateController;
	
	public var exitState 	: State;
	public var enterState 	: State;
	
	public function new( controller : StateController )
	{
		this._controller = controller;
	}
	
	public function testExitCallback( state : State ) : Void
	{
		this.exitState = this._controller.getCurrentState();
	}

	public function testEnterCallback( state : State ) : Void
	{
		this.enterState = this._controller.getCurrentState();
	}
}