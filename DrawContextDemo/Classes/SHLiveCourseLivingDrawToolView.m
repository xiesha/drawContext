//
//  SHLiveCourseLivingDrawToolView.m
//  TangCe
//
//  Created by tangfeng on 2022/7/26.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import "SHLiveCourseLivingDrawToolView.h"

@interface SHLiveCourseLivingDrawViewCell : UICollectionViewCell
@property (nonatomic , strong) UIImageView          *imageView;
@end
@implementation SHLiveCourseLivingDrawViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
        [self.contentView addSubview:_imageView];
    }
    return self;
}
@end

@interface SHLiveCourseLivingDrawToolView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView     *drawCollectionView;//工具选项列表
@property (nonatomic , copy)   NSArray              *drawDataSource;//工具选项数据源
@property (nonatomic , strong) UIView               *drawLineView;//工具分割线
@end

@implementation SHLiveCourseLivingDrawToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        _drawSelectIndex = 0;
        [self addSubview:self.drawCollectionView];//工具选项列表
        [self addSubview:self.drawLineView];//工具分割线
    }
    return self;
}
#pragma mark - UITableViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.drawDataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHLiveCourseLivingDrawViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHLiveCourseLivingDrawViewCell" forIndexPath:indexPath];
    if (self.drawSelectIndex == indexPath.item) {
        cell.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }else{
        cell.backgroundColor = UIColor.clearColor;
    }
    cell.imageView.image = [UIImage imageNamed:_drawDataSource[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_drawDataSource[indexPath.item] isEqualToString:@"livingphoto"]) {//相册
    }else{
        _drawSelectIndex = indexPath.item;
        [collectionView reloadData];
    }
    !self.toolBlock ?:self.toolBlock(_drawDataSource[indexPath.item]);
}
#pragma mark - action -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.hidden = YES;
}
#pragma mark - lazy -
- (UICollectionView *)drawCollectionView//工具列表
{
    if (!_drawCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing         = 9;
        flow.minimumInteritemSpacing    = 4;
        flow.itemSize = CGSizeMake(36, 36);
        _drawCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.frame.size.width-260, 80, 164, 89) collectionViewLayout:flow];
        _drawCollectionView.backgroundColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
        _drawCollectionView.delegate = self;
        _drawCollectionView.dataSource = self;
        _drawCollectionView.bounces = NO;
        _drawCollectionView.layer.cornerRadius = 5;
        _drawCollectionView.layer.masksToBounds = YES;
        _drawCollectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        [_drawCollectionView registerClass:[SHLiveCourseLivingDrawViewCell class] forCellWithReuseIdentifier:@"SHLiveCourseLivingDrawViewCell"];
    }
    return _drawCollectionView;
}
- (UIView *)drawLineView//分割线
{
    if (!_drawLineView) {
        _drawLineView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-256, 124, 156, 1)];
        _drawLineView.backgroundColor = UIColor.whiteColor;
    }
    return _drawLineView;
}
- (NSArray *)drawDataSource
{
    if (!_drawDataSource) {
        _drawDataSource = @[@"livingarrow",@"linvingSelectArrow",@"livingpen",@"livingEraser",@"livingphoto"];
    }
    return _drawDataSource;
}
@end
