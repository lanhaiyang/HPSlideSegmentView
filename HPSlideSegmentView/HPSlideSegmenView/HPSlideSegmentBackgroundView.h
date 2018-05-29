//
//  HPSlideSegmentBackgroundView.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/13.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPSlideSegmentView.h"
#import "HPSlideModuleView.h"
@class HPSlideSegmentBackgroundView;

@protocol HPSlideSegmentBackgroundDataSource <NSObject>


/**
 数据源

 @return 数据源的个数
 */
-(NSUInteger)hp_slideListWithCount;

@end

@protocol HPSlideSegmentBackgroundViewState

/*
 
 监听 视图的状态 传递给子视图
 
 */

- (void)hp_viewWillAppear:(BOOL)animated;
- (void)hp_viewDidAppear:(BOOL)animated;
- (void)hp_viewWillDisappear:(BOOL)animated;
- (void)hp_viewDidDisappear:(BOOL)animated;

@end

@interface HPSlideSegmentBackgroundView : UIView<HPSlideSegmentBackgroundViewState>

@property(nonatomic,weak) id<HPSlideSegmentBackgroundDataSource> dataSource;


/**
 滑块view
 */
@property(nonatomic,strong) HPSlideModuleView *slideModuleView;


/**
 左右滑动的view
 */
@property(nonatomic,strong) HPSlideSegmentView *slideSegmenView;


/**
 Button显示的内容
 
 一定要是NSString 不能为 Swift String
 */
@property(nonatomic,weak) NSArray<NSString *> *contents;


/**
 slideModuleView 的高度
 */
@property(nonatomic,assign) CGFloat slideModuleViewHeight;


/**
 更新布局
 */
-(void)updateLayout;


/**
 更新位置

 @param index 对应的位置
 */
-(void)updateLayoutWithIndex:(NSUInteger)index;

@end
