//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
{
    int hightlight;
}
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, readwrite) CGRect rect;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;

//- (id)showDropDown:(UIButton *)b:(CGFloat *)height:(NSArray *)arr:(NSArray *)imgArr:(NSString *)direction
- (id)showDropDown:(CGRect )b:(CGFloat *)height:(NSArray *)arr:(NSArray *)imgArr:(NSString *)direction:(UIView*)view:(UIColor*)color:(UIButton*)host:(int)preselected
{
    //btnSender = host;
    //self.rect = b;
    hightlight = preselected;
    CGRect temp = b;
    temp.origin.y += color ? 0 : 10;
    b = temp;
    self.rect = b;
    
    self.bgColor = color;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self)
    {
        CGRect btn = self.rect;//b.frame;
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"])
        {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }
        else if ([direction isEqualToString:@"down"])
        {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 0;
        self.layer.shadowRadius = 8;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.showsHorizontalScrollIndicator = NO;
        table.showsVerticalScrollIndicator = NO;
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 0;
        
        table.backgroundColor = color ? color : [UIColor colorWithRed:173/255.0f green:146/255.0f blue:101/255.0f alpha:1];

        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor clearColor];
    
        [UIView animateWithDuration:0.5 animations:^{
        
            if ([direction isEqualToString:@"up"]) {
                self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
            } else if([direction isEqualToString:@"down"]) {
                self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
            }
            table.frame = CGRectMake(0, 0, btn.size.width, *height);
            
        } completion:^(BOOL finish){
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:preselected inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
        [view addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown//:(CGRect )b
{
    //CGRect btn = b.frame;
    CGRect btn = self.rect; //b.frame;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = self.bgColor ? self.bgColor : [UIColor colorWithRed:173/255.0f green:146/255.0f blue:101/255.0f alpha:1];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    cell.textLabel.text =list[indexPath.row][@"name"];
    
    if(imageList.count != 0)
    {
        cell.imageView.image = imageList[indexPath.row];
    }
    
    /*
    if ([self.imageList count] == [self.list count])
    {
        cell.textLabel.text =list[indexPath.row][@"name"];
        cell.imageView.image = imageList[indexPath.row];
    }
    else if ([self.imageList count] > [self.list count])
    {
        cell.textLabel.text =[list objectAtIndex:indexPath.row][@"name"];
        if (indexPath.row < [imageList count])
        {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    }
    else if ([self.imageList count] < [self.list count])
    {
        cell.textLabel.text =[list objectAtIndex:indexPath.row][@"name"];
        if (indexPath.row < [imageList count])
        {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    }
     */

    if(indexPath.row == hightlight)
    {
        cell.textLabel.textColor = [UIColor blueColor];//[UIColor colorWithRed:210/255.0f green:147/255.0f blue:65/255.0f alpha:1]; //210 147 65 ];
    }
    else
    {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if(hightlight < 0)
    {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self hideDropDown:btnSender];
    [self hideDropDown];

    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    //[btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    
//    for (UIView *subview in btnSender.subviews) {
//        if ([subview isKindOfClass:[UIImageView class]]) {
//            [subview removeFromSuperview];
//        }
//    }
    imgView.image = c.imageView.image;
    imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
    imgView.frame = CGRectMake(5, 5, 25, 25);
    //[btnSender addSubview:imgView];
    self.selectedDetails = @{@"title":self.list[indexPath.row],@"indexpath":indexPath};
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate niDropDownDelegateMethod:self];
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

@end
