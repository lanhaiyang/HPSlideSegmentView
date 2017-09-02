//
//  HPSlideManage.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/14.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SlideUpSegmentBlock)(CGPoint upPoint);

@protocol HPSlideSegmentManageDelegate <NSObject>

-(void)hp_slideUpSegmentWithMain:(BOOL)gesture;

@end


@interface HPSlideSegmentManage : UIView


+ (instancetype)sharedSlideManage;

/**
 次scrollview的逻辑

 @param mainScrollerView 主的scrollview
 @param centreScrollerView 次scrollview
 @param topHeight 左右滑动view距离头部的高度
 */
-(void)slideUpSegmentWithMainScrollerView:(UIScrollView *)mainScrollerView
                         showScrollerView:(UIScrollView *)centreScrollerView
                                 upHeight:(CGFloat)topHeight
                                 delegate:(id<HPSlideSegmentManageDelegate>) delegate;


/**
 主scrollview的逻辑

 @param mainScrollerView 主scrollview
 @param centreScrollerView 次scrollview
 @param topHeight 左右滑动view距离头部的高度
 @param upBlock 滑块view的悬浮位置
 */
+(void)slidetLogicSrollerView:(UIScrollView *)mainScrollerView
             showScrollerView:(UIScrollView *)centreScrollerView
                     upHeight:(CGFloat)topHeight
          slideUpSegmentBlock:(SlideUpSegmentBlock)upBlock;


@end
