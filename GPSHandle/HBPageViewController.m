//
//  HBPageViewController.m
//  HBPageViewController
//
//  Created by hussein bawab on 10/11/14.
//  Copyright (c) 2014 Hussein Bawab. All rights reserved.
//

#import "HBPageViewController.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface HBPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIScrollView *picker;
@property (nonatomic, strong) UIViewController* parent;
@end

@implementation HBPageViewController
{
    NSInteger currentSelectedPickerButton;
    float startingPageScrollViewContentOffsetX;
    BOOL gestureDrivenTransition;
}

@synthesize staticPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithParentViewController:(UIViewController *)parent
{
    self = [super init];
    
    if (self)
    {
        _parent = parent;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_parent.navigationController.navigationBar.translucent)
    {
        [self.view setFrame:CGRectMake(0, 64 + _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height- 64 - _pickerHeight)];
    }
    else
    {
        [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height -_pickerHeight)];
    }
    
    if(!staticPicker)
    {
        [self createPicker];
    }
    else
    {
        [self createStaticPicker];
        [self initLine];
    }
    
    [self createPageViewController];
}

-(void)initLine
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _pickerHeight ? _pickerHeight : 40 - 3, screenWidth / _viewControllers.count, 3)];
    line.tag = 69;
    line.backgroundColor = [UIColor redColor];
    [_picker addSubview:line];
}

- (void)createStaticPicker
{
    if (_pickerHeight)
    {
        _picker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, _pickerHeight)];
    }
    else
    {
        _picker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    }
    
    for (UIViewController* vc in _viewControllers)
    {
        float pickerButtonWidth = screenWidth / _viewControllers.count;
        float pickerButtonHeight = _picker.frame.size.height;
        NSUInteger currentVCIndex = [_viewControllers indexOfObject:vc];
        UIButton *pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(pickerButtonWidth*currentVCIndex, 0, pickerButtonWidth, pickerButtonHeight)];
        [pickerButton setTitle:vc.title forState:UIControlStateNormal];
        [pickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pickerButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        if (_pickerButtonNormalTitleColor)
        {
            [pickerButton setTitleColor:_pickerButtonNormalTitleColor forState:UIControlStateNormal];
        }
        if (_pickerButtonSelectedTitleColor)
        {
            [pickerButton setTitleColor:_pickerButtonSelectedTitleColor forState:UIControlStateSelected];
        }
        if (_pickerButtonTitleFont)
        {
            [pickerButton.titleLabel setFont:_pickerButtonTitleFont];
        }
        if (_pickerButtonTintColor)
        {
            [pickerButton setTintColor:_pickerButtonTintColor];
        }
        [pickerButton setTag:currentVCIndex];
        [pickerButton addTarget:self action:@selector(pickerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_picker addSubview:pickerButton];
    }
    [self.view addSubview:_picker];
    
    [[_picker.subviews firstObject] setSelected:YES];
    
    currentSelectedPickerButton = 0;
}

- (void)createPicker
{
    if (_pickerHeight)
    {
        _picker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, _pickerHeight)];
    }
    else
    {
        _picker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    }
    
    for (UIViewController* vc in _viewControllers)
    {
        float pickerButtonWidth = screenWidth / 3;
        float pickerButtonHeight = _picker.frame.size.height;
        NSUInteger currentVCIndex = [_viewControllers indexOfObject:vc];
        UIButton *pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(pickerButtonWidth*currentVCIndex, 0, pickerButtonWidth, pickerButtonHeight)];
        [pickerButton setTitle:vc.title forState:UIControlStateNormal];
        [pickerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [pickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        if (_pickerButtonNormalTitleColor)
        {
            [pickerButton setTitleColor:_pickerButtonNormalTitleColor forState:UIControlStateNormal];
        }
        if (_pickerButtonSelectedTitleColor)
        {
            [pickerButton setTitleColor:_pickerButtonSelectedTitleColor forState:UIControlStateSelected];
        }
        if (_pickerButtonTitleFont)
        {
            [pickerButton.titleLabel setFont:_pickerButtonTitleFont];
        }
        if (_pickerButtonTintColor)
        {
            [pickerButton setTintColor:_pickerButtonTintColor];
        }
        [pickerButton setTag:currentVCIndex];
        [pickerButton addTarget:self action:@selector(pickerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_picker addSubview:pickerButton];
    }
    
    if (_pickerBackgroundColor)
    {
        [_picker setBackgroundColor:_pickerBackgroundColor];
    }
    
    if (_pickerBackgroundImage)
    {
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _picker.frame.size.width, _picker.frame.size.height)];
        [backgroundImage setImage:_pickerBackgroundImage];
        [_picker addSubview:backgroundImage];
    }
    
    if (_enablePickerChin)
    {
        UIView *chin;
        
        if (_pickerChinSize.height > 0 && _pickerChinSize.width > 0) {
            chin = [[UIView alloc] initWithFrame:CGRectMake(_picker.frame.size.width/2 - _pickerChinSize.width/2, _picker.frame.size.height - _pickerChinSize.height, _pickerChinSize.width, _pickerChinSize.height)];
        } else{
            chin = [[UIView alloc] initWithFrame:CGRectMake(_picker.frame.size.width/2 - _picker.frame.size.width/8, _picker.frame.size.height-2, _picker.frame.size.width/4, 2)];;
        }
        
        if (_pickerChinColor)
        {
            [chin setBackgroundColor:_pickerChinColor];
        }
        else
        {
            [chin setBackgroundColor:[UIColor blackColor]];
        }
        
        [self.view addSubview:chin];
    }
    
    [_picker setScrollEnabled:NO];
    
    startingPageScrollViewContentOffsetX = -((_picker.frame.size.width/2) - ((screenWidth/3)/2));

    [_picker setContentOffset:CGPointMake(startingPageScrollViewContentOffsetX, 0)];
    
    [self.view addSubview:_picker];
    
    [[_picker.subviews firstObject] setSelected:YES];
    
    currentSelectedPickerButton = 0;
}

