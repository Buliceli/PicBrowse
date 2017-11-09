//
//  PicCollectionView.m
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "PicCollectionView.h"
#import "PicCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface PicCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@end
static NSString * const cellID = @"cellID";
@implementation PicCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[PicCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return self;
}
- (void)setPicURLs:(NSArray<NSURL *> *)picURLs
{
    _picURLs = picURLs;
    
    [self reloadData];
}
#pragma mark -- collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picURLs.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.picURL = self.picURLs[indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arr = self.picURLs;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowPhotoBrowserNote" object:self userInfo:@{@"ShowPhotoBrowserIndexKey":indexPath,@"ShowPhotoBrowserUrlsKey":arr}];
}
#pragma mark --- AnimatorPresentedDelegate
- (CGRect)startRect:(NSIndexPath *)indexPath
{
    PicCollectionViewCell * cell = (PicCollectionViewCell*)[self cellForItemAtIndexPath:indexPath];
    //获取cell的frame
    CGRect startFrame = [self convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
    
    return startFrame;
}
- (CGRect)endRect:(NSIndexPath *)indexPath
{
    NSURL * picURL = self.picURLs[indexPath.item];
    UIImage * image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:picURL.absoluteString];
    //计算结束后的frame
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = w / image.size.width * image.size.height;
    CGFloat y = 0;
    if (h > [UIScreen mainScreen].bounds.size.height) {
        y = 0;
    }else{
        y = ([UIScreen mainScreen].bounds.size.height - h) * 0.5;
    }
    return CGRectMake(0, y, w, h);
}
- (UIImageView *)imageView:(NSIndexPath *)indexPath
{
    UIImageView * imageView = [[UIImageView alloc]init];
    NSURL * url = self.picURLs[indexPath.item];
    [[SDWebImageManager sharedManager]downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        imageView.image = image;
    }];
    return imageView;
}
@end
