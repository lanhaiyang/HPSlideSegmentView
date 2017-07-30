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

@interface ViewController ()<HPSlideSegmentBackgroundDataSource,HPSlideSegmentViewDataSouce>

@property(nonatomic,strong) NSArray<NSString *> *dataSouce;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HPSlideSegmentBackgroundView *slideSegmentBackgroundView=[[HPSlideSegmentBackgroundView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    
    slideSegmentBackgroundView.dataSource=self;
    slideSegmentBackgroundView.slideSegmenView.dataSource=self;
    slideSegmentBackgroundView.contents=self.dataSouce;
    [self.view addSubview:slideSegmentBackgroundView];
    self.view.backgroundColor=[UIColor redColor];
    
}



-(NSUInteger)hp_slideListWithCount
{
    return self.dataSouce.count;
}

-(void )hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index
{
    AViewController *aViewController=[[AViewController alloc] init];
    
    aViewController.titleView=self.dataSouce[index];
    
    slideSegmentView.showViewController=aViewController;
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
    // Dispose of any resources that can be recreated.
}


@end
