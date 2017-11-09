//
//  PhotoBrowserController.h
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserAnimator.h"
@interface PhotoBrowserController : UIViewController<AnimatorDismissDelegate>
@property(nonatomic,strong)NSIndexPath * indexPath;
@property(nonatomic,strong)NSArray*picURLs;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIButton * closeBtn;
@property(nonatomic,strong)UIButton * saveBtn;
- (instancetype)initWithIndexPath:(NSIndexPath*)indexPath picURLs:(NSArray<NSString*>*)picURLs;
@end
