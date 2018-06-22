//
//  UIViewController+HPNavigationController.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 2018/6/21.
//  Copyright © 2018年 何鹏. All rights reserved.
//

#import "UIViewController+HPNavigationController.h"
#import <objc/runtime.h>

@implementation UIViewController (HPNavigationController)

-(UINavigationController *)hpNavigationController{
    
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]] ) {
            UIViewController *nextVC = (UIViewController *)next;
            
            if (nextVC.navigationController != nil) {
                return nextVC.navigationController;
            }
        }
        
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}


@end
