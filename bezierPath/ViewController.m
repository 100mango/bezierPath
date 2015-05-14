//
//  ViewController.m
//  bezierPath
//
//  Created by Mango on 15/5/13.
//  Copyright (c) 2015年 Mango. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Macro.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *pointArray;
@property (nonatomic,strong) NSMutableArray *pointLayers;
@property (nonatomic,strong) CAShapeLayer *bezierPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pointArray = [NSMutableArray array];
    self.pointLayers = [NSMutableArray array];
    self.bezierPath = [CAShapeLayer layer];
    [self.view.layer addSublayer:self.bezierPath];
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
    [self drawBezierCurveInShapeLayer:self.bezierPath withPoints:self.pointArray lineColor:[UIColor blackColor] lineWidth:2];
    self.bezierPath.hidden = NO;
}

- (IBAction)resetPoint:(id)sender
{
    [self.pointArray removeAllObjects];
    /*
    [self.pointLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(CALayer*)obj removeFromSuperlayer];
    }];*/
    [self.pointLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.pointLayers removeAllObjects];
    
    self.bezierPath.hidden = YES;
}
#pragma mark - draw

- (void)drawPoint:(CGPoint)point
{
    CALayer * pointLayer = [CALayer layer];
    pointLayer.bounds = CGRectMake(0, 0, 6, 6);
    pointLayer.position = point;
    pointLayer.backgroundColor = [UIColor magentaColor].CGColor;
    pointLayer.opaque = YES;
    [self.view.layer addSublayer:pointLayer];
    
    [self.pointLayers addObject:pointLayer];
}

- (void)drawBezierCurveInShapeLayer:(CAShapeLayer*)shapeLayer withPoints:(NSArray*)points lineColor:(UIColor*)color lineWidth:(CGFloat)lineWidth {
    if (points.count < 2) return;
    
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    
    CGPoint CP1;
    CGPoint CP2;
    
    // LINE
    UIBezierPath *line = [UIBezierPath bezierPath];
    
    CGPoint p0;
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    CGFloat tensionBezier1 = 0.3;
    CGFloat tensionBezier2 = 0.3;
    
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    
    [line moveToPoint:[[points objectAtIndex:0] CGPointValue]];
    
    for (int i = 0; i < points.count - 1; i++) {
        p1 = [[points objectAtIndex:i] CGPointValue];
        p2 = [[points objectAtIndex:i + 1] CGPointValue];
        
        const CGFloat maxTension = 1.0f / 3.0f;
        tensionBezier1 = maxTension;
        tensionBezier2 = maxTension;
        
        if (i > 0) { // Exception for first line because there is no previous point
            p0 = previousPoint1;
            if (p2.y - p1.y == p1.y - p0.y) tensionBezier1 = 0;
        } else {
            tensionBezier1 = 0;
            p0 = p1;
        }
        
        if (i < points.count - 2) { // Exception for last line because there is no next point
            p3 = [[points objectAtIndex:i + 2] CGPointValue];
            if (p3.y - p2.y == p2.y - p1.y) tensionBezier2 = 0;
        } else {
            p3 = p2;
            tensionBezier2 = 0;
        }
        
        // The tension should never exceed 0.3
        if (tensionBezier1 > maxTension) tensionBezier1 = maxTension;
        if (tensionBezier2 > maxTension) tensionBezier2 = maxTension;
        
        // First control point
        CP1 = CGPointMake(p1.x + (p2.x - p1.x)/3,
                          p1.y - (p1.y - p2.y)/3 - (p0.y - p1.y)*tensionBezier1);
        
        // Second control point
        CP2 = CGPointMake(p1.x + 2*(p2.x - p1.x)/3,
                          (p1.y - 2*(p1.y - p2.y)/3) + (p2.y - p3.y)*tensionBezier2);
        
        
        [line addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
        
        previousPoint1 = p1;
        previousPoint2 = p2;
    }
    
    shapeLayer.path = [line CGPath];
}



@end
