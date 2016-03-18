package hex.state.mock;

import hex.di.ISpeedInjectorContainer;
import hex.control.command.BasicCommand;
import hex.control.Request;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandWithStringInjection extends BasicCommand implements ISpeedInjectorContainer
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