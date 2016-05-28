# hexState
[![TravisCI Build Status](https://travis-ci.org/DoclerLabs/hexState.svg?branch=master)](https://travis-ci.org/DoclerLabs/hexState)
State machine written in Haxe

*Find more information about hexMachina on [hexmachina.org](http://hexmachina.org/)*

## Dependencies

* [hexCore](https://github.com/DoclerLabs/hexCore)
* [hexAnnotation](https://github.com/DoclerLabs/hexAnnotation)
* [hexInject](https://github.com/DoclerLabs/hexInject)
* [hexMVC](https://github.com/DoclerLabs/hexMVC)


## Simple example
```haxe
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
```
