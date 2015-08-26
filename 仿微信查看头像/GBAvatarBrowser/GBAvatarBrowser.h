//
//  GBAvatarBrowser.h
//  仿微信查看头像
//
//  Created by 张国兵 on 15/8/9.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GBAvatarBrowser : UIView
/**
 *  查看头像
 *
 *  @param avatar 头像一般是button或者是imageview
 */
-(void)showImage:(UIView*)avatar;

+(id)shareInstance;

@end
