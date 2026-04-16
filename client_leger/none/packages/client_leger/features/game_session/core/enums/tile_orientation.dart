enum TileOrientation {
  defaultOrientation('Default', 'default'),
  horizontal('Horizontal', 'horizontal'),
  vertical('Vertical', 'vertical'),
  up('Up', 'up'),
  down('Down', 'down'),
  left('Left', 'left'),
  right('Right', 'right'),
  upLeft('UpLeft', 'up_left'),
  upRight('UpRight', 'up_right'),
  downLeft('DownLeft', 'down_left'),
  downRight('DownRight', 'down_right'),
  upRightDown('UpRightDown', 'up_right_down'),
  upRightLeft('UpRightLeft', 'up_right_left'),
  upDownLeft('UpDownLeft', 'up_down_left'),
  downRightLeft('DownRightLeft', 'down_right_left'),
  all('All', 'all'),
  tUp('TUp', 'T_up'),
  tDown('TDown', 'T_down'),
  tLeft('TLeft', 'T_left'),
  tRight('TRight', 'T_right'),
  cross('Cross', 'cross');

  const TileOrientation(this.serverValue, this.assetSuffix);

  final String serverValue;
  final String assetSuffix;
}
