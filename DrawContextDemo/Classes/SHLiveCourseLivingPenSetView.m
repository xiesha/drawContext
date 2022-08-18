//
//  SHLiveCourseLivingPenSetView.m
//  TangCe
//
//  Created by tangfeng on 2022/7/28.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import "SHLiveCourseLivingPenSetView.h"
#define ColorFromRGB(r,g,b,A) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:A]

@interface SHLiveCourseLivingPenTypeViewCell:UICollectionViewCell
@property (nonatomic , strong) UIImageView      *typeImageView;
@end
@implementation SHLiveCourseLivingPenTypeViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 24, 24)];
        [self.contentView addSubview:_typeImageView];
    }
    return self;
}
@end
@interface SHLiveCourseLivingPenColorViewCell : UICollectionViewCell
@property (nonatomic , strong) UIView      *colorView;
@end
@implementation SHLiveCourseLivingPenColorViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(6, 6, 24, 24)];
        _colorView.layer.cornerRadius = 12;
        _colorView.layer.masksToBounds = YES;
        [self.contentView addSubview:_colorView];
    }
    return self;
}
@end
@interface SHLiveCourseLivingPenSizeViewCell:UICollectionViewCell
@property (nonatomic , strong) UILabel *sizeLabel;
@property (nonatomic , strong) UIView  *backView;
@property (nonatomic , strong) UIView  *sizeView;
@end
@implementation SHLiveCourseLivingPenSizeViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.sizeLabel];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.sizeView];
    }
    return self;
}
- (UILabel *)sizeLabel//标题
{
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 13)];
        _sizeLabel.textColor = UIColor.whiteColor;
        _sizeLabel.font = [UIFont boldSystemFontOfSize:12];
        _sizeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sizeLabel;
}
- (UIView *)backView//背景
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(4, 18, 32, 32)];
        _backView.layer.borderColor = UIColor.whiteColor.CGColor;
        _backView.layer.borderWidth = 0.5;
    }
    return _backView;
}
- (UIView *)sizeView//圆心
{
    if (!_sizeView) {
        _sizeView = [[UIView alloc] init];
        _sizeView.backgroundColor = UIColor.whiteColor;
    }
    return _sizeView;
}
@end
@interface SHLiveCourseLivingPenSetView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic , strong) UIView                   *containerView;//容器
@property (nonatomic , strong) UICollectionView         *collectionView_type;//类型
@property (nonatomic , strong) UICollectionView         *collectionView_color;//颜色
@property (nonatomic , strong) UICollectionView         *collectionView_size;//尺寸
@property (nonatomic , strong) UIView                   *lineView;//分割线
@property (nonatomic , strong) NSMutableArray           *dataSource_type;//数据源-类型
@property (nonatomic , strong) NSMutableArray           *dataSource_color;//数据源-颜色
@property (nonatomic , strong) NSMutableArray           *dataSource_size;//数据源-尺寸
@end

@implementation SHLiveCourseLivingPenSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        _selectIndex_type = 0;
        _selectColor = self.dataSource_color.firstObject;
        _selectSize = self.dataSource_size.firstObject;
        [self addSubview:self.containerView];//容器
    }
    return self;
}
#pragma mark - UICollectionViewDelegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.collectionView_type == collectionView) {//类型
        return self.dataSource_type.count;
    }else if (self.collectionView_color == collectionView){//颜色
        return self.dataSource_color.count;
    }else{                                                  //尺寸
        return self.dataSource_size.count;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView_type == collectionView) {//类型
        SHLiveCourseLivingPenTypeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PenTypeView" forIndexPath:indexPath];
        cell.typeImageView.image = [UIImage imageNamed:_dataSource_type[indexPath.item]];
        cell.contentView.backgroundColor = self.selectIndex_type == indexPath.item ? ColorFromRGB(51, 51, 51, 1.0) : UIColor.clearColor;
        return cell;
    }else if (self.collectionView_color == collectionView){//颜色
        SHLiveCourseLivingPenColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"penColor" forIndexPath:indexPath];
        if (self.selectColor == _dataSource_color[indexPath.item]) {
            cell.contentView.backgroundColor = ColorFromRGB(51, 51, 51, 1.0);
        }else{
            cell.contentView.backgroundColor = UIColor.clearColor;
        }
        cell.colorView.backgroundColor = self.dataSource_color[indexPath.item];
        return cell;
    }else{
        SHLiveCourseLivingPenSizeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PenSize" forIndexPath:indexPath];
        NSString *index = _dataSource_size[indexPath.item];
        cell.sizeLabel.text = index;
        CGFloat length = (40-index.floatValue-4)*0.5;
        cell.backView.frame = CGRectMake(length, 14+length, index.floatValue+4, index.floatValue+4);
        cell.backView.layer.cornerRadius = (index.floatValue+4)*0.5;
        cell.backView.layer.masksToBounds = YES;
        cell.sizeView.frame = CGRectMake(2, 2, index.floatValue, index.floatValue);
        cell.sizeView.layer.cornerRadius = index.floatValue*0.5;
        cell.sizeView.layer.masksToBounds = YES;
        if ([index isEqualToString:self.selectSize]) {
            cell.backView.layer.borderColor = ColorFromRGB(255, 84, 101, 1.0).CGColor;
            cell.sizeView.backgroundColor = ColorFromRGB(255, 84, 101, 1.0);
            cell.sizeLabel.textColor = ColorFromRGB(255, 84, 101, 1.0);
        }else{
            cell.backView.layer.borderColor = UIColor.whiteColor.CGColor;
            cell.sizeView.backgroundColor = UIColor.whiteColor;
            cell.sizeLabel.textColor = UIColor.whiteColor;
        }
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView_type == collectionView) {//类型
        self.selectIndex_type = indexPath.item;
        [collectionView reloadData];
        !self.typeBlock ? : self.typeBlock(self.selectIndex_type);
    }else if (self.collectionView_color == collectionView){//颜色
        self.selectColor = _dataSource_color[indexPath.item];
        [collectionView reloadData];
        !self.colorBlock ? : self.colorBlock(self.selectColor);
    }else{//尺寸
        self.selectSize = _dataSource_size[indexPath.item];
        [collectionView reloadData];
        !self.sizeBlock ? : self.sizeBlock(self.selectSize);
    }
}
#pragma mark - action -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    if ([touch.view isDescendantOfView:self.containerView]) return;
    self.hidden = YES;
}
#pragma mark - lazy -
- (UIView *)containerView//容器
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-336, 80, 240, 247)];
        _containerView.backgroundColor = ColorFromRGB(72, 72, 72, 1.0);
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.masksToBounds = YES;
        [_containerView addSubview:self.collectionView_type];//类型
        [_containerView addSubview:self.collectionView_color];//颜色
        [_containerView addSubview:self.lineView];//分割线
        [_containerView addSubview:self.collectionView_size];//尺码
    }
    return _containerView;
}
- (UICollectionView *)collectionView_type//类型
{
    if (!_collectionView_type) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 16;
        flow.itemSize = CGSizeMake(40, 40);
        _collectionView_type = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 12, self.containerView.frame.size.width-24, 48) collectionViewLayout:flow];
        _collectionView_type.backgroundColor = ColorFromRGB(62, 62, 62, 1.0);
        _collectionView_type.layer.cornerRadius = 5;
        _collectionView_type.layer.masksToBounds = YES;
        _collectionView_type.delegate = self;
        _collectionView_type.dataSource = self;
        _collectionView_type.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        [_collectionView_type registerClass:[SHLiveCourseLivingPenTypeViewCell class] forCellWithReuseIdentifier:@"PenTypeView"];
    }
    return _collectionView_type;
}
- (UICollectionView *)collectionView_color//颜色
{
    if (!_collectionView_color) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.itemSize = CGSizeMake(36, 36);
        _collectionView_color = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 80, self.containerView.frame.size.width-24, 72) collectionViewLayout:flow];
        _collectionView_color.backgroundColor = UIColor.clearColor;
        _collectionView_color.delegate = self;
        _collectionView_color.dataSource = self;
        [_collectionView_color registerClass:[SHLiveCourseLivingPenColorViewCell class] forCellWithReuseIdentifier:@"penColor"];
    }
    return _collectionView_color;
}
- (UIView *)lineView//分割线
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 164, self.containerView.frame.size.width-24, 1)];
        _lineView.backgroundColor = ColorFromRGB(51, 51, 51, 1.0);
    }
    return _lineView;
}
- (UICollectionView *)collectionView_size//尺寸
{
    if (!_collectionView_size) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.itemSize = CGSizeMake(36, 50);
        _collectionView_size = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 185, self.containerView.frame.size.width-24, 50) collectionViewLayout:flow];
        _collectionView_size.backgroundColor = UIColor.clearColor;
        _collectionView_size.delegate = self;
        _collectionView_size.dataSource = self;
        [_collectionView_size registerClass:[SHLiveCourseLivingPenSizeViewCell class] forCellWithReuseIdentifier:@"PenSize"];
    }
    return _collectionView_size;
}
- (NSMutableArray *)dataSource_type//数据源-类型
{
    if (!_dataSource_type) {
        _dataSource_type = [NSMutableArray arrayWithArray:@[@"livingcurve"]];
    }
    return _dataSource_type;
}
- (NSMutableArray *)dataSource_color//数据源-颜色
{
    if (!_dataSource_color) {
        _dataSource_color = [NSMutableArray arrayWithArray:@[ColorFromRGB(255, 84, 101, 1.0),
                                                             ColorFromRGB(255, 213, 0, 1.0),
                                                             ColorFromRGB(5, 178, 97, 1.0),
                                                             ColorFromRGB(145, 77, 0, 1.0),
                                                             UIColor.whiteColor,
                                                             ColorFromRGB(38, 38, 38, 1.0),
                                                             ColorFromRGB(255, 84, 227, 1.0),
                                                             ColorFromRGB(255, 126, 12, 1.0),
                                                             ColorFromRGB(115, 230, 0, 1.0),
                                                             ColorFromRGB(0, 128, 255, 1.0),
                                                             ColorFromRGB(81, 226, 255, 1.0),
                                                             ColorFromRGB(46, 50, 228, 1.0)]];
    }
    return _dataSource_color;
}
- (NSMutableArray *)dataSource_size//数据源-尺寸
{
    if (!_dataSource_size) {
        _dataSource_size = [NSMutableArray arrayWithArray:@[@"2",@"4",@"6",@"8",@"10",@"12"]];
    }
    return _dataSource_size;
}
@end
