//
//  PhotoBrowserController.m
//  图片浏览器控件
//
//  Created by 李洞洞 on 8/11/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "PhotoBrowserController.h"
#import "Masonry.h"
#import "PhotoBrowserViewCell.h"
#import "PhotoBrowserCollectionViewLayout.h"
#import <Photos/Photos.h>
static NSString * const PhotoBrowserCell = @"PhotoBrowserCell";
@interface PhotoBrowserController ()<UICollectionViewDataSource,PhotoBrowserViewCellDelegate>
@end

@implementation PhotoBrowserController
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        PhotoBrowserCollectionViewLayout * layout = [[PhotoBrowserCollectionViewLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    return _collectionView;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        _closeBtn.backgroundColor = [UIColor darkGrayColor];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _closeBtn;
}
- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]init];
        _saveBtn.backgroundColor = [UIColor darkGrayColor];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _saveBtn;
}

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath picURLs:(NSArray<NSString *> *)picURLs
{
    if (self = [super init]) {
        self.indexPath = indexPath;
        self.picURLs = picURLs;
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    
    CGRect rect = self.view.frame;
    rect.size.width += 20;
    self.view.frame = rect;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self setUpUI];
}
- (void)setUpUI
{
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.saveBtn];
    
    self.collectionView.frame = self.view.bounds;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.bottom.mas_offset(-20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(32);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-40);
        make.bottom.mas_equalTo(self.closeBtn.mas_bottom);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(32);
    }];
    
    [self.collectionView registerClass:[PhotoBrowserViewCell class] forCellWithReuseIdentifier:PhotoBrowserCell];
    
    self.collectionView.dataSource = self;
    [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
#pragma mark --- collectionView的数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picURLs.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoBrowserCell forIndexPath:indexPath];
    cell.picURL = self.picURLs[indexPath.item];
    cell.delegate = self;
    return cell;
}
#pragma mark --- PhotoBrowserViewCell的代理方法
- (void)imageViewClick
{
    [self closeBtnClick];
}
#pragma mark --- 遵守AnimatorDismissDelegate
- (NSIndexPath *)indexPathForDissmissView
{
    PhotoBrowserViewCell * cell = self.collectionView.visibleCells.firstObject;
    return [self.collectionView indexPathForCell:cell];
}
- (UIImageView *)imageViewForDissmissView
{
    UIImageView * imageView = [[UIImageView alloc]init];
    PhotoBrowserViewCell * cell = self.collectionView.visibleCells.firstObject;
    imageView.frame = cell.imageView.frame;
    imageView.image = cell.imageView.image;
    return imageView;
}
- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveBtnClick
{
    PhotoBrowserViewCell * cell = (PhotoBrowserViewCell*)self.collectionView.visibleCells.firstObject;
    UIImage * image = cell.imageView.image;
    if (!image) {
        return;
    }
#if 0 //可以保存到相册 但是不在相册中创建独立的相簿
    //保存相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
#endif
    
#if 1 //为应用在相册中创建独立的相簿
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        NSLog(@"因为系统原因,无法访问相册");
    }else if (status == PHAuthorizationStatusDenied){
        NSLog(@"[设置-隐私-照片-****]打开访问开关");
    }else if (status == PHAuthorizationStatusAuthorized){
        [self saveImage:image];
        NSLog(@"用户允许当前应用访问相册<用户当初点击了好>");
    }else if (status == PHAuthorizationStatusNotDetermined){
        //用户还没做出选择
        //弹窗请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImage:image];
            }
        }];
    }
    
#endif
}
#if 0
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
}
#endif
- (void)saveImage:(UIImage*)image
{
    // PHAsset : 一个资源, 比如一张图片\一段视频
    // PHAssetCollection : 一个相簿
    
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            NSLog(@"保存图片失败!");
            return;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        if (createdAssetCollection == nil) {
            NSLog(@"创建相簿失败!");
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 3.添加"相机胶卷"中的图片A到"相簿"D中
            
            // 获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                NSLog(@"保存图片失败!");
            } else {
                NSLog(@"保存图片成功!");
            }
        }];
    }];
}

/**
 *  获得相簿
 */
static NSString * XMGAssetCollectionTitle = @"图片浏览器控件";
- (PHAssetCollection *)createdAssetCollection
{
    // 从已存在相簿中查找这个应用对应的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:XMGAssetCollectionTitle]) {
            return assetCollection;
        }
    }
    
    // 没有找到对应的相簿, 得创建新的相簿
    
    // 错误信息
    NSError *error = nil;
    
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:XMGAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 如果有错误信息
    if (error) return nil;
    
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}
@end
































