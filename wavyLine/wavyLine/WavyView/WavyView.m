//
//  WavyView.m
//  wavyLine
//
//  Created by James Sadlier on 11/05/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import "WavyView.h"

@implementation WavyView

- (instancetype)initWithFrame:(CGRect)frame inColor:(UIColor*)color
{
    if( self = [super initWithFrame:frame] )
    {
        lineColor = color;
        lineWidth = 2;
        controlPointCount = 3;
        [self makeLine];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)makeLine
{
    lineLayer = [CAShapeLayer layer];
    [lineLayer setFrame:self.bounds];
    [lineLayer setBackgroundColor:[UIColor clearColor].CGColor];
    
    linePath = [UIBezierPath bezierPath];
    double bufferMod = 0.05;
    [linePath moveToPoint:(CGPoint){self.frame.size.width*0.5,self.frame.size.height * bufferMod}];
    [linePath addLineToPoint:(CGPoint){self.frame.size.width*0.5,self.frame.size.height * (1.0 - bufferMod)}];
    [linePath setLineWidth:lineWidth];

    [lineLayer setStrokeColor:lineColor.CGColor];
    [lineLayer setPath:linePath.CGPath];
    [lineLayer setFillColor:[UIColor clearColor].CGColor];
    
    [self.layer addSublayer:lineLayer];
    
    controlPoints = [[NSMutableArray alloc] init];
    controlPointCount = 2;
    for( int i = 0; i < controlPointCount; i++ )
    {
        [controlPoints addObject:[NSValue valueWithCGPoint:(CGPoint){0,0}]];
    }
    controlPointIndex = 0;
}

- (void)redrawLine
{
    double bufferMod = 0.05;
    
    [linePath removeAllPoints];
    
    [linePath moveToPoint:(CGPoint){self.frame.size.width*0.5,self.frame.size.height * bufferMod}];
    [linePath addCurveToPoint:(CGPoint){self.frame.size.width*0.5,self.frame.size.height * (1.0 - bufferMod)} controlPoint1:[[controlPoints firstObject] CGPointValue] controlPoint2:[[controlPoints lastObject] CGPointValue]];
    
    [lineLayer setPath:linePath.CGPath];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
        NSLog(@"event %@",event);
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if( [self pointInside:point withEvent:event] )
    {
        if( event.type == UIEventTypeTouches || event.type == UIEventTypeMotion )
        {
            if( controlPointIndex >= controlPointCount )
            {
                controlPointIndex = 0;
            }
            [controlPoints replaceObjectAtIndex:controlPointIndex withObject:[NSValue valueWithCGPoint:point]];
            [self redrawLine];
            controlPointIndex++;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if( [self pointInside:point withEvent:event] )
    {
        if( event.type == UIEventTypeTouches || event.type == UIEventTypeMotion )
        {
            if( controlPointIndex >= controlPointCount )
            {
                controlPointIndex = 0;
            }
            [controlPoints replaceObjectAtIndex:controlPointIndex withObject:[NSValue valueWithCGPoint:point]];
            [self redrawLine];
            controlPointIndex++;
        }
    }
}

@end
