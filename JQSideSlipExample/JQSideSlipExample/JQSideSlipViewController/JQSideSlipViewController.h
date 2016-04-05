//
//  JQSideSlipViewController.h
//  JQSideSlipViewController
//
//  Created by Evan on 15/10/1.
//  Copyright © 2015年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JQSideSlipViewController;

@protocol JQSideSlipViewControllerMainDelegate <NSObject>

@optional

- (void)sideSlipViewController:(JQSideSlipViewController *)sideSlipViewController messageFromLeftViewController:(id)sender;

- (void)sideSlipViewController:(JQSideSlipViewController *)sideSlipViewController willShowLeftViewController:(BOOL)animated;

- (void)sideSlipViewController:(JQSideSlipViewController *)sideSlipViewController willHideLeftViewController:(BOOL)animated;

@end

@protocol JQSideSlipViewControllerSideSlipDelegate <NSObject>

@optional

- (void)sideSlipViewController:(JQSideSlipViewController *)sideSlipViewController sideSlipViewControllerShowRatio:(CGFloat)ratio;

@end

@interface JQSideSlipViewController : UIViewController

/**
 *  主控制器
 */
@property (nonatomic, strong) UIViewController *mainViewController;

/**
 *  左边控制器
 */
@property (nonatomic, strong) UIViewController *leftViewController;

/**
 *  主视图代理
 */
@property (nonatomic, weak) id<JQSideSlipViewControllerMainDelegate> mainDelegate;

/**
 *  侧滑代理
 */
@property (nonatomic, weak) id<JQSideSlipViewControllerSideSlipDelegate> sideSlipDelegate;

/**
 *  左边最大显示偏移 默认 屏幕宽度-kMainViewControllerMaxOffset
 */
@property (nonatomic, assign) CGFloat mainViewControllerMaxOffset;

/**
 *  左视图是否变换 默认NO
 */
@property (nonatomic, assign) BOOL leftViewControllerTransform;
/**
 *  背景图片
 */
@property (nonatomic, strong) UIImage *backgroundImage;
/**
 *  是否背景放大 默认NO
 */
@property (nonatomic, assign) BOOL scaleBackgroundImage;

/**
 *  构造方法
 *
 *  @param mainViewController <#mainViewController description#>
 *  @param leftViewController <#leftViewController description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController;

/**
 *  显示左边的视图
 *  @param animated 是否显示左视图
 *  @param animated 是否需要动画
 */
- (void)showLeftViewController:(BOOL)show animated:(BOOL)animated;

/**
 *  通知主控制器隐藏或显示
 *
 *  @param sender <#sender description#>
 *  @param hidden <#hidden description#>
 */
- (void)sendMessageToMainViewController:(id)sender hideLeftViewController:(BOOL)hidden;

@end


//类别
@interface UIViewController (JQSideSlipViewController)

@property (nonatomic, strong) JQSideSlipViewController *sideSlipViewController;

@end
