//
//  ViewController.m
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "ViewController.h"
#import "PhotoBrowserController.h"
#import "PhotoBrowserAnimator.h"
#import "HomeViewCell.h"
#import "StatusViewModel.h"
#import "UIImageView+WebCache.h"
#import "PicCollectionView.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)PhotoBrowserAnimator * photoBrowserAnimator;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * viewmodels;
@end

@implementation ViewController
- (NSMutableArray *)viewmodels
{
    if (!_viewmodels) {
        _viewmodels = [NSMutableArray array];
#if 1  //第一个模型
        StatusViewModel * model1 = [[StatusViewModel alloc]init];
        NSURL * url1 = [NSURL URLWithString:@"http://www.roadqu.com/data/attachment/admin/qly_seasonal_20150603171743.jpg"];
        model1.urls = @[url1];
        [_viewmodels addObject:model1];
#endif
        
#if 1 //第二个模型
        StatusViewModel * model2 = [[StatusViewModel alloc]init];
        NSURL * url2 = [NSURL URLWithString:@"http://www.roadqu.com/data/attachment/admin/qly_seasonal_20150603171743.jpg"];
        NSURL * url3 = [NSURL URLWithString:@"http://www.roadqu.com/data/attachment/admin/qly_seasonal_20150603171743.jpg"];
        model2.urls = @[url2,url3];
        [_viewmodels addObject:model2];
#endif
#if 1 //第三个模型
        StatusViewModel * model3 = [[StatusViewModel alloc]init];
        NSURL * url4 = [NSURL URLWithString:@"http://7fvaoh.com3.z0.glb.qiniucdn.com/image/150930/6n7mqcf5i.jpg-w720"];
        NSURL * url5 = [NSURL URLWithString:@"http://7fvaoh.com3.z0.glb.qiniucdn.com/image/150922/eztuq3503.jpg-w720"];
        NSURL * url6 = [NSURL URLWithString:@"http://7fvaoh.com3.z0.glb.qiniucdn.com/image/150910/wqypepz6a.jpg-w720"];
        NSURL * url7 = [NSURL URLWithString:@"http://7fvaoh.com3.z0.glb.qiniucdn.com/image/151010/3d108hija.jpg-w720"];
        NSURL * url8 = [NSURL URLWithString:@"http://7fvaoh.com3.z0.glb.qiniucdn.com/image/150911/eh3jazigh.jpg-w720"];
        
        model3.urls = @[url6,url7,url8,url4,url5];
        
        
        [_viewmodels addObject:model3];

#endif
        
        
    }
    return _viewmodels;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HomeViewCell class] forCellReuseIdentifier:@"HomeCell"];
    }
    return _tableView;
}
- (PhotoBrowserAnimator *)photoBrowserAnimator
{
    if (!_photoBrowserAnimator) {
        _photoBrowserAnimator = [[PhotoBrowserAnimator alloc]init];
    }
    return _photoBrowserAnimator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
    [self setUpNatification];
}
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewmodels.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    cell.viewModel = self.viewmodels[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 100;
   
}
- (void)setUpNatification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showPhotoBrowser:) name:@"ShowPhotoBrowserNote" object:nil];
}
- (void)showPhotoBrowser:(NSNotification*)note
{
    NSIndexPath * indexPath = note.userInfo[@"ShowPhotoBrowserIndexKey"];
    
    NSArray * picURLs = note.userInfo[@"ShowPhotoBrowserUrlsKey"];
    
    PicCollectionView * object = (PicCollectionView*)note.object;
    PhotoBrowserController * photoBrowserVc = [[PhotoBrowserController alloc]initWithIndexPath:indexPath picURLs:picURLs];
    
    photoBrowserVc.modalTransitionStyle = UIModalPresentationCustom;
    photoBrowserVc.transitioningDelegate = self.photoBrowserAnimator;
    
    self.photoBrowserAnimator.presentedDelegate = object;
    self.photoBrowserAnimator.indexPath = indexPath;
    self.photoBrowserAnimator.dismissDelegate = photoBrowserVc;
    
    [self presentViewController:photoBrowserVc animated:YES completion:nil];
}
@end





















