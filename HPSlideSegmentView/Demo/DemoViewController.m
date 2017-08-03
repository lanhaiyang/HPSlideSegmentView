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

@interface DemoViewController ()<HPSlideSegmentBackgroundDataSource,HPSlideSegmentViewDataSouce>

@property(nonatomic,strong) NSArray<NSString *> *dataSouce;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.headeView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.headeView.backgroundColor=[UIColor blueColor];
    
    self.slideBackgroungView.contents=self.dataSouce;
    
    self.slideBackgroungView.dataSource=self;
    self.slideBackgroungView.slideSegmenView.dataSource=self;
    self.slideBackgroungView.slideModuleViewHeight=50;
    self.slideBackgroungView.slideSegmenView.cacheMaxCount=6;
//    self.bottomSpaceHeight=46;//底部高度
    self.slideBackgroungView.slideModuleView.slideModeuleWidth=10;
//    self.slideBackgroungView.slideModuleView.slideModuleColor=[UIColor blueColor];
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 3)];
    view.backgroundColor=[UIColor blueColor];
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=1.5;
    
    self.slideBackgroungView.slideModuleView.slideModuleView=view;
    self.slideBackgroungView.slideModuleView.edgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    self.slideBackgroungView.slideModuleView.minWidth=SCREEN_WIDTH/4;
    self.slideBackgroungView.slideModuleView.type=ENUM_HP_AUTOMINSIZE;
    self.slideBackgroungView.slideModuleView.hiddenModule=NO;
}

-(NSUInteger)hp_slideListWithCount
{
    return self.dataSouce.count;
}

-(void )hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index
{
    AViewController *aViewController=[[AViewController alloc] init];
    
    aViewController.titleView=self.dataSouce[index];
    slideSegmentView.name=self.dataSouce[index];
    slideSegmentView.mainSlideScrollView=aViewController.tabelView;
    slideSegmentView.showViewController=aViewController;
}

-(NSArray *)dataSouce
{
    if (_dataSouce==nil) {
        _dataSouce=@[@"AAAAAAAAAA",@"BBBBB",@"CCC",@"DDD"];
    }
    return _dataSouce;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}

@end
