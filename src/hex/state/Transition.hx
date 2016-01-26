package hex.state;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class Transition
{
	var _source 		: State;
	var _target 		: State;
	var _messageType 	: MessageType;

	public function new( source : State, messageType : MessageType, target : State )
	{
		this._source			= source;
		this._target 			= target;
		this._messageType 		= messageType;
	}

	public function getSource() : State
	{
		return this._source;
	}

	public function getTarget() : State
	{
		return this._target;
	}

	public function getMessageType() : MessageType
	{
		return this._messageType;
	}
}