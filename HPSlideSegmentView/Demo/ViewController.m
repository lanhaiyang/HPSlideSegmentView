//
//  ViewController.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/10.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "ViewController.h"
#import "HPSlideSegmentBackgroundView.h"
#import "AViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<HPSlideSegmentBackgroundDataSource,HPSlideSegmentViewDataSouce,SlideModuleViewDelegate>

@property(nonatomic,strong) NSArray<NSString *> *dataSouce;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HPSlideSegmentBackgroundView *slideSegmentBackgroundView=[[HPSlideSegmentBackgroundView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];

    slideSegmentBackgroundView.slideModuleViewHeight = 50;
    slideSegmentBackgroundView.dataSource=self;
    slideSegmentBackgroundView.slideSegmenView.dataSource=self;
    slideSegmentBackgroundView.contents=self.dataSouce;
    slideSegmentBackgroundView.slideModuleView.delegate = self;
//    slideSegmentBackgroundView.slideModuleView.hiddenModule = YES;
    [self.view addSubview:slideSegmentBackgroundView];
    
}






-(NSUInteger)hp_slideListWithCount
{
    return self.dataSouce.count;
}

-(UIViewController *)hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index
{
    AViewController *aViewController=[[AViewController alloc] init];

    aViewController.titleView=self.dataSouce[index];
    return aViewController;
}

-(NSArray *)dataSouce
{
    if (_dataSouce==nil) {
        _dataSouce=@[@"B",@"C",@"BBBB",@"AAAAA",@"CCCCCC",@"dddddd",@"uuu",@"iii",@"A",@"B",@"C",@"BBBB",@"AAAAA",@"CCCCCC",@"dddddd",@"uuu",@"iii",@"A",@"B",@"C",@"BBBB",@"AAAAA",@"CCCCCC",@"dddddd",@"uuu",@"iii"];
    }
    return _dataSouce;
}

#pragma mark - SlideModuleViewDelegate

/**
 Button内容的设置
 
 @param index 位置
 @return 显示的内容
 */
-(NSString *)hp_slideContentWithIndex:(NSUInteger)index{
    
    return _dataSouce[index];
    
}


/**
 自定义button
 
 @param index 位置
 @return 返回设置的button
 */
-(UIButton *)hp_slideWithIndex:(NSUInteger)index{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    
    return button;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
