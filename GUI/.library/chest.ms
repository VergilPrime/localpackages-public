if(!extension_exists('chvirtualchests')){
  sys_out('CommandHelper ChestGUIs require the CHVirtualChests Extension.');
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

register_command('testchest',associative_array(
  'executor':closure(@alias,@sender,@args){
    @exampledata = yml_decode(read('../example_chest.yml'))['ChestGUIs']['BasicCommands'];
    @id = to_lower('BasicCommands'); #### Replace when I make this bitch actually dynamic.
    export("angelsreach.guichest.@id",associative_array());
    @actiondata = import("angelsreach.guichest.@id");
    @size = @exampledata['Size'];
    @title = @exampledata['Title'];
    @chest = associative_array();
    @chest['id'] = @id;
    @chest['size'] = @size;
    @chest['title'] = _placeholders(@sender,@title);
    foreach(@exampledata['Contents'],@row,@items){
      if(!array_index_exists(@actiondata,@row),@actiondata[@row] = associative_array());
      foreach(@items,@column,@item){
        if(!array_index_exists(@actiondata[@row],@column),@actiondata[@row][@column] = associative_array());
        #@item['type'] = data_values(@item['name']); ### Maybe remove after 1.13
        if(array_index_exists(@item,'enchants')){
          foreach(@item['enchants'],@enchantobject){
            @enchantobject['etype'] = to_upper(@enchantobject['etype']);
          }
        }
        #### Metageddon
        if(array_index_exists(@item,'meta')){
          foreach(@item['meta'],@metaitem){
            if(is_string(@metaitem)){
              @metaitem = _placeholders(@sender,@metaitem);
            }else if(is_array(@metaitem)){
              foreach(@metaitem,@metaitemitem){
                if(is_string(@metaitemitem)){
                  @metaitemitem = _placeholders(@sender,@metaitemitem);
                }else if(is_array(@metaitemitem)){
                  foreach(@metaitemitem,@metaitemitemitem){
                    if(is_string(@metaitemitemitem)){
                      @metaitemitemitem = _placeholders(@sender,@metaitemitemitem);
                    }
                  }
                }
              }
            }
          }
        }
        #### End Metageddon
        # I hate with all of my hate
        @chestslot = @row * 9 + @column;
        if(array_index_exists(@item,'Command')){
          @actiondata[@chestslot]['command'] = @item['Command'];
          array_remove(@item,'Command');
        }
        if(array_index_exists(@item,'Message')){
          @actiondata[@chestslot]['message'] = @item['Message'];
          array_remove(@item,'Message');
        }
        if(array_index_exists(@item,'Tellraw')){
          @actiondata[@chestslot]['tellraw'] = @item['Tellraw'];
          array_remove(@item,'Tellraw');
        }
        @chest[@chestslot] = @item;
      }
    }
    create_virtualchest(@chest);
    popen_virtualchest(@sender,@id);

    @icbind = bind('inventory_click',null,array('player':@sender,'slottype':'CONTAINER'),@e,@id,@sender){
      cancel();
      @actiondata = import("angelsreach.guichest.@id");
      @slot = @e['slot'];
      if(array_index_exists(@actiondata,@slot)){
        if(array_index_exists(@actiondata[@slot],'command')){
          runas(@sender,@actiondata[@slot]['command']);
          close_pinv(@sender);
        }
        if(array_index_exists(@actiondata[@slot],'message')){
          tmsg(@sender,_placeholders(@sender,@actiondata[@slot]['message']));
          close_pinv(@sender);
        }
        if(array_index_exists(@actiondata[@slot],'tellraw')){
          runas('~console','/tellraw '.@sender.' '._placeholders(@sender,@actiondata[@slot]['tellraw']));
          close_pinv(@sender);
        }
      }
    } ### End of inventory click bind
    bind('virtualchest_closed',null,null,@e,@id,@sender,@icbind){
      if(@e['chest']['id'] === @id && @e['player'] === @sender){
        unbind(@icbind);
        unbind();
      }
    }
  } ### End of exector closure
));
