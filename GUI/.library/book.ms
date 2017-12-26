if(!extension_exists('chnaughty')){
  sys_out('CommandHelper open_book requires the CHNaughty Extension.');
  sys_out('Visit https://letsbuild.net/jenkins/ to see extensions.');
  die();
};

proc('_placeholders',@player,@text){
  if(extension_exists('chplaceholderapi')){
    return(set_placeholders(@player,@text));
  }else{
    return(colorize(@text));
  }
}

register_command('testbook',associative_array(
  'executor':closure(@alias,@sender,@args){
    @exampledata = json_decode(yml_decode(read('../example_book.yml'))['BookGUIs']['BasicCommands']);
    if(array_index_exists(@exampledata,'pages'),@pages = @exampledata['pages'],@pages = @exampledata)
    open_book(@sender,@pages);
  } ### End of exector closure
));
