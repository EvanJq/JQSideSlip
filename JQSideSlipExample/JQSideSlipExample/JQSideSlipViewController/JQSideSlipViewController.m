//
//  JQSideSlipViewController.m
//  JQSideSlipViewController
//
//  Created by Evan on 15/10/1.
//  Copyright © 2015年 Evan. All rights reserved.
//

#import "JQSideSlipViewController.h"

//导入
#import <objc/runtime.h>

//mainView的距离右边的最小宽度
#define kMainViewControllerMaxOffset 100

//动画时间
#define kJQMainViewControllerAnimationDuration 0.3

//mainView缩放最小刻度
#define kJQMainViewControllerMinScale 0.8f
#define kJQMenuViewControllerMaxScale 1.4f
#define kJQBackgroudImageMaxScale 1.7f

@interface JQSideSlipViewController ()

// 拖动手势
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (strong, nonatomic) UIButton *contentButton;

@property (nonatomic, weak) UIImageView *backgroundImageView;

@end

@implementation JQSideSlipViewController

/**
 *  构造方法
 *
 *  @param mainViewController <#mainViewController description#>
 *  @param leftViewController <#leftViewController description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController
{
    if (self = [super init])
    {
        // 1.赋值
        self.mainViewController = mainViewController;
        self.leftViewController = leftViewController;
        
        _mainViewControllerMaxOffset = self.view.frame.size.width - kMainViewControllerMaxOffset;
    }
    
    return self;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture)
    {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGesture;
}

- (UIButton *)contentButton
{
    if (!_contentButton) {
        _contentButton = [[UIButton alloc] init];
        [_contentButton addTarget:self action:@selector(mainViewControllerTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentButton;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view insertSubview:backgroundImageView atIndex:0];
        _backgroundImageView = backgroundImageView;
    }
    return _backgroundImageView;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加关联
    [self addAssociations];
    
    // 把主界面和左边的视图加到当前视图上
    [self addChildViewController:self.leftViewController];
    [self addChildViewController:self.mainViewController];
    [self.view addSubview:self.leftViewController.view];
    [self.view addSubview:self.mainViewController.view];
}

// 添加关联
- (void)addAssociations
{
    self.mainViewController.sideSlipViewController = self;
    self.leftViewController.sideSlipViewController = self;
}

// 设置主视图代理时 给主视图添加手势
- (void)setMainDelegate:(id<JQSideSlipViewControllerMainDelegate>)mainDelegate
{
    _mainDelegate = mainDelegate;
    
    if ([mainDelegate isKindOfClass:[UIViewController class]])
    {
        UIViewController *vc = (UINavigationController *)mainDelegate;
        [vc.view addGestureRecognizer:self.panGesture];
    }
    else if( [mainDelegate isKindOfClass:[UIView class]] )
    {
        UIView *v = (UIView *)mainDelegate;
        [v addGestureRecognizer:self.panGesture];
    }
}

#pragma mark - 拖动主视图会触发
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    //1.拖动的偏移量
    CGPoint currentPoint = [gesture translationInView:self.view];
    // NSLog(@"----- %@",NSStringFromCGPoint(currentPoint));
    
    UIView *dragingView = self.mainViewController.view;
    //2.获取mainView的偏移
    CGFloat offsetX = dragingView.frame.origin.x + currentPoint.x;
    
    // 左边边界检测
    if (offsetX < 0)
    {
        offsetX = 0;
    }
    //右边界值检测
    else if( offsetX > _mainViewControllerMaxOffset )
    {
        
        offsetX = _mainViewControllerMaxOffset;
    }
    
    /*
     0 < X < self.view.width - kMainViewControllerMinDistince
     0 < X/(self.view.width - kMainViewControllerMinDistince) < 1.0
     X*0.2 --> [0,0.2]
     1-X*0.2 --> [1,0.8]
     */
    // 缩放
    if( offsetX != dragingView.frame.origin.x )
    {
        CGFloat ratio = offsetX / _mainViewControllerMaxOffset;
        //计算缩放比例
        CGFloat mainViewScale = 1 - (1 - kJQMainViewControllerMinScale) * ratio;
        //设置缩放比例
        dragingView.transform = CGAffineTransformMakeScale(mainViewScale, mainViewScale);
        
        // 左视图缩放偏移
        if (self.leftViewControllerTransform) {
            CGFloat menuViewScale = kJQMenuViewControllerMaxScale - (kJQMenuViewControllerMaxScale - 1 ) * ratio;
            self.leftViewController.view.alpha = ratio;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale);
        }
        
        // 背景图片缩放
        if (self.scaleBackgroundImage) {
            CGFloat backgroundViewScale = kJQBackgroudImageMaxScale - (kJQBackgroudImageMaxScale - 1 ) * ratio;
            self.backgroundImageView.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
        }
        
        
        // 缩放代理
        if( [self.sideSlipDelegate respondsToSelector:@selector(sideSlipViewController:sideSlipViewControllerShowRatio:)] )
        {
            [self.sideSlipDelegate sideSlipViewController:self sideSlipViewControllerShowRatio:ratio];
        }
    }
    
    //3.设置dragingView的坐标
    dragingView.frame = CGRectMake(offsetX, dragingView.frame.origin.y, dragingView.frame.size.width, dragingView.frame.size.height);
    
    // 因为手势的偏移量有叠加，所有要清空累计值
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
    //拖动结束
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        //拖动范围检测，如果超过最大范围的一半的话，显示左边视图，否则还原。
        if (dragingView.frame.origin.x >= _mainViewControllerMaxOffset * 0.5)
        {
            //显示左边视图
            [self showLeftViewController:YES animated:YES];
        }
        else //小于当前范围的一半，还原
        {
            //隐藏左边视图
            [self showLeftViewController:NO animated:YES];
        }
    }
}

