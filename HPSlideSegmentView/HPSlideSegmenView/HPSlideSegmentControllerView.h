//
//  HPSlideSegmentView.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/11.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPSlideSegmentBackgroundView.h"

@protocol HPSlideSegmentControllerViewDelegate <NSObject>


/**
 主scrollView 滑动的监听
 
 @param scrollView 主scrollview
 */
-(void)slideWithScrollView:(UIScrollView *)scrollView;

@end

@interface HPSlideSegmentControllerView : UIViewController


@property(nonatomic,weak) id<HPSlideSegmentControllerViewDelegate> delegate;

/**
 头部的UIView
 */
@property(nonatomic,strong) UIView *headeView;


/**
 头部的高度 如果不设置默认为 headerView的的高度
 */
@property(nonatomic,assign) CGFloat headeViewHeight;


/**
 下拉是否可以操出边缘 默认为YES
 */
@property(nonatomic,assign) BOOL topSlideExceedEdge;


/**
 是否需要忽略 导航栏高度 默认为NO
 */
@property(nonatomic,assign) BOOL adjustsScrollViewInsets;

/**
 距离底部的高
 */
@property(nonatomic,assign) CGFloat bottomSpaceHeight;


/**
 左右滑视图
 */
@property(nonatomic,strong) HPSlideSegmentBackgroundView *slideBackgroungView;

@end
