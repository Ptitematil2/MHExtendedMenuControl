//
//  MHViewController.m
//  MHExtendedMenuControl
//
//  Created by Mathilde Henriot on 07/20/2015.
//  Copyright (c) 2015 Mathilde Henriot. All rights reserved.
//

#import "MHViewController.h"
#import "MHExtendedMenuControl.h"

@interface MHViewController () <MHExtendedMenuControlDelegate>

@property (nonatomic, weak) IBOutlet UILabel *selectedSuperheroLabel;

@end

@implementation MHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    int menuSize = 60;
    int numberOfButtons = 3;
    int marginSize = 20;
    int numberOfMargin = 2;
    
    MHExtendedMenuControl *expandableMenu = [[MHExtendedMenuControl alloc] initWith:numberOfButtons buttonsWithImages:@[[UIImage imageNamed:@"Avengers-Black-Widow-icon"], [UIImage imageNamed:@"Avengers-Hawkeye-icon"], [UIImage imageNamed:@"Hopstarter-Superhero-Avatar-Avengers-Nick-Fury"]]  animation:MHExtendedMenuAnimationRight andDelegate:self];
    expandableMenu.frame = CGRectMake(marginSize, CGRectGetMaxY(self.view.frame)-menuSize-marginSize, menuSize*numberOfButtons+marginSize*numberOfMargin, menuSize);
    [self.view addSubview:expandableMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MHExtendedMenuControlDelegate

- (void)didSelectButton:(int)buttonPosition {
    switch (buttonPosition) {
        case 0:
            self.selectedSuperheroLabel.text = @"Black Widow Selected";
            break;
        case 1:
            self.selectedSuperheroLabel.text = @"Hawkeye Selected";
            break;
        case 2:
            self.selectedSuperheroLabel.text = @"Nick Fury Selected";
            break;
        default:
            break;
    }
}

- (void)didTapMenu {
    
}

@end
