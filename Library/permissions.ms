proc(_has_numbered_permission,@player,@permission,@max,@min){
  if(@min === '', @min = 0)
  for(@i = @max, @i > @min, @i--){
    if(has_permission(@permission.'.'.@i)){
      return(@i);
    }
  }
  return(0);
}
