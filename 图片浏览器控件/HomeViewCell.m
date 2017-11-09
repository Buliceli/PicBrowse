//
//  HomeViewCell.m
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "HomeViewCell.h"
#import "PicCollectionView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface HomeViewCell ()
@property(nonatomic,strong)PicCollectionView * picView;
@end
@implementation HomeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _picView = [[PicCollectionView alloc]initWithFrame:self.frame collectionViewLayout:layout];
        _picView.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_picView];
        [self setUpFrame];
    }
    return self;
}
- (void)setUpFrame
{
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}
- (void)setViewModel:(StatusViewModel *)viewModel
{
    _viewModel = viewModel;
    _picView.picURLs = viewModel.urls;
    
    
}

@end
