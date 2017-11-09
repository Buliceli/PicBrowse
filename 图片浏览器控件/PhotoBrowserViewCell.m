//
//  PhotoBrowserViewCell.m
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "PhotoBrowserViewCell.h"
#import "UIImageView+WebCache.h"

@interface PhotoBrowserViewCell ()<UIScrollViewDelegate>

@end
@implementation PhotoBrowserViewCell
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}
- (ProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[ProgressView alloc]init];
    }
    return _progressView;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
- (void)setPicURL:(NSURL *)picURL
{
    _picURL = picURL;
    [self setupContent:picURL];
}
- (void)setupContent:(NSURL*)picURL
{
    if (!picURL) {
        return;
    }
    //取出image对象
    UIImage * image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:picURL.absoluteString];
    //计算imageView的frame
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width / image.size.width * image.size.height;
    CGFloat y = 0;
    if (height > [UIScreen mainScreen].bounds.size.height) {
        y = 0;
    }else{
        y = ([UIScreen mainScreen].bounds.size.height - height) * 0.5;
    }
    self.imageView.frame = CGRectMake(0, y, width, height);
    
    //设置imageView的图片
    self.progressView.hidden = NO;
#if 1
    [self.imageView sd_setImageWithURL:picURL placeholderImage:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.progress = receivedSize / expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
#endif
    self.scrollView.contentSize = CGSizeMake(0, height);
    //self.scrollView.contentSize = image.size;
    self.scrollView.delegate = self;
    //缩放比例
   // CGFloat scale = image.size.width / self.imageView.frame.size.width;
    //if (scale > 1.0) {
     //   self.scrollView.maximumZoomScale = scale;
    //}
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;
}
#pragma mark - <UIScrollViewDelegate>
/**
 *  返回一个scrollView的子控件进行缩放
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    //添加子控件
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.progressView];
    [self.scrollView addSubview:self.imageView];
    //设置子控件frame
    self.scrollView.frame = self.contentView.bounds;
    CGRect rect = self.scrollView.frame;
    rect.size.width -= 20;
    self.scrollView.frame = rect;
    
    self.progressView.bounds = CGRectMake(0, 0, 50, 50);
    self.progressView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    self.progressView.hidden = YES;
    self.progressView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick)];
    [self.imageView addGestureRecognizer:tap];
    self.imageView.userInteractionEnabled = YES;
}
- (void)imageViewClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewClick)]) {
        [self.delegate imageViewClick];
    }
}
@end
