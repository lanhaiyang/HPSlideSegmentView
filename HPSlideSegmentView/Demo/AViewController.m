//
//  AViewController.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/24.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "AViewController.h"
#import "UIView+HPSlideSegmentRect.h"

static NSString *ID = @"cell";

@interface AViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation AViewController


-(instancetype)init
{
    if (self=[super init]) {
        _tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height) style:UITableViewStylePlain];
        
        _tabelView.delegate=self;
        _tabelView.dataSource=self;
        
        [self.view addSubview:_tabelView];
    }
    return self;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //更新UIViewController上面控件的大小和位置
    _tabelView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        //单元格样式设置为UITableViewCellStyleDefault
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text=self.titleView;
    cell.textLabel.textColor=[UIColor blackColor];
    cell.backgroundColor=[UIColor grayColor];
    
    return cell;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    //这里设置成150
    return 150;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
