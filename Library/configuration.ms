proc(_create_config,@filepath,@default){
	if(file_size(@filepath) === 0){
		try(chd_create(@filepath))
		chd_write(@filepath,yml_encode(@default,true))
	}
}

/* proc(_modify_config,@element,@value,@filepath){
  @name = reg_split('/',@filepath)[-1]
	@config = import('config.'.@name)
	@config[@element] = @value
	chd_write(@filepath.'.yml',yml_encode(@config,true))
} */

proc(_load_config,@filepath){
  @file = reg_split('/',@filepath)[-1]
  @name = reg_split('\\.',@file)[0]
	export('config.'.@name,
		yml_decode(
			read(@filepath)
		)
	)
}
