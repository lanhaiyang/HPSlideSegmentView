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

@interface HPSlideSegmentControllerView ()<UIScrollViewDelegate,HPSlideUpViewDelegate>

@property(nonatomic,strong) HPScrollView *slideScrollerView;
@property(nonatomic,weak) UIScrollView *centreScrollerView;
@property(nonatomic,strong) UIView *slideBackground;


@end

@implementation HPSlideSegmentControllerView

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
     [self creatLayout];
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
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height=self.slideBackgroungView.y;
    
    if (scrollView==self.centreScrollerView) {
        [HPSlideSegmentManage slideUpSegmentWithMainScrollerView:self.slideScrollerView
                                                showScrollerView:self.centreScrollerView
                                                        upHeight:height];
    }
    else
    {
        [HPSlideSegmentManage slidetLogicSrollerView:self.slideScrollerView
                                    showScrollerView:self.centreScrollerView
                                            upHeight:height
                                 slideUpSegmentBlock:^(CGPoint upPoint) {
                                     
                                     self.slideBackgroungView.slideModuleView.y=upPoint.y;
                                     [self.slideBackgroungView addSubview:self.slideBackgroungView.slideModuleView];
                                     
                                 }];
    }

    
}

//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"接触屏幕");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"离开屏幕");
}
-(void)hp_currentMainSlideScrollView:(UIScrollView *)mainSlideScrollView
{
    if (mainSlideScrollView==nil) {
        return;
    }

       [_centreScrollerView removeObserver:self forKeyPath:@"contentOffset"];
    
    _centreScrollerView=mainSlideScrollView;

    
    _centreScrollerView=mainSlideScrollView;
    [_centreScrollerView addObserver:self
                          forKeyPath:@"contentOffset"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
    
    
}


-(void)updateBackgroundHeight:(CGSize)size
{
    CGFloat height=self.slideScrollerView.contentSize.height+size.height;;
    _slideScrollerView.contentSize=CGSizeMake(size.width, height);
    
    _slideBackground.frame=CGRectMake(0, 0, _slideScrollerView.contentSize.width, _slideScrollerView.contentSize.height);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIScrollView *scrollView = (UIScrollView *)object;
    if (self.centreScrollerView == scrollView && [@"contentOffset" isEqualToString:keyPath]) {
        
        [self scrollViewDidScroll:scrollView];
        
    }
}


#pragma mark - 懒加载

-(void)setHeadeView:(UIView *)headeView
{
    _headeView=headeView;
    [self creatLayout];
}

-(HPScrollView *)slideScrollerView
{
    if (_slideScrollerView==nil) {
        _slideScrollerView=[[HPScrollView alloc] init];
        CGFloat y=self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
        _slideScrollerView.frame=CGRectMake(0, y, self.view.width, self.view.height-self.bottomSpaceHeight-y);
        _slideScrollerView.contentSize=CGSizeMake(0, 0);
        _slideScrollerView.delegate=self;
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
        [self.slideBackground addSubview:_slideBackgroungView];
    }
    return _slideBackgroungView;
}

@end
