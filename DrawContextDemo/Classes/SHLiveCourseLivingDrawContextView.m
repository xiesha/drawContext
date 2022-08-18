//
//  SHLiveCourseLivingDrawContextView.m
//  TangCe
//
//  Created by tangfeng on 2022/8/5.
//  Copyright © 2022 net.tangce.iOS. All rights reserved.
//

#import "SHLiveCourseLivingDrawContextView.h"
#import "SHShapeLayer.h"

@interface SHLiveCourseLivingDrawContextView ()
@property (nonatomic , strong) SHShapeLayer         *shapeLayer;//图层
@property (nonatomic , strong) NSMutableArray       *shapeLayers;//图层数组
@property (nonatomic , strong) NSMutableArray       *selectShapeLayers;//选中图层数组
@property (nonatomic , copy  ) NSArray              *gestures;//系统手势
@property (nonatomic , strong) UIImageView          *penImageView;//笔
@property (nonatomic , strong) UIView               *selectView;//选中视图
@property (nonatomic)          CGPoint              selectPoint;//选中点
@end

@implementation SHLiveCourseLivingDrawContextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.darkGrayColor;
        self.clipsToBounds = YES;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = YES;
        _selectTypeIndex = 0;
        _selectColor = [UIColor colorWithRed:255/255.0 green:84/255.0 blue:101/255.0 alpha:1.0];
        _selectSize = @"2";
        _gestures = self.gestureRecognizers;
        _type = SHLivingDrawContextTypeArrow;
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height*5);
    }
    return self;
}
- (void)setType:(SHLivingDrawContextType)type
{
    _type = type;
    if (type == SHLivingDrawContextTypeArrow) {//箭头
        self.gestureRecognizers = _gestures;
    }else if (type == SHLivingDrawContextTypeSelectArrow){//选中箭头
        self.gestureRecognizers = nil;
    }else if (type == SHLivingDrawContextTypePen){//笔
        self.gestureRecognizers = nil;
    }else{                                          //橡皮擦
        self.gestureRecognizers = nil;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (self.type != SHLivingDrawContextTypeSelectArrow && self.selectShapeLayers.count > 0) {
        for (SHShapeLayer *sh in self.selectShapeLayers) {
            [sh selectLayerState:NO];
        }
        [self.selectShapeLayers removeAllObjects];
    }
    if (self.type == SHLivingDrawContextTypePen) {//笔
        _shapeLayer = [self creatNewShapLayer];
        [self.shapeLayers addObject:_shapeLayer];
        [_shapeLayer setPoint:point IsDraw:YES];
        self.penImageView.hidden = self.type != SHLivingDrawContextTypePen;
        self.penImageView.center = CGPointMake([touch locationInView:self].x+8, [touch locationInView:self].y-8);
        [self bringSubviewToFront:self.penImageView];
    }else if (self.type == SHLivingDrawContextTypeEraser){//橡皮
        [self deleteWithPoint:CGPointMake((NSInteger)point.x, (NSInteger)point.y)];
    }else if (self.type == SHLivingDrawContextTypeSelectArrow){//选中
        _shapeLayer = nil;
        NSInteger count = self.selectShapeLayers.count;
        for (NSInteger i = count-1; i >= 0 ; i--) {
            SHShapeLayer *sh = self.selectShapeLayers[i];
            CGRect subRect = CGRectMake(sh.min_X, sh.min_Y, sh.max_X-sh.min_X, sh.max_Y - sh.min_Y);
            if (CGRectContainsPoint(subRect, point)) {
                _shapeLayer = self.selectShapeLayers[i];
                break;
            }
        }
        if (!_shapeLayer) {
            self.selectView.hidden = NO;
            self.selectView.frame = CGRectMake(point.x,point.y, 1, 1);
        }
        self.selectPoint = point;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (self.type == SHLivingDrawContextTypePen) {//笔
        [_shapeLayer setPoint:point IsDraw:YES];
        self.penImageView.center = CGPointMake([touch locationInView:self].x+8, [touch locationInView:self].y-8);
    }else if (self.type == SHLivingDrawContextTypeEraser){//橡皮
        [self deleteWithPoint:point];
    }else if (self.type == SHLivingDrawContextTypeSelectArrow){//选中
        if (_shapeLayer) {
            [_shapeLayer moveLayerWithPoint:CGPointMake(point.x - self.selectPoint.x, point.y - self.selectPoint.y)];
            self.selectPoint = point;
        }else{
            [self selectSubLayersWithPoint:point];
        }
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.type == SHLivingDrawContextTypePen) {//笔
        self.penImageView.hidden = YES;
    }else if (self.type == SHLivingDrawContextTypeEraser){//橡皮
        
    }else if (self.type == SHLivingDrawContextTypeSelectArrow){//选中
        if (!_shapeLayer) {
            self.selectView.hidden = YES;
            UITouch *touch = touches.anyObject;
            CGPoint point = [touch locationInView:self];
            if (point.x == self.selectPoint.x) {
                [self selectSubLayerWithPoint:point];
            }else{
                [self selectSubLayerWithRect:self.selectView.frame];
            }
        }else{
            _shapeLayer = nil;
        }
    }
}
- (void)deleteOfSelected
{
    if (self.selectShapeLayers.count > 0) {
        for (SHShapeLayer *sh in self.selectShapeLayers) {
            [sh removeFromSuperlayer];
            [self.shapeLayers removeObject:sh];
        }
        [self.selectShapeLayers removeAllObjects];
    }
}
#pragma mark - lazy -
- (UIImageView *)penImageView//笔
{
    if (!_penImageView) {
        _penImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"livingpen"]];
        _penImageView.frame = CGRectMake(0, 0, 20, 20);
        [self addSubview:_penImageView];
    }
    return _penImageView;
}
- (NSMutableArray *)shapeLayers//图层
{
    if (!_shapeLayers) {
        _shapeLayers = [NSMutableArray array];
    }
    return _shapeLayers;
}
- (NSMutableArray *)selectShapeLayers//选中图层数组
{
    if (!_selectShapeLayers) {
        _selectShapeLayers = [NSMutableArray array];
    }
    return _selectShapeLayers;
}
- (UIView *)selectView//选中视图
{
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _selectView.layer.borderColor = UIColor.whiteColor.CGColor;
        _selectView.layer.borderWidth = 0.5;
        _selectView.hidden = YES;
        [self addSubview:_selectView];
    }
    return _selectView;
}
#pragma mark - customMothed -
- (SHShapeLayer *)creatNewShapLayer//创建
{
    SHShapeLayer *shapeLayer = [SHShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    shapeLayer.lineWidth = _selectSize.floatValue;
    shapeLayer.strokeColor = _selectColor.CGColor;
    [self.layer insertSublayer:shapeLayer below:self.layer];
    return shapeLayer;
}
- (void)deleteWithPoint:(CGPoint)point//删除
{
    NSInteger count = self.shapeLayers.count;
    for (NSInteger i=0; i<count; i++) {
        SHShapeLayer *sh = self.shapeLayers[i];
        sh.eraserWidth = self.selectSize.floatValue;
        [sh setPoint:point IsDraw:NO];
    }
}
- (void)selectSubLayersWithPoint:(CGPoint)point//选中
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    if (self.selectPoint.x < point.x) {
        x = self.selectPoint.x;
        w = point.x - self.selectPoint.x;
    }else{
        x = point.x;
        w = self.selectPoint.x - point.x;
    }
    if (self.selectPoint.y < point.y) {
        y = self.selectPoint.y;
        h = point.y - self.selectPoint.y;
    }else{
        y = point.y;
        h = self.selectPoint.y - point.y;
    }
    self.selectView.frame = CGRectMake(x, y, w, h);
}
- (void)selectSubLayerWithRect:(CGRect)rect{//选中图层
    [self.selectShapeLayers removeAllObjects];
    NSInteger count = self.shapeLayers.count;
    for (NSInteger i=0; i<count; i++) {
        SHShapeLayer *sh = self.shapeLayers[i];
        CGRect subRect = CGRectMake(sh.min_X, sh.min_Y, sh.max_X-sh.min_X, sh.max_Y - sh.min_Y);
        BOOL yes = CGRectContainsRect(rect, subRect);
        [sh selectLayerState:yes];
        if (yes) [self.selectShapeLayers addObject:sh];
    }
}
- (void)selectSubLayerWithPoint:(CGPoint)point{//点击选中
    [self.selectShapeLayers removeAllObjects];
    NSInteger count = self.shapeLayers.count;
    for (NSInteger i=count-1; i >= 0; i--) {
        SHShapeLayer *sh = self.shapeLayers[i];
        CGRect subRect = CGRectMake(sh.min_X, sh.min_Y, sh.max_X-sh.min_X, sh.max_Y - sh.min_Y);
        BOOL yes = CGRectContainsPoint(subRect, point);
        if (yes && self.selectShapeLayers.count == 0) {
            [sh selectLayerState:YES];
            [self.selectShapeLayers addObject:sh];
        }else{
            [sh selectLayerState:NO];
        }
    }
}
@end
