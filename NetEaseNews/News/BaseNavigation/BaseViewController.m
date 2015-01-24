//
//  BaseViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/23.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//
#import "BaseViewController.h"
#import "AFURLResponseSerialization.h"
#import "ChannelModel.h"
#import "SingleModel.h"
#import "TitleCollectionBarCell.h"
#import "NSString+StringExt.h"

@interface BaseViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *channelCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *channelLayout;
@property (weak, nonatomic) IBOutlet UIView *collectionViewContain;
@property (nonatomic, strong) NSArray *channelList;

@end

@implementation BaseViewController

- (NSArray *)tList {
    if (_tList == nil) {
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *cArray = self.channelList;
        for (ChannelModel *channel in cArray) {
            NSArray *tListArray = channel.tList;
            for (int i = 0; i < tListArray.count; i++) {
                if ([tListArray[i] isKindOfClass:[SingleModel class]]) {
                    SingleModel *single = tListArray[i];
                    [arrayM addObject:single];
                }
            }
        }
        _tList = arrayM;
    }
    return _tList;
}

- (NSArray *)channelList {
    if (_channelList == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"all.json" withExtension:nil];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (id obj in json) {
            ChannelModel *channel = [ChannelModel channelModelWithDictionary:obj];
            [arrayM addObject:channel];
        }
        _channelList = arrayM;
    }
    return _channelList;
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    cell
//}

#pragma mark － 导航标题collection数据元方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setupChannelLayout];
    TitleCollectionBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channelCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(255)/255.0) green:(arc4random_uniform(255)/255.0) blue:(arc4random_uniform(255)/255.0) alpha:1];
    SingleModel *single = self.tList[indexPath.item];
    NSString *tname = single.tname;
    CGSize textSize = [tname sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 30)];
    [cell.tNameBtn setTitle:tname forState:UIControlStateNormal];
    cell.tNameBtn.bounds = CGRectMake(0, 0, textSize.width + 10, 30);
    cell.bounds = CGRectMake(0, 0, cell.tNameBtn.bounds.size.width + 10, 30);
    NSLog(@"%s", __func__);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SingleModel *single = self.tList[indexPath.item];
    NSString *tname = single.tname;
    CGSize textSize = [tname sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 30)];
//    collectionViewLayout.
//    cell.bounds = CGRectMake(0, 0, cell.tNameBtn.bounds.size.width + 10, 30);
    return textSize;
}


//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"%s", __func__);
    
}
/**
 *  设置ChannelCollectionBar的Layout
 */
- (void)setupChannelLayout {
    self.channelLayout.minimumInteritemSpacing = 0.0;
    self.channelLayout.minimumLineSpacing = 0.0;
    self.channelLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.channelCollection.showsHorizontalScrollIndicator = NO;
    self.channelCollection.showsVerticalScrollIndicator = NO;
}
/**
 *  设置NavigationBar
 */
- (void)setupNavigation {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *headerImage = [UIImage imageNamed:@"home_header_logo"];
    headerImage = [headerImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:headerImage];
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    titleView.bounds = CGRectMake(0, 0, 40, 25);
    self.navigationItem.titleView = titleView;
    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"top_navigation_back"]];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *leftImage = [UIImage imageNamed:@"night_top_navigation_menuicon"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"night_top_navigation_menuicon_highlighted"] forState:UIControlStateHighlighted];
    leftBtn.bounds = CGRectMake(-5, 0, 35, 35);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}



@end
