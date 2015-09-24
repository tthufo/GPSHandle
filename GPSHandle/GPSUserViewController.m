//
//  GPSUserViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/23/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSUserViewController.h"

@interface GPSUserViewController ()<UIScrollViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray * dataList;
}

@end

@implementation GPSUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initButton];
    
    dataList =  [@[[@{@"name":@"wat the name",@"active":@(0),@"on":@(1)} mutableCopy],[@{@"name":@"name the wat",@"active":@(0),@"one":@(0)} mutableCopy]] mutableCopy];
}

-(void)initButton
{
    NSArray * title = @[@"Add",@"Edit",@"Delete"];
    for(int i = 0; i < 3; i++)
    {
        UIButton * bar = [UIButton buttonWithType:UIButtonTypeCustom];
        bar.tag = i;
        [bar addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [bar setImage:kAvatar forState:UIControlStateNormal];
        bar.frame = CGRectMake(i * screenWidth / 3, 3, screenWidth / 3, 50);
        [[self.view viewWithTag:11] addSubview:bar];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(i * screenWidth / 3, 15, 1, 40)];
        line.backgroundColor = [UIColor darkGrayColor];
        if(i != 0) [[self.view viewWithTag:11] addSubview:line];
        
        UILabel * titles = [[UILabel alloc] initWithFrame:CGRectMake(i * screenWidth / 3, 45, screenWidth / 3, 20)];
        titles.textAlignment = NSTextAlignmentCenter;
        titles.text = title[i];
        [[self.view viewWithTag:11] addSubview:titles];
    }
}

-(void)didPressButton:(id)sender
{
    switch (((UIButton*)sender).tag)
    {
        case 0:
            
            break;
        case 1:
        {
            [self didPressEdit];
        }
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

-(void)didPressEdit
{
    if([self isActive])
    {
        
        UIScrollView * scrollr = [[NSBundle mainBundle] loadNibNamed:@"GPSCell" owner:nil options:nil][1];
////        [scroll setDelegate:self];
        scrollr.frame = CGRectMake(0, 0, tableView.frame.size.width - 0, 445);
//        [scroll setContentSize:CGSizeMake(tableView.frame.size.width, 445)];
//
//        [self.view addSubview:scroll];
//        
//        [scroll setContentOffset:CGPointMake(100, 200) animated:YES];
//        
//        [UIView animateWithDuration:0.3 animations:^(){
//        
//            
//        }];
        
        UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableView.frame.size.height)];
        
//        for(int i = 0; i< 3; i++)
//        {
//            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(i * screenWidth, 0, screenWidth, 200)];
//            img.image = kAvatar;
//            [scroll addSubview:img];
//        }
        [scroll addSubview:scrollr];
        [scroll setContentSize:CGSizeMake(screenWidth, 445)];
        [self.view addSubview:scroll];
    }
    else
    {
        [[ChopeToastView toastViewWithMessage:@"Choose one cell"] show];
    }
}

-(void)didPressUser:(UIButton*)sender
{
    for(NSMutableDictionary * dict in dataList)
    {
        if([dataList indexOfObject:dict] == [self inDexOf:sender andTable:tableView])
        {
            dict[@"active"] = [dict[@"active"] boolValue] ? @(0) : @(1);
        }
        else
        {
            dict[@"active"] = @(0);
        }
    }
    [tableView reloadDataWithAnimation:YES];
}

-(void)didPressUserSwitch:(UISwitch*)sender
{
    int index = [self inDexOf:sender andTable:tableView];
    dataList[index][@"on"] = [dataList[index][@"on"] boolValue] ? @(0) : @(1);
}

- (void)didSetUpCellWithInfo:(UITableViewCell*)cell withInfo:(NSDictionary*)dict
{
    UIButton * buttton = ((UIButton*)[self withView:cell tag:10]);
    [buttton addTarget:self action:@selector(didPressUser:) forControlEvents:UIControlEventTouchUpInside];
    ((UILabel*)[self withView:cell tag:11]).text = dict[@"name"];
    [((UILabel*)[self withView:cell tag:12]) withBorder:@{@"Bcolor":[UIColor redColor],@"Bcorner":@(25),@"Bwidth":@(1)}];
    for(UIView * v in cell.contentView.subviews)
    {
        if(v.tag != 0)
        {
            v.hidden = ![dict[@"active"] boolValue];
        }
    }
    UISwitch * switchT = ((UISwitch*)[self withView:cell tag:96]);
    switchT.on = [dict[@"on"] boolValue];
    [switchT addTarget:self action:@selector(didPressUserSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ![dataList[indexPath.row][@"active"] boolValue] ? 60 : 373;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GPSCell" owner:nil options:nil][0];
    }
    if(dataList.count != 0)
    {
        [self didSetUpCellWithInfo:cell withInfo:dataList[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(BOOL)isActive
{
    for(NSDictionary * dict in dataList)
    {
        if([dict[@"active"] boolValue])
        {
            return YES;
            break;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