#pragma mark - 显示左视图时，点击主视图会触发 隐藏左视图
- (void)mainViewControllerTap
{
    [self showLeftViewController:NO animated:YES];
}

- (void)showLeftViewController:(BOOL)show animated:(BOOL)animated
{
    //x偏移量
    CGFloat xOffset;
    CGFloat mainViewScale;
    CGFloat menuViewScale;
    CGFloat backgroundViewScale;
    CGFloat ratio;
    if( show )
    {
        //x偏移量
        xOffset = _mainViewControllerMaxOffset;
        mainViewScale = kJQMainViewControllerMinScale;
        menuViewScale = 1.0f;
        backgroundViewScale = 1.0f;
        ratio = 1.0;
        // 左视图显示时 给主视图添加点击事件
        self.contentButton.frame = self.mainViewController.view.bounds;
        [self.mainViewController.view addSubview:self.contentButton];
        [self.mainViewController.view addGestureRecognizer:self.panGesture];
        
        if ([self.mainDelegate respondsToSelector:@selector(sideSlipViewController:willShowLeftViewController:)]){
            [self.mainDelegate sideSlipViewController:self willShowLeftViewController:YES];
        }
    }
    else
    {
        //x偏移量
        xOffset = 0;
        mainViewScale = 1.0;
        menuViewScale = kJQMenuViewControllerMaxScale;
        backgroundViewScale = kJQBackgroudImageMaxScale;
        ratio = 0;
        // 左视图隐藏时 主视图添移除点击事件
        [self.contentButton removeFromSuperview];
        [self.mainViewController.view removeGestureRecognizer:self.panGesture];
        
        if ([self.mainDelegate respondsToSelector:@selector(sideSlipViewController:willHideLeftViewController:)]){
            [self.mainDelegate sideSlipViewController:self willHideLeftViewController:YES];
        }
    }
    
    //有动画
    if (animated)
    {
        [UIView animateWithDuration:kJQMainViewControllerAnimationDuration animations:^{
            [self setShowLeftAnimatedWithXoffset:xOffset mainViewScale:mainViewScale menuViewScale:menuViewScale backgroundViewScale:backgroundViewScale ratio:ratio];
        }];
    }
    else //没有动画
    {
        [self setShowLeftAnimatedWithXoffset:xOffset mainViewScale:mainViewScale menuViewScale:menuViewScale backgroundViewScale:backgroundViewScale  ratio:ratio];
    }
}

- (void)setShowLeftAnimatedWithXoffset:(CGFloat)xOffset mainViewScale:(CGFloat)mainViewScale menuViewScale:(CGFloat)menuViewScale backgroundViewScale:(CGFloat)backgroundViewScale ratio:(CGFloat)ratio
{
    self.leftViewController.view.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale);
    self.leftViewController.view.alpha = xOffset / kMainViewControllerMaxOffset;
    self.backgroundImageView.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
    // 缩放
    self.mainViewController.view.transform = CGAffineTransformMakeScale(mainViewScale, mainViewScale);
    // 偏移
    self.mainViewController.view.frame = CGRectMake(xOffset, self.mainViewController.view.frame.origin.y, self.mainViewController.view.frame.size.width, self.mainViewController.view.frame.size.height);
    // 显隐
    if( [self.sideSlipDelegate respondsToSelector:@selector(sideSlipViewController:sideSlipViewControllerShowRatio:)] )
    {
        [self.sideSlipDelegate sideSlipViewController:self sideSlipViewControllerShowRatio:ratio];
    }
}

#pragma mark - SideSlipViewControllerMainDelegate
- (void)sendMessageToMainViewController:(id)sender hideLeftViewController:(BOOL)hidden;
{
    if ([self.mainDelegate respondsToSelector:@selector(sideSlipViewController:messageFromLeftViewController:)])
    {
        [self.mainDelegate sideSlipViewController:self messageFromLeftViewController:sender];
    }
    if (hidden) {
        [self showLeftViewController:!hidden animated:YES];
    }
}

@end

@implementation UIViewController (JQSideSlipViewController)

const char *key;

- (void)setSideSlipViewController:(JQSideSlipViewController *)sideSlipViewController
{
    //建立关联
    objc_setAssociatedObject(self, &key, sideSlipViewController,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JQSideSlipViewController *)sideSlipViewController
{
    //根据key取被关联的值
    return objc_getAssociatedObject(self, &key);
}

@end
