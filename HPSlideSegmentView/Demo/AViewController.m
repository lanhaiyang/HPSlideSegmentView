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

@property(nonatomic,strong) NSMutableArray *dataSouce;

@end

@implementation AViewController


-(instancetype)init
{
    if (self=[super init]) {

        
        [self layout];
        [self createData];
    }
    return self;
}

-(void)layout{
    
    _tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height) style:UITableViewStylePlain];
    
    _tabelView.delegate=self;
    _tabelView.dataSource=self;
    
    [self.view addSubview:_tabelView];
    
}

-(void)createData{
    
    _dataSouce = [NSMutableArray array];
    
    for (int i = 0; i < 15; i ++) {
        [_dataSouce addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [_tabelView reloadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //更新UIViewController上面控件的大小和位置
    _tabelView.frame = CGRectMake(0, 0, self.view.width, self.view.height);

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSouce.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    //这里设置成150
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        //单元格样式设置为UITableViewCellStyleDefault
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",self.titleView,_dataSouce[indexPath.row]];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.backgroundColor=[UIColor grayColor];
    
    return cell;
}

#pragma mark - 删除

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
       return YES;
    }
    return NO;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    
    //删除数据，和删除动画
    [self.dataSouce removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}


@end
