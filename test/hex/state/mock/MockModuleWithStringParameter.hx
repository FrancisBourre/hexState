package hex.state.mock;

import hex.module.Module;

/**
 * ...
 * @author Francis Bourre
 */
class MockModuleWithStringParameter extends Module
{
	private var _name : String;
	
	public function new( name : String ) 
	{
		super();
		this.getBasicInjector().mapToValue( String, name );
	}
	
	public function setName( name : String ) : Void
	{
		this._name = name;
	}

	public function getName() : String
	{
		return this._name;
	}
}