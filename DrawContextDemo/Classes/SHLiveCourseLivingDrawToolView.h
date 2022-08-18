//
//  SHLiveCourseLivingDrawToolView.h
//  TangCe
//
//  Created by tangfeng on 2022/7/26.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DrawToolBlock)(NSString * _Nonnull type);
NS_ASSUME_NONNULL_BEGIN

@interface SHLiveCourseLivingDrawToolView : UIView
@property (nonatomic , copy) DrawToolBlock          toolBlock;
@property (nonatomic , assign) NSInteger            drawSelectIndex;//工具选中下标
@end

NS_ASSUME_NONNULL_END
