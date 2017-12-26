try(unregister_placeholder_hook('shadowcraft'))

register_placeholder_hook('shadowcraft', closure(@player, @placeholder){
  switch(@placeholder){
    case countdown:
      @hours = 9;
      @onehour = 1000 * 60 * 60;
      @oneday = @onehour * 24;
      @margin = @onehour * @hours;
      @timeaftermargin = time() + @oneday - @margin;
      @totaldays = floor(@timeaftermargin / @oneday) + 1;
      @reset_time = @totaldays * @oneday + @margin - @oneday;
      @remainder = @reset_time - time();
      @hourstillreset = floor(@remainder / @onehour);
      @remainder = @remainder - @hourstillreset * @onehour;
      @minutestillreset = floor(@remainder / (1000 * 60));
      @remainder = @remainder - @minutestillreset * 1000 * 60;
      @secondstillreset = floor(@remainder / 1000);
      if(length(@hourstillreset) === 1){
        @displayhours = "0@hourstillreset";
      }else{
        @displayhours = "@hourstillreset";
      }
      if(length(@minutestillreset) === 1){
        @displayminutes = "0@minutestillreset";
      }else{
        @displayminutes = "@minutestillreset";
      }
      if(length(@secondstillreset) === 1){
        @displayseconds = "0@secondstillreset";
      }else{
        @displayseconds = "@secondstillreset";
      }
      if(@hourstillreset > 0){
        return("&b@displayhours&7:&b@displayminutes&7:&b@displayseconds");
      }else{
        return("&c@displayhours&7:&c@displayminutes&7:&c@displayseconds");
      }
  }
});

try(unregister_command('nextreboot'));

register_command('nextreboot',associative_array(
  'description':'Get the next scheduled reboot time.',
  'aliases':array('nrs','nrb'),
  'executor':closure(@alias,@sender,@args){
    tmsg(@sender,set_placeholders(@sender,'The server will reboot in: %shadowcraft_countdown%'));
  }
))
