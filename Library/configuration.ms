proc(_create_config,@filepath,@default){
	if(file_size(@filepath.'.yml') === 0){
		try(chd_create(@filepath.'.yml'))
		chd_write(@filepath.'.yml',yml_encode(@default,true))
	}
}

/* proc(_modify_config,@element,@value,@filepath){
  @name = reg_split('/',@filepath)[-1]
	@config = import('config.'.@name)
	@config[@element] = @value
	chd_write(@filepath.'.yml',yml_encode(@config,true))
} */

proc(_load_config,@filepath){
  @name = reg_split('/',@filepath)[-1]
	export('config.'.@name,
		yml_decode(
			read(@filepath)
		)
	)
}
