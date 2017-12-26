try(unregister_placeholder_hook('angelsreach'))

register_placeholder_hook('angelsreach', closure(@player, @placeholder){
  if(is_null(@player)) {
    return("");
  }
  switch(@placeholder){
    case karmatitle:
      @karmatitle = ''
      foreach(vault_pgroup(@player),@group){
        switch(@group){
          case archangel:
            @karmatitle = '&f&lArchAngel'
          case savior:
            @karmatitle = '&3&lThe Savior'
          case hero:
            @karmatitle = '&3&lThe Hero'
          case brave:
            @karmatitle = '&3&lThe Brave'
          case cruel:
            @karmatitle = '&c&lThe Cruel'
          case terrible:
            @karmatitle = '&c&lThe Terrible'
          case destroyer:
            @karmatitle = '&c&lThe Destroyer'
          case herobrine:
            @karmatitle = '&4&lHerobrine'
        }
        if(@karmatitle === '', @karmatitle = '&7none')
        return(@karmatitle)
      }
    case location:
      @region = set_placeholders(@player, '%worldguard_region_name%');
      switch(@region){
        case angelpeaksummit:
          return('Angel Peak Summit');
        case angelpeak:
          return('Angel Peak');
        case 'thecreator\'sroom':
          return('The Creator\'s Room');
        case angelpeakpenitentiary:
          return('Angel Peak Penitentiary');
        default:
          return('Wilderness');
      }
    case world:
      @world = pworld(@player);
      switch(@world) {
      case world:
        return('Overworld')
      case world_nether:
        return('The Nether')
      case world_the_end:
        return('The End')
      case world_disposal:
        return('Disposal')
      default:
        return('Unknown')
      }

  }
});
