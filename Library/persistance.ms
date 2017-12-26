proc('_load',@address,@default){
  if(is_null(import(@address))){
    if(@default === '', @default = associative_array())
    if(has_value(@address)){
      export(@address,get_value(@address))
    }else{
      export(@address,@default)
    }
  }
}

proc('_save',@address,@default){
  if(@default === '', @default = associative_array())
  if(!is_null(import(@address))){
    store_value(@address,import(@address))
  }else{
    store_value(@address,@default)
  }
}
