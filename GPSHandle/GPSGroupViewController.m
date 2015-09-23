//
//  GPSGroupViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/23/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSGroupViewController.h"

@interface GPSGroupViewController ()

@end

@implementation GPSGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initButton];
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
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
