include('configuration.ms')

_create_config('../../messages.yml',associative_array(
	'message format': associative_array(
		'prefix': '&3[&bA&3]&b Angel\'s Reach&3:&7 '
	),
	'error format': associative_array(
	  'prefix': '&4[&cA&4]&c Angel\'s Reach&4:&7 '
	),
	'staff message format': associative_array(
	  'prefix': '&2[&aA&2]&a Angel\'s Reach&2:&7 '
	)
))

_load_config('../../messages.yml')

proc(_arm,@message,@player,@json,@format){
	_format_message(@message,@player,'message',@json,@format)
}

proc(_are,@message,@player,@json,@format){
	_format_message(@message,@player,'error',@json,@format)
}

proc(_arsm,@message,@player,@json,@format){
	_format_message(@message,@player,'staff message',@json,@format)
}

proc(_arb,@message,@json,@format){
	foreach(all_players(),@player){
		_format_message(@message,@player,'message',@json,@format)
	}
}

proc(_arsb,@message,@json,@format){
	foreach(all_players(),@player){
		if(has_permission(@player,'angelsreach.staffbroadcast')){
			_format_message(@message,@player,'staff message',@json,@format)
		}
	}
}

proc(_format_message,@message,@player,@type,@json,@format){

	#If formatting isn't inserted here, use global message configuration
	if(@format === '', @format = import('config.messages')[@type.' format']);

	#If json isn't specified, assume it's not a json message
	if(@json === '', @json = false);

	#If player isn't specified, send message to whomever triggered this script
	if(@player === '', @player = player());

	#If Message Prefix exists
	if(array_index_exists(@format,'prefix')){
		@prefix = @format['prefix']
	}else{
		@prefix = '';
	}

	#If Message Suffix exists
	if(array_index_exists(@format,'suffix')){
		@suffix = @format[@type.' format']['suffix'];
	}else{
		@suffix = '';
	}

	#If CHPlaceholderAPI is installed
	if(extension_exists('chplaceholderapi')){
		#If at least two % exist in the message
		if(reg_count('%',@message) >= 2){
			#format the message using CHPlaceholderAPI
			@formattedmessage = set_placeholders(@player,@prefix.@message.@suffix)
		}else{
			@formattedmessage = colorize(@prefix.@message.@suffix)
		}
	}else{
		if(reg_count('%',@message) > 0){
			sys_out('CHPlaceholderAPI extension is required to use placeholders with VergilPrime\'s public packages.');
			sys_out('Grab it here: https://letsbuild.net/jenkins/');
		}
		@formattedmessage = colorize(@prefix.@message.@suffix)
	}

	#If the player is ~console or CONSOLE
	if(@player === '~console' || @player === 'CONSOLE'){
		#send the message using sys_out
		sys_out(@formattedmessage)
	}else{
		#send the message using tmsg()
		if(@json){
			runas('~console',"/tellraw @formattedmessage")
		}else{
			tmsg(@player,@formattedmessage)
		}
	}
}

proc(_title_adv,@player,@title){
	if(!array_contains(get_server_info(9), 'TitleAdvanced')){
		_are('The proceedure _title_advanced() requires the TitleAdvanced plugin'.
		' available at https://www.spigotmc.org/resources/titleadvanced-xmas-sale.1629/');
		die();
	}

	runas('~console',"/titleadvanced show @player @title")
}
