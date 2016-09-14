package hex.state.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandWithStringInjection extends BasicCommand
{
	@Inject
	public var module : IModule;

	@Inject
	public var name : String;
	
	public function execute( ?request : Request ) : Void 
	{
		var module : MockModuleWithStringParameter = cast this.module;
		module.setName( name );
	}
}