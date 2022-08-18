//
//  SHLiveCourseLivingEraserSetView.m
//  TangCe
//
//  Created by tangfeng on 2022/7/29.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import "SHLiveCourseLivingEraserSetView.h"
#define ColorFromRGB(r,g,b,A) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:A]

@interface SHLiveCourseLivingEraserSetViewCell:UICollectionViewCell
@property (nonatomic , strong) UILabel *sizeLabel;
@property (nonatomic , strong) UIView  *backView;
@property (nonatomic , strong) UIView  *sizeView;
@end
@implementation SHLiveCourseLivingEraserSetViewCell
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
@interface SHLiveCourseLivingEraserSetView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView         *collectionView;
@property (nonatomic , strong) NSMutableArray           *dataSource_size;
@end

@implementation SHLiveCourseLivingEraserSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        _selectSize = self.dataSource_size[1];
        [self addSubview:self.collectionView];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource_size.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHLiveCourseLivingEraserSetViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"eraserset" forIndexPath:indexPath];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectSize = _dataSource_size[indexPath.item];
    [collectionView reloadData];
    !self.selectSize ? : self.selectBlock(self.selectSize);
}
#pragma mark - action -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    if ([touch.view isDescendantOfView:self.collectionView]) return;
    self.hidden = YES;
}
#pragma mark - lazy -
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout  *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.itemSize = CGSizeMake(36, 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.frame.size.width-228, 80, 132, 72) collectionViewLayout:flow];
        _collectionView.backgroundColor = ColorFromRGB(72, 72, 72, 1.0);
        _collectionView.layer.cornerRadius = 5;
        _collectionView.layer.masksToBounds = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(12, 12, 12, 12);
        [_collectionView registerClass:[SHLiveCourseLivingEraserSetViewCell class] forCellWithReuseIdentifier:@"eraserset"];
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource_size
{
    if (!_dataSource_size) {
        _dataSource_size = [NSMutableArray arrayWithArray:@[@"8",@"12",@"16"]];
    }
    return _dataSource_size;
}
@end
