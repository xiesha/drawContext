//
//  SHShapeLayer.m
//  TangCe
//
//  Created by tangfeng on 2022/8/12.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import "SHShapeLayer.h"
#import <UIKit/UIKit.h>

@interface SHShapeLayer ()
@property (nonatomic , strong) UIBezierPath         *bezierPath;
@property (nonatomic , strong) NSMutableArray       *points;
@property (nonatomic , strong) CAShapeLayer         *shapeLayer_sel;
@end

@implementation SHShapeLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fillColor = [UIColor clearColor].CGColor;
        self.lineCap = kCALineCapRound;
        self.lineJoin = kCALineJoinRound;
        self.eraserWidth = 12;
        [self addSublayer:self.shapeLayer_sel];
    }
    return self;
}
- (void)setPoint:(CGPoint)point IsDraw:(BOOL)isDraw
{
    if (isDraw == YES) {
        [self getRectWithPoint:point];
        [self drawContextWithPoint:point];
    }else{
        if (CGRectContainsPoint(CGRectMake(self.min_X - self.eraserWidth, self.min_Y - self.eraserWidth, self.max_X-self.min_X + self.eraserWidth*2, self.max_Y - self.min_Y + self.eraserWidth*2), point)) {
            CGRect rect = CGRectMake(point.x-self.eraserWidth, point.y-self.eraserWidth, self.eraserWidth*2, self.eraserWidth*2);
            NSInteger num = self.points.count;
            NSMutableArray *subArr = [NSMutableArray array];
            for (NSInteger i = 0; i < num; i++) {
                NSString *content = self.points[i];
                if ([content containsString:@"--"]) {
                    if (i!=0 && [self.points[i-1] containsString:@"--"]) [subArr addObject:self.points[i-1]];
                    NSArray *pointArr = [content componentsSeparatedByString:@"--"];
                    CGFloat x = [pointArr.firstObject floatValue];
                    CGFloat y = [pointArr.lastObject floatValue];
                    if (i+1 == num) {
                        [subArr addObject:content];
                    }else{
                        if (CGRectContainsPoint(rect, CGPointMake(x, y))) {
                            [subArr addObject:content];
                            if (i+1<num) {
                                NSString *nextContent = self.points[i+1];
                                if ([nextContent containsString:@"=="]) {
                                    nextContent = [nextContent stringByReplacingOccurrencesOfString:@"==" withString:@"--"];
                                    self.points[i+1] = nextContent;
                                }
                            }
                        }
                    }
                }else{
                    NSArray *pointArr = [content componentsSeparatedByString:@"=="];
                    CGFloat x = [pointArr.firstObject floatValue];
                    CGFloat y = [pointArr.lastObject floatValue];
                    if (CGRectContainsPoint(rect, CGPointMake(x, y))) {
                        [subArr addObject:content];
                        if (i+1<num) {
                            NSString *nextContent = self.points[i+1];
                            if ([nextContent containsString:@"=="]) {
                                nextContent = [nextContent stringByReplacingOccurrencesOfString:@"==" withString:@"--"];
                                self.points[i+1] = nextContent;
                            }
                        }
                    }
                }
            }
            if (subArr.count == 0) return;
            [self.points removeObjectsInArray:subArr];
            if (self.points.count == 0) {
                [self removeFromSuperlayer];
                return;
            }
            [self.bezierPath removeAllPoints];
            self.min_X = 100000;
            self.min_Y = 100000;
            self.max_X = 0;
            self.max_Y = 0;
            NSInteger count = self.points.count;
            for (NSInteger i = 0; i < count; i++) {
                NSString *content = self.points[i];
                if ([content containsString:@"--"]) {
                    NSArray *pointArr = [content componentsSeparatedByString:@"--"];
                    CGFloat x = [pointArr.firstObject floatValue];
                    CGFloat y = [pointArr.lastObject floatValue];
                    [self getRectWithPoint:CGPointMake(x, y)];
                    [self.bezierPath moveToPoint:CGPointMake(x, y)];
                }else{
                    NSArray *pointArr = [content componentsSeparatedByString:@"=="];
                    CGFloat x = [pointArr.firstObject floatValue];
                    CGFloat y = [pointArr.lastObject floatValue];
                    [self getRectWithPoint:CGPointMake(x, y)];
                    [self.bezierPath addLineToPoint:CGPointMake(x, y)];
                }
            }
            self.path = self.bezierPath.CGPath;
        }
    }
}
- (void)selectLayerState:(BOOL)yes
{
    if (yes) {
        [CATransaction setDisableActions:YES];
        self.shapeLayer_sel.frame = CGRectMake(self.min_X - self.lineWidth, self.min_Y - self.lineWidth, self.max_X-self.min_X + self.lineWidth*2, self.max_Y - self.min_Y + self.lineWidth*2);
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointZero];
        [bezierPath addLineToPoint:CGPointMake(0, self.shapeLayer_sel.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(self.shapeLayer_sel.frame.size.width, self.shapeLayer_sel.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(self.shapeLayer_sel.frame.size.width, 0)];
        [bezierPath closePath];
        self.shapeLayer_sel.path = bezierPath.CGPath;
        self.shapeLayer_sel.hidden = NO;
    }else{
        self.shapeLayer_sel.hidden = YES;
    }
}
- (void)moveLayerWithPoint:(CGPoint)point
{
    [CATransaction setDisableActions:YES];
    [self.bezierPath applyTransform:CGAffineTransformMakeTranslation(point.x, point.y)];
    self.path = self.bezierPath.CGPath;
    CGRect rect = self.shapeLayer_sel.frame;
    rect.origin.x +=  point.x;
    rect.origin.y +=  point.y;
    self.shapeLayer_sel.frame = rect;
    self.min_X += point.x;
    self.min_Y += point.y;
    self.max_X += point.x;
    self.max_Y += point.y;
    NSInteger count = self.points.count;
    for (NSInteger i = 0; i < count; i++) {
        NSString *content = self.points[i];
        if ([content containsString:@"--"]) {
            NSArray *pointArr = [content componentsSeparatedByString:@"--"];
            CGFloat x = [pointArr.firstObject floatValue] + point.x;
            CGFloat y = [pointArr.lastObject floatValue] + point.y;
            self.points[i] = [NSString stringWithFormat:@"%f--%f",x,y];
        }else{
            NSArray *pointArr = [content componentsSeparatedByString:@"=="];
            CGFloat x = [pointArr.firstObject floatValue] + point.x;
            CGFloat y = [pointArr.lastObject floatValue] + point.y;
            self.points[i] = [NSString stringWithFormat:@"%f==%f",x,y];
        }
    }
}
#pragma mark - lazy -
- (UIBezierPath *)bezierPath
{
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
    }
    return _bezierPath;
}
- (NSMutableArray *)points
{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}
- (CAShapeLayer *)shapeLayer_sel
{
    if (!_shapeLayer_sel) {
        _shapeLayer_sel = [CAShapeLayer layer];
        _shapeLayer_sel.frame = CGRectMake(0, 0, 1, 1);
        _shapeLayer_sel.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer_sel.lineCap = kCALineCapRound;
        _shapeLayer_sel.lineJoin = kCALineJoinRound;
        _shapeLayer_sel.lineWidth = 0.5;
        _shapeLayer_sel.strokeColor = UIColor.whiteColor.CGColor;
        _shapeLayer_sel.lineDashPattern = @[@3,@3,@3,@3];
        _shapeLayer_sel.hidden = YES;
    }
    return _shapeLayer_sel;
}
#pragma mark - customMethods -
- (void)getRectWithPoint:(CGPoint)point
{
    if (self.points.count == 0) {
        self.min_X = point.x;
        self.min_Y = point.y;
        self.max_X = point.x;
        self.max_Y = point.y;
    }else{
        if (point.x < self.min_X) {
            self.min_X = point.x;
        }
        if (point.y < self.min_Y) {
            self.min_Y = point.y;
        }
        if (point.x > self.max_X) {
            self.max_X = point.x;
        }
        if (point.y > self.max_Y) {
            self.max_Y = point.y;
        }
    }
}
- (void)drawContextWithPoint:(CGPoint)point
{
    if (self.points.count == 0) {
        [self.bezierPath moveToPoint:point];
        [self.points addObject:[NSString stringWithFormat:@"%f--%f",point.x,point.y]];
    }else{
        [self.bezierPath addLineToPoint:point];
        [self.points addObject:[NSString stringWithFormat:@"%f==%f",point.x,point.y]];
    }
    self.path = self.bezierPath.CGPath;
}
@end
