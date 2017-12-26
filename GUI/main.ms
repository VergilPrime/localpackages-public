include('.library/config.ms');
include('.library/book.ms');

register_command('shadowguide',associative_array(
  'executor':closure(@alias,@sender,@args){
    @unreadable = yml_decode(read('../example_book.yml'))['BookGUIs']['ShadowGuide']
    open_book(@sender,@unreadable)
  }
))
