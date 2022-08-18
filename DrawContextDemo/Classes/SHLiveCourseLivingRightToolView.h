//
//  SHLiveCourseLivingRightToolView.h
//  TangCe
//
//  Created by tangfeng on 2022/7/18.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHLiveCourseLivingRightToolView : UIView
/**工具*/
@property (nonatomic , strong) UIButton *toolButton;
/**笔-设置*/
@property (nonatomic , strong) UIButton *penSetButton;
/**笔-颜色*/
@property (nonatomic , strong) UIView   *colorView;
@end

NS_ASSUME_NONNULL_END
