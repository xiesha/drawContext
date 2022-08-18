//
//  SHLiveCourseLivingPenSetView.h
//  TangCe
//
//  Created by tangfeng on 2022/7/28.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PenSetColorBlock)(UIColor * _Nullable color);
typedef void(^PenSetTypeBlock)(NSInteger   selectTypeIndex);
typedef void(^PenSetSizeBlock)(NSString * _Nullable selectSize);

NS_ASSUME_NONNULL_BEGIN

@interface SHLiveCourseLivingPenSetView : UIView
/**选中类型下标*/
@property (nonatomic , assign) NSInteger                selectIndex_type;
/**选中颜色*/
@property (nonatomic , strong) UIColor                  *selectColor;
/**当前尺寸*/
@property (nonatomic , copy)   NSString                 *selectSize;
@property (nonatomic , copy) PenSetColorBlock colorBlock;
@property (nonatomic , copy) PenSetTypeBlock typeBlock;
@property (nonatomic , copy) PenSetSizeBlock sizeBlock;
@end

NS_ASSUME_NONNULL_END
