//
//  SHLiveCourseLivingRightToolView.m
//  TangCe
//
//  Created by tangfeng on 2022/7/18.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import "SHLiveCourseLivingRightToolView.h"

@implementation SHLiveCourseLivingRightToolView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.toolButton];//工具
        [self addSubview:self.penSetButton];//笔-设置
    }
    return self;
}
#pragma mark - lazy -
- (UIButton *)toolButton//工具
{
    if (!_toolButton) {
        _toolButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 36)];
        _toolButton.adjustsImageWhenHighlighted = NO;
        [_toolButton setImage:[UIImage imageNamed:@"livingarrow"] forState:0];
        _toolButton.layer.cornerRadius = 5;
        _toolButton.layer.masksToBounds = YES;
        [_toolButton setBackgroundColor:UIColor.blackColor];
    }
    return _toolButton;
}
- (UIButton *)penSetButton//笔-设置
{
    if (!_penSetButton) {
        _penSetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 36)];
        _penSetButton.layer.cornerRadius = 5;
        _penSetButton.layer.masksToBounds = YES;
        [_penSetButton setBackgroundColor:UIColor.blackColor];
        _penSetButton.hidden = YES;
        [_penSetButton addSubview:self.colorView];
    }
    return _penSetButton;
}
- (UIView *)colorView//笔-颜色
{
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(9, 9, 18, 18)];
        _colorView.layer.cornerRadius = 9;
        _colorView.layer.masksToBounds = YES;
        _colorView.layer.borderColor = UIColor.whiteColor.CGColor;
        _colorView.layer.borderWidth = 2;
        _colorView.userInteractionEnabled = NO;
        _colorView.backgroundColor = [UIColor colorWithRed:255/255.0 green:84/255.0 blue:101/255.0 alpha:1.0];
    }
    return _colorView;
}
@end
