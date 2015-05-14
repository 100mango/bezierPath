//
//  ViewController.m
//  bezierPath
//
//  Created by Mango on 15/5/13.
//  Copyright (c) 2015年 Mango. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Macro.h"
#import "UIBezierPath+LxThroughPointsBezier.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *pointArray;
@property (nonatomic,strong) NSMutableArray *pointLayers;
@property (nonatomic,strong) CAShapeLayer *bezierLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pointArray = [NSMutableArray array];
    self.pointLayers = [NSMutableArray array];
    self.bezierLayer = [CAShapeLayer layer];
    
    [self.view.layer addSublayer:self.bezierLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self.view];
    
    [self drawPoint:point];
    [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
}


#pragma mark - action
- (IBAction)doneAddPoint:(id)sender
{
    [self drawBezierCurveInShapeLayer:self.bezierLayer withPoints:self.pointArray lineColor:[UIColor blackColor] lineWidth:2 lineDashPattern:nil];
    self.bezierLayer.hidden = NO;
    
    //draw line animation
    CABasicAnimation *draw = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    draw.duration = 4;
    draw.fromValue = @0;
    draw.toValue = @1;
    [self.bezierLayer addAnimation:draw forKey:nil];
}

- (IBAction)resetPoint:(id)sender
{
    //remove point
    [self.pointArray removeAllObjects];
    //remove point layers
    [self.pointLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.pointLayers removeAllObjects];
    
    self.bezierLayer.hidden = YES;
}
#pragma mark - draw

- (void)drawPoint:(CGPoint)point
{
    CALayer * pointLayer = [CALayer layer];
    pointLayer.bounds = CGRectMake(0, 0, 6, 6);
    pointLayer.position = point;
    pointLayer.cornerRadius = 3;
    pointLayer.backgroundColor = [UIColor blueColor].CGColor;
    pointLayer.opaque = YES;
    [self.view.layer addSublayer:pointLayer];
    
    [self.pointLayers addObject:pointLayer];
}

- (void)drawBezierCurveInShapeLayer:(CAShapeLayer*)shapeLayer withPoints:(NSArray*)points lineColor:(UIColor*)color lineWidth:(CGFloat)lineWidth lineDashPattern:(NSArray*)dashPattern
{
    if (points.count < 2) return;
    
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineDashPattern = dashPattern;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addBezierThroughPoints:points];
    
    shapeLayer.path = [bezierPath CGPath];
}



@end
