//
//  StatusViewModel.h
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewModel : NSObject
@property(nonatomic,strong)NSArray<NSURL*>*urls;
@property(nonatomic,assign)CGFloat cellHeight;
@end
