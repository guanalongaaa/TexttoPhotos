
# TexttoPhotos

//输入字符自动截取最后一位作为字符生成图片，可作为APP用户默认头像
//可优化最后一位为数字或空格时前置一位字符
 self.imageV.image = [self imageWithTitle:[nameStr substringFromIndex:(nameStr.length-1)] fontSize:52 imageColor:[self colorBackground:nameStr] titleColor:[UIColor whiteColor]];
