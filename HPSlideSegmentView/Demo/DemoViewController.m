//
//  DemoViewController.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/26.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "DemoViewController.h"
#import "AViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface DemoViewController ()<HPSlideSegmentBackgroundDataSource,HPSlideSegmentViewDataSouce,SlideModuleViewDelegate>

@property(nonatomic,strong) NSArray<NSString *> *dataSouce;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.headeView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.headeView.backgroundColor=[UIColor blueColor];
//    self.bottomSpaceHeight=60;
//    self.adjustsScrollViewInsets = YES;
    
    self.slideBackgroungView.contents=self.dataSouce;
    self.slideBackgroungView.dataSource=self;
    self.slideBackgroungView.slideModuleViewHeight=50;
    
    self.slideBackgroungView.slideSegmenView.dataSource=self;
    self.slideBackgroungView.slideSegmenView.cacheMaxCount=6;
    
    self.slideBackgroungView.slideModuleView.spaceLine = YES;
    self.slideBackgroungView.slideModuleView.slideModeuleWidth=10;
    self.slideBackgroungView.slideModuleView.edgeInsets=UIEdgeInsetsMake(0, 5, 3, 1);
//    self.slideBackgroungView.slideModuleView.minWidth=SCREEN_WIDTH;
//    self.slideBackgroungView.slideModuleView.type=ENUM_HP_DEFINESIZE;
//    self.slideBackgroungView.slideModuleView.hiddenModule=YES;
    
    [self.slideBackgroungView updateLayout];
    
}


-(NSUInteger)hp_slideListWithCount
{
    return self.dataSouce.count;
}

-(UIViewController *)hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index{
    
    AViewController *aViewController=[slideSegmentView cacheWithClass:[AViewController class] initAction:nil];
    aViewController.titleView = _dataSouce[index];
    return aViewController;
}


-(NSArray *)dataSouce
{
    if (_dataSouce==nil) {
        _dataSouce=@[@"A",@"B",@"C",@"BBBB",@"AAAAA",@"CCCCCC",@"dddddd",@"uuu",@"iii",@"A",@"B",@"C",@"BBBB",@"AAAAA",@"CCCCCC",@"dddddd",@"uuu",@"iii",@"A",@"B",@"C",@"BBBB",@"AAAAA",@"CCCCCC",@"dddddd",@"uuu",@"iii"];
    }
    return _dataSouce;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}

@end
