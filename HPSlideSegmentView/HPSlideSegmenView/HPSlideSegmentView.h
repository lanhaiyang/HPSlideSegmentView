//
//  HPSlideSegmentView.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/12.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPSlideModel;

@protocol HPSlideSegmentViewDataSouce <NSObject>


/**
 设置滑动内容

 @param slideSegmentView slideSegmentView 传入对应的ViewController 和 ViewController上面继承scrollview的对象
 @param index index 对应的index
 @return 显示的ViewController
 */
-(UIViewController *)hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index;


@end

@protocol HPSlideSegmentViewDelegate <NSObject>


/**
 监听当前和准备到达的index

 @param nowIndex 当前的index
 @param readyIndex 准备到达的index
 @param movePercent nowIndex到达readyIndex 的进度
 */
-(void)hp_slideWithNowIndex:(NSUInteger)nowIndex readyIndex:(NSUInteger)readyIndex movePercent:(CGFloat)movePercent;

@end

@protocol HPSlideUpViewDelegate <NSObject>



/**
 获取当前显示view上面显示的mainScrollview

 @param mainSlideScrollView 存储当前显示的mainScrollview
 */
-(void)hp_currentMainSlideScrollView:(UIScrollView *)mainSlideScrollView;

@end

@protocol HPSlideUpViewGestureClashDelegate <NSObject>


/**
 防止手势冲突

 @param gesture 返回当左右滑动时停止 多手势返回NO 当上下滑动时返回YES
 */
-(void)hp_slideWithGestureClash:(BOOL)gesture;



@end

@interface HPSlideSegmentView : UIView

@property(nonatomic,weak) id<HPSlideSegmentViewDataSouce> dataSource;
@property(nonatomic,weak) id<HPSlideSegmentViewDelegate> delegate;
@property(nonatomic,weak) id<HPSlideUpViewDelegate> upDelegate;
@property(nonatomic,weak) id<HPSlideUpViewGestureClashDelegate> gestrueClashDelegate;


/**
 当期正在现在的ViewController
 */
@property(nonatomic,strong,readonly) UIViewController *currentViewController;

/**
 缓存个数
 小于3默认为3
 */
@property(nonatomic,assign) NSUInteger cacheMaxCount;

/**
 更新布局
 */
-(void)updateLayout;


/**
 更新布局

 @param arrayCount 当前数据源的个数
 */
-(void)updateScrollerViewWidthWidth:(NSUInteger)arrayCount;


/**
 更新 对应的index

 @param pageIndex 对应的index
 */
-(void)updateLayout:(NSUInteger)pageIndex;


/**
 更新 对应的index
 
 @param pageIndex 对应的index
 @param update 是否需要更新代理
 */
-(void)updateLayout:(NSUInteger)pageIndex updateDelegate:(BOOL)update;




@end

typedef void (^InitWithActionBlock)(HPSlideModel *model);

@interface HPSlideModel : UIView



/**
 通过类名创建ViewController对象

 @param className  ViewController类名
 @param actionBlock init 后需要执行的操作
 @return 返回按类名创建的对象
 */
-(id)cacheWithClass:(Class)className initAction:(InitWithActionBlock)actionBlock;


/**
 通过UIStoryboard创建ViewController对象

 @param storyboard ViewController 的 storyboard
 @param identifier UIStoryboard iidentifier
 @return 返回创建的对象
 */
-(id)cacheWithStoryboard:(UIStoryboard *)storyboard identifier:(NSString *)identifier ;


@end
