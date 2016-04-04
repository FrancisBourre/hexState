package hex.state.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;
import hex.di.IInjectorContainer;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandWithStringInjection extends BasicCommand implements IInjectorContainer
{
	@Inject
	public var module : IModule;

	@Inject
	public var name : String;
	
	override public function execute( ?request : Request ) : Void 
	{
		var module : MockModuleWithStringParameter = cast this.module;
		module.setName( name );
	}
}