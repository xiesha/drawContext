//
//  SHShapeLayer.h
//  TangCe
//
//  Created by tangfeng on 2022/8/12.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHShapeLayer : CAShapeLayer
@property (nonatomic , assign) CGFloat  min_X;
@property (nonatomic , assign) CGFloat  min_Y;
@property (nonatomic , assign) CGFloat  max_X;
@property (nonatomic , assign) CGFloat  max_Y;
@property (nonatomic , assign) CGFloat  eraserWidth;
- (void)setPoint:(CGPoint)point IsDraw:(BOOL)isDraw;
- (void)selectLayerState:(BOOL)yes;
- (void)moveLayerWithPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
