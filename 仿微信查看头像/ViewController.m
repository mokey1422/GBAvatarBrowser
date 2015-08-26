//
//  ViewController.m
//  仿微信查看头像
//
//  Created by 张国兵 on 15/8/9.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "ViewController.h"
#import "GBAvatarBrowser.h"
@interface ViewController (){
    UIImageView*icon;
    UIButton*iconBtn;
    GBAvatarBrowser*_myShower;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //button
    iconBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame=CGRectMake(100, 100, 100, 100);
    [iconBtn setImage:[UIImage imageNamed:@"0.jpg"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:iconBtn];
    //imageView
    icon=[[UIImageView alloc]initWithFrame:CGRectMake(100,250 , 100, 100)];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTap:)];
    [icon addGestureRecognizer:tap];
    icon.userInteractionEnabled=YES;
    icon.image=[UIImage imageNamed:@"0.jpg"];
    [self.view addSubview:icon];
    //创建单例项
    _myShower=[GBAvatarBrowser shareInstance];


    
}
#pragma mark-查看头像
-(void)buttonClick{
    
    [_myShower showImage:iconBtn];
    
    
}
-(void)dealTap:(UITapGestureRecognizer*)tap{
    
    [_myShower showImage:icon];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
