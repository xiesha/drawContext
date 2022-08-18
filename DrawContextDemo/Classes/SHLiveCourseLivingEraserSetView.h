//
//  SHLiveCourseLivingEraserSetView.h
//  TangCe
//
//  Created by tangfeng on 2022/7/29.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EraserSelectBlock)(NSString * _Nonnull selectSize);
NS_ASSUME_NONNULL_BEGIN

@interface SHLiveCourseLivingEraserSetView : UIView
/**当前尺寸*/
@property (nonatomic , copy) NSString               *selectSize;
/**选中回调*/
@property (nonatomic , copy) EraserSelectBlock      selectBlock;
@end

NS_ASSUME_NONNULL_END
