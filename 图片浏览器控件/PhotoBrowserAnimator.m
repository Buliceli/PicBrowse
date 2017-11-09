//
//  PhotoBrowserAnimator.m
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "PhotoBrowserAnimator.h"

@implementation PhotoBrowserAnimator
#pragma mark -- UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresented = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresented = NO;
    return self;
}
#pragma mark -- UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
//转场上下文 负责具体的转场动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.isPresented ? [self animationForPresentedView:transitionContext] : [self animationForDismissView:transitionContext];
}

- (void)animationForPresentedView:(id<UIViewControllerContextTransitioning>)transitionContext
{

    if (!(self.presentedDelegate && self.indexPath)) {
        return;
    }
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    fromView.alpha = 0;
    //取出弹出的View
    UIView * presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //将presentedView添加到containerView中
    UIView * containerView = [transitionContext containerView];
    UIView * frameView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [containerView addSubview:frameView];
    [containerView addSubview:presentedView];
    
    //获取执行动画的imageView
    CGRect startRect = [self.presentedDelegate startRect:self.indexPath];
    UIImageView * imageView = [self.presentedDelegate imageView:self.indexPath];
    [containerView addSubview:imageView];
    imageView.frame = startRect;
    
    //执行动画
    presentedView.alpha = 0.0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        imageView.frame = [self.presentedDelegate endRect:self.indexPath];
        
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        presentedView.alpha = 1.0;
        [transitionContext completeTransition:YES];
    }];
    
}
- (void)animationForDismissView:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (!self.dismissDelegate && !self.presentedDelegate) {
        return;
    }
    //取出消失的View
    UIView * dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [dismissView removeFromSuperview];
    
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.alpha = 1.0;
   
   //获取执行动画的ImageView
    UIImageView * imageView = [self.dismissDelegate imageViewForDissmissView];
    UIView * containerView = [transitionContext containerView];
    [containerView addSubview:imageView];
    NSIndexPath * indexPath = [self.dismissDelegate indexPathForDissmissView];
    containerView.backgroundColor = [UIColor clearColor];

    //执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
       
        
        imageView.frame = [self.presentedDelegate startRect:indexPath];
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
    }];
    
    
    
    
}
@end
