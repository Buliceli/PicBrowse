//
//  PicCollectionViewCell.m
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "PicCollectionViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface PicCollectionViewCell()
@property(nonatomic,strong)UIImageView * iconView;
@end
@implementation PicCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconView];
        [self setUpFrame];
    }
    return self;
}
- (void)setUpFrame
{
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}
- (void)setPicURL:(NSURL *)picURL
{
    _picURL = picURL;
    [_iconView sd_setImageWithURL:picURL];
}
@end
