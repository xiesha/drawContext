//
//  SHLiveCourseLivingDrawContextView.h
//  TangCe
//
//  Created by tangfeng on 2022/8/5.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SHLivingDrawContextTypeArrow,//箭头
    SHLivingDrawContextTypeSelectArrow,//选中箭头
    SHLivingDrawContextTypePen,//笔
    SHLivingDrawContextTypeEraser,//橡皮擦
} SHLivingDrawContextType;
NS_ASSUME_NONNULL_BEGIN

@interface SHLiveCourseLivingDrawContextView : UIScrollView
/**箭头类型*/
@property (nonatomic , assign) SHLivingDrawContextType  type;
/**选中类型下标*/
@property (nonatomic , assign) NSInteger                selectTypeIndex;
/**选中颜色*/
@property (nonatomic , strong) UIColor                  *selectColor;
/**当前尺寸*/
@property (nonatomic , copy)   NSString                 *selectSize;
- (void)deleteOfSelected;
@end

NS_ASSUME_NONNULL_END
