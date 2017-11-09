//
//  PhotoBrowserAnimator.h
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AnimatorPresentedDelegate <NSObject>

- (CGRect)startRect:(NSIndexPath*)indexPath;
- (CGRect)endRect:(NSIndexPath*)indexPath;
- (UIImageView*)imageView:(NSIndexPath*)indexPath;

@end
@protocol AnimatorDismissDelegate <NSObject>

- (NSIndexPath*)indexPathForDissmissView;
- (UIImageView*)imageViewForDissmissView;

@end
@interface PhotoBrowserAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
@property(nonatomic,assign)id<AnimatorPresentedDelegate>presentedDelegate;
@property(nonatomic,assign)id<AnimatorDismissDelegate>dismissDelegate;
@property(nonatomic,assign)BOOL isPresented;
@property(nonatomic,assign)CGRect presentedFrame;
@property(nonatomic,strong)NSIndexPath * indexPath;

@end

























