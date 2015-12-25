//
//  ViewController.m
//  chompAnimation
//
//  Created by admin on 15/8/5.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#define DEGRESS_TO_RADIUS(x) (3.1415*x/180)

@interface ViewController ()
{
    UIBezierPath *_pcmanOpenPath;
    UIBezierPath *_pcmanClosePath;
    CAShapeLayer *_chompLayer;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self animationInit];
    
    CALayer *customLayer = [CALayer layer];
    [customLayer setDelegate:self];
}

-(void)animationInit
{
    //创建路径
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    CGFloat radius = 40.0f;
    CGFloat bounds = 2*radius;
   CGPoint arcCenter = CGPointMake(radius, radius);
    _pcmanClosePath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:DEGRESS_TO_RADIUS(1) endAngle:DEGRESS_TO_RADIUS(359) clockwise:YES];
    [_pcmanClosePath addLineToPoint:arcCenter];
    [_pcmanClosePath closePath];
    _pcmanOpenPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:DEGRESS_TO_RADIUS(35) endAngle:DEGRESS_TO_RADIUS(315) clockwise:YES];
    [_pcmanOpenPath addLineToPoint:arcCenter];
    [_pcmanOpenPath closePath];
    
    _chompLayer = [CAShapeLayer layer];
    _chompLayer.fillColor = [[UIColor yellowColor]CGColor];
    _chompLayer.strokeColor = [[UIColor redColor]CGColor];
    _chompLayer.path = _pcmanClosePath.CGPath;
    _chompLayer.bounds = CGRectMake(0, 0, bounds, bounds);
    _chompLayer.position = CGPointMake(80, 100);
   
    [self.view.layer addSublayer:_chompLayer];
    SEL startAnimation = @selector(startAnimation);
    UIGestureRecognizer *gestureRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:startAnimation];
    [self.view addGestureRecognizer:gestureRecognize];
}
-(void)startAnimation
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(80, 100)];
    [path addLineToPoint:CGPointMake(300, 100)];
    [path addLineToPoint:CGPointMake(300, 600)];
    [path addLineToPoint:CGPointMake(80, 600)];
    [path addLineToPoint:CGPointMake(80,100)];
    CAKeyframeAnimation *movePath = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    movePath.path = path.CGPath;
    movePath.duration = 8.0f;
    movePath.rotationMode = kCAAnimationRotateAuto;
    //为chompLayer添加吃豆的动画
    
    CABasicAnimation *chompAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    //为sprite添加步调
    chompAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    chompAnim.duration = 0.25;
    chompAnim.autoreverses = YES;
    chompAnim.repeatCount = HUGE_VALF;
    chompAnim.fromValue = (id)_pcmanClosePath.CGPath;
    chompAnim.toValue = (id)_pcmanOpenPath.CGPath;
    [_chompLayer addAnimation:chompAnim forKey:nil];
    [_chompLayer addAnimation:movePath forKey:@"chompLayer"];
}
@end
