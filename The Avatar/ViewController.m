//
//  ViewController.m
//  The Avatar
//
//  Created by love on 16/9/18.
//  Copyright © 2016年 love. All rights reserved.
//

#import "ViewController.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define centerX self.view.frame.size.width * 0.5

#define IMScreenWidth self.view.frame.size.width


//#define MYBUNDLE_NAME   @"testBundle23.bundle"
//#define MYBUNDLE_PATH   [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
//#define MYBUNDLE        [NSBundle bundleWithPath: MYBUNDLE_PATH]


@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic , strong) UITextField * nameField;

@property (nonatomic , strong) UIButton * button;

@property (nonatomic , strong) UIImageView * imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //随机背景色
    self.view.backgroundColor = [self setrandomColor];
    
    [self setUI];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setUI{
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    self.nameField.borderStyle = UITextBorderStyleLine;
    self.nameField.center = CGPointMake(self.view.frame.size.width* 0.5, self.view.frame.size.height *0.15);
//    self.nameField.textColor = [UIColor yellowColor];
    self.nameField.placeholder = @"请输入一个字";
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
    self.button.center = CGPointMake(self.view.frame.size.width * 0.5, self.nameField.center.y + 80);
    self.button.layer.cornerRadius = 5;
    self.button.layer.masksToBounds = YES;
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button.backgroundColor = [self setrandomColor];
    
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.imageV.center = CGPointMake(centerX, self.button.center.y + 150);
    self.imageV.image = [UIImage imageNamed:@"icon"];
//    //加个默认图片
//    //生成随机数  获取一个随机整数范围在：[0,20)包括0，不包括20
//    int number = arc4random() % 20;
//    self.imageV.image = [UIImage imageWithContentsOfFile:[MYBUNDLE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"Contents/Resources/图片%ld",(long)number]]];
    
    //输入框
    [self.view addSubview:self.nameField];
    //确认按钮
    [self.view addSubview:self.button];
    //图像显示
    [self.view addSubview:self.imageV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)buttonClick:(UIButton *)sender
{
    if (self.nameField.text.length == 0) {
        NSLog(@"请输入一个字");
    }else
    {
        NSString * string = self.nameField.text;
        
        //去掉最后空白字符
        NSString * nameStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"%ld",nameStr.length);
        //去掉最后空白字符
//        NSString * Str = [nameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSLog(@"%ld",Str.length);
        
        if (nameStr.length >= 1) {
            
            self.imageV.image = [self imageWithTitle:[nameStr substringFromIndex:(nameStr.length-1)] fontSize:52 imageColor:[self colorBackground:nameStr] titleColor:[UIColor whiteColor]];
        }
    }
    

    
}

//生成随机色
-(UIColor *)setrandomColor
{
    
    UIColor *color =  randomColor;
    
    return color;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameField resignFirstResponder];
}



- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize imageColor:(UIColor *)imageColor titleColor:(UIColor *)titleColor{
    //画布大小
    UIImage * iconImage = [[UIImage alloc]init];
    
    CGRect iconRect=CGRectMake(0, 0, IMScreenWidth/2, IMScreenWidth/2);
    UIGraphicsBeginImageContext(iconRect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [imageColor CGColor]);
    CGContextFillRect(context, iconRect);
    iconImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    fontSize = iconRect.size.width/10.0*6.0;
    CGSize size=iconImage.size;
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [iconImage drawAtPoint:CGPointMake(0.0,0.0)];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText=[title boundingRectWithSize:iconImage.size
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}context:nil].size;
    CGFloat width = iconImage.size.width;
    CGFloat height = iconImage.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    //绘制文字
    [title drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:titleColor,NSParagraphStyleAttributeName:paragraphStyle}];
    
    //返回绘制的新图形
    iconImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return iconImage;
}
-(UIColor *)colorBackground:(NSString *)name{
    
    UIColor * backgroundColor;
    
    NSString * nameStr = [name substringToIndex:name.length];
    const char zeroChat = *[[nameStr substringToIndex:1] cStringUsingEncoding:NSUTF8StringEncoding];
    const char lastChat = *[[nameStr substringFromIndex:(nameStr.length-1)] cStringUsingEncoding:NSUTF8StringEncoding];
    int num = (zeroChat + lastChat + nameStr.length) % 8;
    NSDictionary * dic =@{@"0":[UIColor colorWithRed:121.0/255.0 green:203.0/255.0 blue:127.0/255.0 alpha:1.0],
                          @"1":[UIColor colorWithRed:248.0/255.0 green:126.0/255.0 blue:77.0/255.0 alpha:1.0],
                          @"2":[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0],
                          @"3":[UIColor colorWithRed:175.0/255.0 green:101.0/255.0 blue:223.0/255.0 alpha:1.0],
                          @"4":[UIColor colorWithRed:247.0/255.0 green:191.0/255.0 blue:40.0/255.0 alpha:1.0],
                          @"5":[UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:204.0/255.0 alpha:1.0],
                          @"6":[UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                          @"7":[UIColor colorWithRed:105.0/255.0 green:222.0/255.0 blue:232.0/255.0 alpha:1.0]};
    
    NSString * numStr = [[NSString alloc]initWithFormat:@"%d",num];
    backgroundColor = [dic objectForKey:numStr];
    
    return backgroundColor;
    //    float zeroChat = [name substringToIndex:0];
}


@end
