//
//  WavyView.h
//  wavyLine
//
//  Created by James Sadlier on 11/05/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WavyView : UIView
{
    UIBezierPath *linePath;
    CAShapeLayer *lineLayer;
    UIColor *lineColor;
    double lineWidth;
    NSMutableArray <__kindof NSValue*> *controlPoints;
    int controlPointCount;
    int controlPointIndex;
}

- (instancetype)initWithFrame:(CGRect)frame inColor:(UIColor*)color;

@end
