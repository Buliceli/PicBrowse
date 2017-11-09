//
//  PhotoBrowserCollectionViewLayout.m
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "PhotoBrowserCollectionViewLayout.h"

@implementation PhotoBrowserCollectionViewLayout
- (void)prepareLayout
{
    [super prepareLayout];
    //设置itemSize
    self.itemSize = self.collectionView.frame.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置collectionView的属性
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}
@end
