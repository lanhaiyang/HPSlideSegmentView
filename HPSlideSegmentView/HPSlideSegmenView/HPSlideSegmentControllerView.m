//
//  HPSlideSegmentView.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/11.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPSlideSegmentControllerView.h"
#import "UIView+HPSlideSegmentRect.h"
#import "HPSlideSegmentManage.h"
#import "HPScrollView.h"


@interface HPSlideSegmentControllerView ()<UIScrollViewDelegate,HPSlideUpViewDelegate,HPSlideUpViewGestureClashDelegate>

@property(nonatomic,strong) HPScrollView *slideScrollerView;
@property(nonatomic,weak) UIScrollView *centreScrollerView;
@property(nonatomic,strong) UIView *slideBackground;

@property(nonatomic,assign) CGFloat autoTopHeight;

@property(nonatomic,assign) BOOL statcStyle;
@property(nonatomic,assign) BOOL isLeftAndRightSlide;

@property(nonatomic,assign) CGFloat slideOffsetY;
@property(nonatomic,assign) CGFloat childOffsetY;

@end

@implementation HPSlideSegmentControllerView

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bottomSpaceHeight=_bottomSpaceHeight;
    
}

-(void)creatLayout
{
    if (self.headeView==nil) {
        return;
    }
    
    [self.headeView layoutIfNeeded];
    
    if (self.headeViewHeight==0) {
        self.headeViewHeight=self.headeView.bounds.size.height;
    }
    
    self.headeView.frame=CGRectMake(0, 0, self.slideScrollerView.width, self.headeViewHeight);
    [self.slideBackground addSubview:self.headeView];
    [self updateBackgroundHeight:CGSizeMake(self.slideScrollerView.width, self.headeView.height)];
    

    [self updateBackgroundHeight:CGSizeMake(self.slideScrollerView.width, self.slideBackgroungView.height)];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.statcStyle==NO) {
        
        self.autoTopHeight=self.slideScrollerView.contentOffset.y;
        self.statcStyle=YES;
    }
    
}


-(void)hp_slideWithGestureClash:(BOOL)gesture
{
    if (gesture==NO  && self.isLeftAndRightSlide==NO) {
        
        _slideOffsetY=self.slideScrollerView.contentOffset.y;
        _childOffsetY=self.centreScrollerView.contentOffset.y;
        self.isLeftAndRightSlide=YES;
    }
    else if (gesture==YES)
    {
        self.isLeftAndRightSlide=NO;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_isLeftAndRightSlide==YES) {
        
        if (scrollView==self.centreScrollerView && self.centreScrollerView.contentOffset.y!=_childOffsetY) {
            self.centreScrollerView.contentOffset=CGPointMake(self.centreScrollerView.contentOffset.x, _childOffsetY);
            
        }
        else if(self.slideScrollerView.contentOffset.y!=_slideOffsetY)
        {
            self.slideScrollerView.contentOffset=CGPointMake(self.slideScrollerView.contentOffset.x, _slideOffsetY);
        }
        
        return;
        
    }
    
    CGFloat height=self.slideBackgroungView.y+self.autoTopHeight;
    

    
    [[HPSlideSegmentManage sharedSlideManage] slideUpSegmentWithMainScrollerView:self.slideScrollerView
                                            showScrollerView:self.centreScrollerView
                                                    upHeight:height];

    [HPSlideSegmentManage slidetLogicSrollerView:self.slideScrollerView
                                showScrollerView:self.centreScrollerView
                                        upHeight:height
                             slideUpSegmentBlock:^(CGPoint upPoint) {
                                 
                                 self.slideBackgroungView.slideModuleView.y=upPoint.y;
                                 [self.slideBackgroungView addSubview:self.slideBackgroungView.slideModuleView];
                                 
                             }];
}

//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"接触屏幕");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    NSLog(@"离开屏幕");
}

-(void)hp_currentMainSlideScrollView:(UIScrollView *)mainSlideScrollView
{
    _centreScrollerView=mainSlideScrollView;
    
    [self scrollViewDidScroll:_centreScrollerView];
    
}


-(void)updateBackgroundHeight:(CGSize)size
{
    CGFloat height=self.slideScrollerView.contentSize.height+size.height;;
    _slideScrollerView.contentSize=CGSizeMake(size.width, height);
    
    _slideBackground.frame=CGRectMake(0, 0, _slideScrollerView.contentSize.width, _slideScrollerView.contentSize.height);
}

#pragma mark - 懒加载

-(void)setBottomSpaceHeight:(CGFloat)bottomSpaceHeight
{
    _bottomSpaceHeight=bottomSpaceHeight;
    _slideScrollerView.contentSize=CGSizeMake(_slideScrollerView.width, 0);
    _slideScrollerView.frame=CGRectMake(0, 0, self.view.width, self.view.height-bottomSpaceHeight);
    _slideBackground.frame=CGRectMake(0, 0, self.slideScrollerView.width, self.slideScrollerView.height);
    [self creatLayout];
}

-(void)setHeadeView:(UIView *)headeView
{
    _headeView=headeView;
    self.bottomSpaceHeight=_bottomSpaceHeight;
}

-(HPScrollView *)slideScrollerView
{
    if (_slideScrollerView==nil) {
        
        _slideScrollerView=[[HPScrollView alloc] init];
        _slideScrollerView.frame=CGRectMake(0, 0, self.view.width, self.view.height);
        _slideScrollerView.contentSize=CGSizeMake(0, 0);
        _slideScrollerView.delegate=self;
        _slideScrollerView.bounces=NO;
        _slideScrollerView.showsVerticalScrollIndicator=NO;
        _slideScrollerView.showsHorizontalScrollIndicator=NO;
        [self.view addSubview:_slideScrollerView];
    }
    return _slideScrollerView;
}

-(UIView *)slideBackground
{
    if (_slideBackground==nil) {
        _slideBackground=[[UIView alloc] init];
        _slideBackground.backgroundColor=[UIColor whiteColor];
        _slideBackground.frame=CGRectMake(0, 0, self.slideScrollerView.width, self.slideScrollerView.height);
        [self.slideScrollerView addSubview:_slideBackground];
    }
    return _slideBackground;
}

-(HPSlideSegmentBackgroundView *)slideBackgroungView
{
    if (_slideBackgroungView==nil) {
        CGFloat y=self.headeView.height;
        _slideBackgroungView=[[HPSlideSegmentBackgroundView alloc] initWithFrame:CGRectMake(0, y, self.slideScrollerView.width,self.view.height)];
        _slideBackgroungView.frame=CGRectMake(0, y, _slideBackgroungView.width, _slideBackgroungView.slideSegmenView.y+_slideBackgroungView.slideSegmenView.height);
        _slideBackgroungView.slideSegmenView.upDelegate=self;
        _slideBackgroungView.slideSegmenView.gestrueClashDelegate=self;
        [self.slideBackground addSubview:_slideBackgroungView];
    }
    return _slideBackgroungView;
}

@end
