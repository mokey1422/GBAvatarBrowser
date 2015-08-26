//
//  GBAvatarBrowser.m
//  仿微信查看头像
//
//  Created by 张国兵 on 15/8/9.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBAvatarBrowser.h"
#define  kWidth   [UIScreen mainScreen].bounds.size.width
#define  kHeight  [UIScreen mainScreen].bounds.size.height

@interface GBAvatarBrowser ()<UIScrollViewDelegate>{

     CGRect oldframe;
     BOOL doubleClick;
    
}
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIScrollView *mainScrollView;
@end
@implementation GBAvatarBrowser
+ (id)shareInstance
{
    //此种单例创建优点
    //1. 线程安全。
    //2. 满足静态分析器的要求。
    //3. 兼容了ARC
    
    static GBAvatarBrowser *avatarBrowser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avatarBrowser = [[self alloc]init];
        
    });
    return avatarBrowser;
}

-(void)showImage:(UIView*)avatar{
    UIImage *image;
     doubleClick=YES;
    if(avatar&&[avatar isKindOfClass:[UIButton class]])
    {
        UIButton*tempBtn=(UIButton*)avatar;
        image=tempBtn.currentImage;

    }else if (avatar&&[avatar isKindOfClass:[UIImageView class]])
        
    {
        UIImageView*tempImage=(UIImageView*)avatar;
        image=tempImage.image;
    
    }

    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    //将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    oldframe=[avatar convertRect:avatar.bounds toView:window];
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.mainScrollView.contentSize = CGSizeMake(kWidth,kHeight);
    self.mainScrollView.bounces = YES;
    self.mainScrollView.pagingEnabled = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    //设置最小伸缩比和最大伸缩比
    self.mainScrollView.minimumZoomScale = 1.0;
    self.mainScrollView.maximumZoomScale = 2.0;
    self.mainScrollView.backgroundColor=[UIColor blackColor];
    self.mainScrollView.alpha=1;
    self.mainScrollView.userInteractionEnabled=YES;
    [window addSubview:self.mainScrollView];
    
    _imageView=[[UIImageView alloc]initWithFrame:oldframe];
    _imageView.image=image;
    _imageView.userInteractionEnabled=YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainScrollView addSubview:_imageView];
   
    UITapGestureRecognizer *oneTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [_imageView addGestureRecognizer: oneTap];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapBig:)];
    doubleTap.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:doubleTap];
    //[A requireGestureRecognizerToFail:B]函数,它可以指定当A手势发生时,即便A已经滿足条件了,也不会立刻触发,会等到指定的手势B确定失败之后才触发。--->双击的优先级高于单击
    [oneTap requireGestureRecognizerToFail:doubleTap];
    
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        self.mainScrollView.alpha=1;
    } completion:^(BOOL finished) {

        
    }];
}
-(void)doubleTapBig:(UITapGestureRecognizer*)doubleTap{
    
    CGFloat newscale =1.9;

    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[doubleTap locationInView:doubleTap.view] andScrollView:self.mainScrollView];
    
    if (doubleClick == YES)  {
        
        [self.mainScrollView zoomToRect:zoomRect animated:YES];
    }
    else {
        [self.mainScrollView setZoomScale:1.0f animated:YES];
    }
    doubleClick = !doubleClick;

}
- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
    
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
//告诉scrollView哪个控件是可以缩放的
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
   
    
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.frame=oldframe;
        self.mainScrollView.alpha=0;
    } completion:^(BOOL finished) {
        
        [self.mainScrollView removeFromSuperview];
       
    }];
}

@end
