package hex.state.mock;

import hex.control.command.BasicCommand;
import hex.control.Request;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class MockCommandWithStringInjection extends BasicCommand
{
	@inject
	public var module : IModule;

	@inject
	public var name : String;
	
	override public function execute( ?request : Request ) : Void 
	{
		var module : MockModuleWithStringParameter = cast this.module;
		module.setName( name );
	}
}