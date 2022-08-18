//
//  ViewController.m
//  DrawContextDemo
//
//  Created by tangfeng on 2022/8/18.
//

#import "ViewController.h"
#import "SHLiveCourseLivingDrawContextView.h"//画板
#import "SHLiveCourseLivingRightToolView.h"//右侧工具列表
#import "SHLiveCourseLivingDrawToolView.h"//画画工具视图
#import "SHLiveCourseLivingPenSetView.h"//笔-设置
#import "SHLiveCourseLivingEraserSetView.h"//橡皮擦设置

@interface ViewController ()
@property (nonatomic , strong) SHLiveCourseLivingDrawContextView                *drawContextView;//画板
@property (nonatomic , strong) SHLiveCourseLivingRightToolView                  *toolView;//工具栏
@property (nonatomic , strong) SHLiveCourseLivingDrawToolView                   *drawView;//画画工具视图
@property (nonatomic , strong) SHLiveCourseLivingPenSetView                     *penSetView;//笔-设置
@property (nonatomic , strong) SHLiveCourseLivingEraserSetView                  *eraserSetView;//橡皮擦-设置

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.drawContextView];//画板
    [self.view addSubview:self.toolView];//工具栏
    [self.view addSubview:self.drawView];//画画工具视图
    [self.view addSubview:self.toolView];//工具栏
    [self.view addSubview:self.penSetView];//笔-设置
    [self.view addSubview:self.eraserSetView];//橡皮擦-设置
}
#pragma mark - action -
- (void)toolClick//工具
{
    self.drawView.hidden = NO;
}
- (void)penSetClick//笔-橡皮擦
{
    if (self.drawView.drawSelectIndex == 2) {//笔
        self.penSetView.hidden = NO;
    }else if (self.drawView.drawSelectIndex == 1){//删除
        [self.drawContextView deleteOfSelected];
    }else if (self.drawView.drawSelectIndex == 3){//橡皮擦
        self.eraserSetView.hidden = NO;
    }
}
#pragma mark - lazy -
- (SHLiveCourseLivingDrawContextView *)drawContextView//画板
{
    if (!_drawContextView) {
        _drawContextView = [[SHLiveCourseLivingDrawContextView alloc] initWithFrame:self.view.bounds];
    }
    return _drawContextView;
}
- (SHLiveCourseLivingRightToolView *)toolView//工具栏
{
    if (!_toolView) {
        _toolView = [[SHLiveCourseLivingRightToolView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-86, 80, 36, 76)];
        [_toolView.toolButton addTarget:self action:@selector(toolClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolView.penSetButton addTarget:self action:@selector(penSetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolView;
}
- (SHLiveCourseLivingDrawToolView *)drawView//画画工具视图
{
    if (!_drawView) {
        _drawView = [[SHLiveCourseLivingDrawToolView alloc] initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf = self;
        _drawView.toolBlock = ^(NSString * type) {
            if ([type isEqualToString:@"livingphoto"]) {//相册
                weakSelf.drawView.hidden = YES;
            }else{
                [weakSelf.toolView.toolButton setImage:[UIImage imageNamed:type] forState:0];
                weakSelf.toolView.penSetButton.hidden = !([type isEqualToString:@"livingpen"]||
                                             [type isEqualToString:@"livingEraser"]||
                                             [type isEqualToString:@"linvingSelectArrow"]);
                if ([type isEqualToString:@"linvingSelectArrow"]) {
                    [weakSelf.toolView.penSetButton setImage:[UIImage imageNamed:@"livingDelete"] forState:0];
                    weakSelf.toolView.colorView.hidden = YES;
                }else{
                    weakSelf.toolView.colorView.backgroundColor = [type isEqualToString:@"livingEraser"] ? UIColor.whiteColor:weakSelf.drawContextView.selectColor;
                    [weakSelf.toolView.penSetButton setImage:nil forState:0];
                    weakSelf.toolView.colorView.hidden = NO;
                }
                if ([type isEqualToString:@"livingEraser"]) {
                    weakSelf.drawContextView.selectSize = weakSelf.eraserSetView.selectSize;
                }else if ([type isEqualToString:@"livingpen"]){
                    weakSelf.drawContextView.selectTypeIndex = weakSelf.penSetView.selectIndex_type;
                    weakSelf.drawContextView.selectColor = weakSelf.penSetView.selectColor;
                    weakSelf.drawContextView.selectSize = weakSelf.penSetView.selectSize;
                }
                weakSelf.drawContextView.type = weakSelf.drawView.drawSelectIndex;
            }
        };
        [self.view addSubview:_drawView];
    }
    return _drawView;
}
- (SHLiveCourseLivingPenSetView *)penSetView//笔-编辑
{
    if (!_penSetView) {
        _penSetView = [[SHLiveCourseLivingPenSetView alloc] initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf = self;
        _penSetView.typeBlock = ^(NSInteger selectTypeIndex) {//类型
            weakSelf.drawContextView.type = selectTypeIndex;
        };
        _penSetView.colorBlock = ^(UIColor * _Nullable color) {//颜色
            weakSelf.toolView.colorView.backgroundColor = color;
            weakSelf.drawContextView.selectColor = color;
        };
        _penSetView.sizeBlock = ^(NSString * _Nullable selectSize) {//尺寸
            weakSelf.drawContextView.selectSize = selectSize;
        };
        [self.view addSubview:_penSetView];
    }
    return _penSetView;
}
- (SHLiveCourseLivingEraserSetView *)eraserSetView//橡皮擦-设置
{
    if (!_eraserSetView) {
        _eraserSetView = [[SHLiveCourseLivingEraserSetView alloc] initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf = self;
        _eraserSetView.selectBlock = ^(NSString *selectSize) {
            weakSelf.drawContextView.selectSize = selectSize;
        };
        [self.view addSubview:_eraserSetView];
    }
    return _eraserSetView;
}
@end
