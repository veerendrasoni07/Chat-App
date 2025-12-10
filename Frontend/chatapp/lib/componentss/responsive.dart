class ResponsiveClass{
  final double height;
  final double width;

  ResponsiveClass(this.height,this.width);

  bool get isSmall => 350<width;
  bool get isMedium => 350>width && width<600;
  bool get isLarge => width>600;

  double wp(double percent){
    return width*percent/100;
  }

  double hp(double percent){
    return width*percent/100;
  }

  double font(double base){
    if(isSmall) return base*0.85;
    if(isMedium) return base*1.2;
    return base;
  }


}