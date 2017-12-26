register_command('run',associative_array(
  'description':'Run MethodScript code from chat.',
  'usage':'/run <code>',
  'noPermMsg':colorize('Unk&cno&fwn command.'),
  'permission':'commandhelper.interpreter',
  'example':'/run set_ploc(player(\'verg\'),array(0,100,0,\'world\'));',
  'executor':closure(@alias,@sender,@args){
    @admins = yml_decode(read('../admins.yml'))[admins];
    if(array_contains_ic(@admins,@sender) || @sender === '~console'){
      @returns = eval(array_implode(@args));
      if(@returns !== ''){
        tmsg(@sender,@returns);
      }
    }else{
      tmsg(@sender,colorize('Unk&cno&fwn command.'));
    }
  }
));

register_command('settitle',associative_array(
  'description':'Set the title of the item in your hand using color codes.',
  'usage':'/settitle <your color coded title>',
  'permission':'angelsreach.tools.title',
  'executor':closure(@alias,@sender,@args){
    #If the player's hand isn't empty
    if(!is_null(pinv(@sender,null))){
      #If there are no arguements
      if(!array_size(@args),return(false))
      #Get the item's meta data
      @itemmeta = get_itemmeta(@sender,null);
      #Ensure the item has metadata
      if(is_null(@itemmeta),@itemmeta = associative_array());
      #Set 'display' in the item meta to your custom title. &r resets the default italics.
      if(extension_exists('chplaceholderapi')){
        if(reg_count('%',array_implode(@args)) > 0){
          @itemmeta['display'] = set_placeholders(array_implode(@args));
        }else{
          @itemmeta['display'] = colorize(array_implode(@args));
        }
      }else{
        if(reg_count('%',array_implode(@args)) > 0){
          _are('CHPlaceholderAPI extension is required to use placeholders.');
          _arm('Grab it here: https://letsbuild.net/jenkins/');
        }
        @itemmeta['display'] = colorize(array_implode(@args));
      }
      #Apply updated item meta to the item in hand
      set_itemmeta(@sender,null,@itemmeta);
      _arm('Item Title Set');
    }else{
      msg('Nothing to Title!');
    }
  }
));

register_command('setlore',associative_array(
  'description':'Set the lore of the item in your hand using color codes.',
  'usage':'/setlore <line> <your color coded title>',
  'permission':'angelsreach.tools.lore',
  'executor':closure(@alias,@sender,@args){
    #If there are no arguements
    if(array_size(@args) < 2,return(false))
    #If the player didn't specify a line number
    if(!is_numeric(@args[0]),return(false));
    #Get the index we're setting
    @slot = @args[0];
    #If the player's hand isn't empty
    if(!is_null(pinv(@sender,null))){
      #Get the item's meta data
      @itemmeta = get_itemmeta(@sender,null);
      #Ensure the item has metadata
      if(is_null(@itemmeta),@itemmeta = associative_array());
      #Ensure the metadata contains lore
      if(!array_index_exists(@itemmeta,'lore'),@itemmeta['lore'] = array());
      if(is_null(@itemmeta['lore']), @itemmeta['lore'] = array());
      #If the size of 'lore' isn't at least big enough for the index we want
      if(array_size(@itemmeta['lore']) < @slot - 1){
        foreach(cslice(array_size(@itemmeta['lore']),@slot - 1),@i){
          array_push(@itemmeta['lore'],'');
        }
      }
      #set the lore in the slot we want
      if(extension_exists('chplaceholderapi')){
        if(reg_count('%',array_implode(@args)) > 0){
          @itemmeta['lore'][@slot - 1] = set_placeholders(array_implode(@args));
        }else{
          @itemmeta['lore'][@slot - 1] = colorize(array_implode(@args));
        }
      }else{
        if(reg_count('%',array_implode(@args)) > 0){
          _are('CHPlaceholderAPI extension is required to use placeholders.');
          _arm('Grab it here: https://letsbuild.net/jenkins/');
        }
        @itemmeta['lore'][@slot - 1] = colorize(array_implode(@args));
      }
      #Apply updated item meta to the item in hand
      set_itemmeta(@sender,null,@itemmeta);
      msg('Item Lore Set');
    }else{
      msg('Nothing to Title!');
    }
  }
));

register_command('aenchant',associative_array(
  'description':'Enchant the item in your hand.',
  'usage':'/aenchant <enchantment> <level>',
  'permission':'angelsreach.tools.enchant',
  'tabcompleter':closure(@alias,@sender,@args){
    return(enchantment_list());
  },
  'executor':closure(@alias,@sender,@args){
    #If the player's hand isn't empty
    if(!is_null(pinv(@sender,null))){
      #If there are not two arguements
      if(array_size(@args) !== 2,return(false))
      try(
        enchant_inv_unsafe(@sender,null,@args[0],@args[1]);
      ,
        _are('Enchant or level invalid.');
        die();
      )
      _arm('Item enchanted!');
    }else{
      _are('Nothing to Enchant!');
    }
  }
));
