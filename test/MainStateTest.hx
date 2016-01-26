package;

import hex.state.HexStateSuite;
import hex.unittest.runner.ExMachinaUnitCore;
import hex.unittest.runner.TestRunner;

#if flash
import hex.unittest.notifier.TraceNotifier;
#else
import hex.unittest.notifier.ConsoleNotifier;
#end

/**
 * ...
 * @author Francis Bourre
 */
class MainStateTest
{
	static public function main() : Void
	{
		var emu = new ExMachinaUnitCore();
        
		#if flash
		TestRunner.RENDER_DELAY = 0;
		emu.addListener( new TraceNotifier( false ) );
		#else
		emu.addListener( new ConsoleNotifier( false ) );
		#end
		
        emu.addTest( HexStateSuite );
        emu.run();
	}
}