//
//  MHExtendedMenuControl.m
//  Pods
//
//  Created by Mathilde Henriot on 17/07/2015.
//
//

#import "MHExtendedMenuControl.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define Animation_Duration 0.4

@implementation MHExtendedMenuControl {
    BOOL isMenuOpen;
    NSMutableArray *buttonsArray;
    NSArray *imagesArray;
    NSInteger nbrOfButtons;
    int selectedButton;
}

#pragma mark - Public Methods

- (id)initWith:(NSInteger)numberOfButtons buttonsWithImages:(NSArray *)images animation:(MHExtendedMenuAnimation)animation andDelegate:(id)delegate {
    self = [super init];
    if (self) {
        nbrOfButtons = numberOfButtons;
        imagesArray = images;
        [self configureButtons];
        
        self.menuAnimation = animation;
        isMenuOpen = NO;
        
        self.delegate = delegate;
    }
    
    return self;
}

#pragma mark - Private Methods

- (void)configureButtons {
    buttonsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < nbrOfButtons; i++) {
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        buttonView.layer.cornerRadius = 60/2;
        buttonView.layer.shadowColor = [[UIColor blackColor] CGColor];
        buttonView.layer.shadowOffset = CGSizeMake(1, 2);
        buttonView.layer.shadowOpacity = 0.5;
        buttonView.tag = i;
        buttonView.userInteractionEnabled = YES;
        buttonView.clipsToBounds = YES;
        
        UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:buttonView.bounds];
        buttonImageView.image = imagesArray[i];
        buttonImageView.contentMode = UIViewContentModeScaleAspectFit;
        [buttonView addSubview:buttonImageView];
        
        UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(openMenu:)];
        longGestureRecognizer.delegate = self;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectButton:)];
        tapGestureRecognizer.delegate = self;
        
        [buttonView addGestureRecognizer:longGestureRecognizer];
        [buttonView addGestureRecognizer:tapGestureRecognizer];
        
        if (i == 0) {
            [self addSubview:buttonView];
        } else {
            buttonView.alpha = 0;
            [self insertSubview:buttonView belowSubview:[buttonsArray objectAtIndex:i-1]];
        }
        
        [buttonsArray addObject:buttonView];
    }
}

- (void)openMenu:(id)sender {
    
    if (!isMenuOpen) {
        if([sender isKindOfClass:[UILongPressGestureRecognizer class]])
        {
            UILongPressGestureRecognizer *gestureRecognizer = (UILongPressGestureRecognizer *)sender;
            
            if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
                isMenuOpen = YES;
            } else {
                return;
            }
        }
        
        if (isMenuOpen) {
            [UIView beginAnimations:@"rotate" context:nil];
            [UIView setAnimationDuration:Animation_Duration];
            
            switch (self.menuAnimation) {
                case MHExtendedMenuAnimationTop:
                    
                    for (UIView *button in buttonsArray) {
                        button.alpha = 1;
                        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y-80*[buttonsArray indexOfObject:button], button.frame.size.width, button.frame.size.height);
                    }
                    
                    break;
                case MHExtendedMenuAnimationBottom:
                    
                    for (UIView *button in buttonsArray) {
                        button.alpha = 1;
                        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y+80*[buttonsArray indexOfObject:button], button.frame.size.width, button.frame.size.height);
                    }
                    
                    break;
                case MHExtendedMenuAnimationLeft:
                    
                    for (UIView *button in buttonsArray) {
                        button.alpha = 1;
                        button.frame = CGRectMake(button.frame.origin.x-80*[buttonsArray indexOfObject:button], button.frame.origin.y, button.frame.size.width, button.frame.size.height);
                    }
                    
                    break;
                case MHExtendedMenuAnimationRight:
                    
                    for (UIView *button in buttonsArray) {
                        button.alpha = 1;
                        button.frame = CGRectMake(button.frame.origin.x+80*[buttonsArray indexOfObject:button], button.frame.origin.y, button.frame.size.width, button.frame.size.height);
                    }
                    
                    break;
                default:
                    break;
            }
            
            [UIView commitAnimations];
        }
    }
}

- (void)selectButton:(id)sender {
    
    if (isMenuOpen) {
        UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
        selectedButton = (int)tapGesture.view.tag;
        
        [self closeMenu];
        [self bringSubviewToFront:tapGesture.view];
        
        [self.delegate didSelectButton:(int)tapGesture.view.tag];
    } else {
        [self.delegate didTapMenu];
    }
}

- (void)closeMenu {
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:Animation_Duration];
    
    for (UIView *button in buttonsArray) {
        if ([buttonsArray indexOfObject:button] != selectedButton) {
            button.alpha = 0;
        }
        
        button.frame = ((UIView *)buttonsArray[0]).frame;
    }
    
    [UIView commitAnimations];
    
    isMenuOpen = NO;
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end