- (void)createPageViewController
{
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [_pageViewController setViewControllers:@[[_viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [_pageViewController.view setFrame:CGRectMake(0, _picker.frame.size.height, screenWidth, self.view.frame.size.height - _picker.frame.size.height)];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    [(UIScrollView*)[_pageViewController.view.subviews firstObject] setDelegate:self];
    for (UIScrollView *view in self.pageViewController.view.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            view.scrollEnabled = !staticPicker;
        }
    }
    [self.view addSubview:_pageViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)pickerButtonTapped:(UIButton*)sender
{
    if(!staticPicker)
    {
        [_picker setContentOffset:CGPointMake(-((_picker.frame.size.width/2) - ((screenWidth/3)/2)) + (((_picker.frame.size.width/2) - ((screenWidth/3)/2)) * sender.tag), 0) animated:YES];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^(){
            CGPoint p = ((UIView*)[_picker viewWithTag:69]).center;
            p.x = sender.center.x;
            ((UIView*)[_picker viewWithTag:69]).center = p;
        }];
    }
    [[_picker.subviews objectAtIndex:currentSelectedPickerButton] setSelected:NO];
    
    if (currentSelectedPickerButton < sender.tag)
    {
        [_pageViewController setViewControllers:@[[_viewControllers objectAtIndex: !staticPicker ? (currentSelectedPickerButton + 1) : sender.tag]]/*arr*/ direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    else if (currentSelectedPickerButton > sender.tag)
    {
        [_pageViewController setViewControllers:@[[_viewControllers objectAtIndex:!staticPicker ? (currentSelectedPickerButton - 1) : sender.tag]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    
    currentSelectedPickerButton = sender.tag;
    
    [sender setSelected:YES];
}

-(void)gotoPage:(int)index
{
    UIPageViewControllerNavigationDirection direction;
    if(currentSelectedPickerButton <= index)
    {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    else
    {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    
    if(currentSelectedPickerButton < index)
    {
        for (int i = 0; i <= index; i++)
        {
            if (i == index)
            {
                [self.pageViewController setViewControllers:@[_viewControllers[index]]
                                                  direction:direction
                                                   animated:YES
                                                 completion:nil];
            }
            else
            {
                [self.pageViewController setViewControllers:@[_viewControllers[index]]
                                                  direction:direction
                                                   animated:YES
                                                 completion:nil];
                
            }
        }
    }
    else
    {
        for (int i = currentSelectedPickerButton; i >= index; i--)
        {
            if (i == index) {
                [self.pageViewController setViewControllers:@[_viewControllers[index]]
                                                  direction:direction
                                                   animated:YES
                                                 completion:nil];
            }
            else
            {
                [self.pageViewController setViewControllers:@[_viewControllers[index]]
                                                  direction:direction
                                                   animated:YES
                                                 completion:nil];
                
            }
        }
    }
    
    currentSelectedPickerButton = index;
}


- (void)configurePickerButtonsWithNextButton:(int)buttonTag
{
    if(!staticPicker)
    {
        [_picker setContentOffset:CGPointMake(-((_picker.frame.size.width/2) - ((screenWidth/3)/2)) + (((_picker.frame.size.width/2) - ((screenWidth/3)/2)) * buttonTag), 0) animated:YES];
    }
    [[_picker.subviews objectAtIndex:currentSelectedPickerButton] setSelected:NO];
    
    currentSelectedPickerButton = buttonTag;
    
    [[_picker.subviews objectAtIndex:buttonTag] setSelected:YES];
}

#pragma mark -  UIPageViewControllerDatasource Methods
- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = !staticPicker ? [_viewControllers indexOfObject:viewController] : currentSelectedPickerButton;
    
    if (index == 0)
    {
        return nil;
    }
    else
    {
        return (UIViewController*)[_viewControllers objectAtIndex:(index - 1)];
    }
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = !staticPicker ? [_viewControllers indexOfObject:viewController] : currentSelectedPickerButton;
    
    if (index == _viewControllers.count - 1)
    {
        return nil;
    }
    else
    {
        return (UIViewController*)[_viewControllers objectAtIndex:(index + 1)];
    }
}

#pragma mark - UIPageViewControllerDelegate Methods
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        [self pickerButtonTapped:(UIButton*)[_picker.subviews objectAtIndex:[_viewControllers indexOfObject:[[pageViewController viewControllers] firstObject]]]];
    }
    gestureDrivenTransition = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    gestureDrivenTransition = YES;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (gestureDrivenTransition)
    {
        if (scrollView.contentOffset.x != screenWidth)
        {
            float newWidth = startingPageScrollViewContentOffsetX + (((_picker.frame.size.width * currentSelectedPickerButton) + (scrollView.contentOffset.x - screenWidth))/3);
            
            if ((scrollView.contentOffset.x - screenWidth) == scrollView.frame.size.width/2)
            {
                
            }
            if(!staticPicker)
            {
                [_picker setContentOffset:CGPointMake(newWidth, 0)];
            }
        }
    }
}

@end
