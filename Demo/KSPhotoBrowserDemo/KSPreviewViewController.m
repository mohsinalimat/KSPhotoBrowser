//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by Kyle Sun on 12/25/15.
//  Copyright © 2015 skx926. All rights reserved.
//

#import "KSPreviewViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YYWebImage.h"

@interface KSPreviewViewController ()

@property (nonatomic, strong) NSArray *urls;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation KSPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _urls = @[@"http://ww2.sinaimg.cn/thumbnail/712a2410gw1fb7m1cqr09j20zg0qo79w.jpg",
              @"http://ww3.sinaimg.cn/thumbnail/712a2410gw1fb7m1dfq5hj20zg0qoafq.jpg",
              @"http://ww2.sinaimg.cn/thumbnail/712a2410gw1fb7m1d7jvdj20qo0zggpi.jpg",
              @"http://ww1.sinaimg.cn/thumbnail/712a2410gw1fb7m1e1wp1j20qo0zgn0q.jpg",
              @"http://ww4.sinaimg.cn/thumbnail/9f493043jw1f7akk8e0cmj28cj1fcb2f.jpg",
              @"http://ww2.sinaimg.cn/thumbnail/712a2410gw1fb7m1ef04vj20zg0qoad1.jpg",
              @"http://ww1.sinaimg.cn/thumbnail/9e3738f9gw1fb7pd37ux6j20c61jrn4t.jpg",
              @"http://ww3.sinaimg.cn/thumbnail/94dfe97bgw1fag0btw49ej20j60lvgpf.jpg"];
    for (int i = 0; i < _imageViews.count; i++) {
        UIImageView *imageView = _imageViews[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView yy_setImageWithURL:[NSURL URLWithString:_urls[i]] options:kNilOptions];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearCache:(id)sender {
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tap {
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < _imageViews.count; i++) {
        KSPhoto *item = [[KSPhoto alloc] init];
        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
        item.imageUrl = [NSURL URLWithString:url];
        UIImageView *imageView = _imageViews[i];
        item.sourceView = _imageViews[i];
        item.thumbImage = imageView.image;
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:tap.view.tag];
    browser.dismissalStyle = _dismissalStyle;
    browser.backgroundStyle = _backgroundStyle;
    browser.loadingStyle = _loadingStyle;
    browser.pageindicatorStyle = _pageindicatorStyle;
    browser.bounces = _bounces;
    [browser showFromViewController:self];
}

@end