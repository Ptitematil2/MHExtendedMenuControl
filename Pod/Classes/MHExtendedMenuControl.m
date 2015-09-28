//
//  MHExtendedMenuControl.m
//  Pods
//
//  Created by Mathilde Henriot on 17/07/2015.
//
//

#import "MHExtendedMenuControl.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define Animation_Duration 0.3

@interface MHExtendedMenuControl () <UIScrollViewDelegate>

@end

@implementation MHExtendedMenuControl {
    
    struct {
        unsigned int willOpenMenu:1;
        unsigned int didOpenMenu:1;
        unsigned int willCloseMenu:1;
        unsigned int didCloseMenu:1;
    } delegateRespondsTo;
    
    BOOL isMenuOpen;
    NSMutableArray *buttonsArray;
    NSArray *imagesArray;
    NSInteger nbrOfButtons;
    int selectedButton;
    CGSize btnSize;
    UIScrollView *channelScrollView;
    
    UIView *mainItem;
}

#pragma mark - Overides

- (void)setDelegate:(id <MHExtendedMenuControlDelegate>)aDelegate {
    if (self.delegate != aDelegate) {
        self->_delegate = aDelegate;
        
        delegateRespondsTo.willOpenMenu = [self.delegate respondsToSelector:@selector(MHExtendedMenuControlWillOpenMenu:)];
        delegateRespondsTo.didOpenMenu = [self.delegate respondsToSelector:@selector(MHExtendedMenuControlDidOpenMenu:)];
        delegateRespondsTo.willCloseMenu = [self.delegate respondsToSelector:@selector(MHExtendedMenuControlWillCloseMenu:)];
        delegateRespondsTo.didCloseMenu = [self.delegate respondsToSelector:@selector(MHExtendedMenuControlDidCloseMenu:)];
    }
}

#pragma mark - Public Methods

- (id)initWith:(NSInteger)numberOfButtons buttonsWithImages:(NSArray *)images withSize:(CGSize)buttonSize animation:(MHExtendedMenuAnimation)animation andDelegate:(id)delegate {
    self = [super init];
    if (self) {
        nbrOfButtons = numberOfButtons;
        imagesArray = images;
        btnSize = buttonSize;
        [self configureButtons];
        
        self.menuAnimation = animation;
        isMenuOpen = NO;
        
        self.delegate = delegate;
    }
    
    return self;
}

- (void)setSelectedButton:(int)buttonIndex {
    if ([buttonsArray count] > buttonIndex) {
        UIButton *button = buttonsArray[buttonIndex];
        [channelScrollView bringSubviewToFront:button];
        button.alpha = 1;
        
        [self closeMenu];
    }
}

- (void)loadMenuWith:(NSInteger)numberOfButtons buttonsWithImages:(NSArray *)images {
    nbrOfButtons = numberOfButtons;
    imagesArray = images;
    
    switch (self.menuAnimation) {
        case MHExtendedMenuAnimationRight:
            btnSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
            break;
        case MHExtendedMenuAnimationLeft:
            btnSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
            break;
        case MHExtendedMenuAnimationTop:
            btnSize = CGSizeMake(self.frame.size.width, self.frame.size.width);
            break;
        case MHExtendedMenuAnimationBottom:
            btnSize = CGSizeMake(self.frame.size.width, self.frame.size.width);
            break;
        default:
            break;
    }
    
    [buttonsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [buttonsArray removeAllObjects];
    
    [self configureButtons];
    
    isMenuOpen = NO;
}

#pragma mark - Private Methods

- (void)configureButtons {
    buttonsArray = [[NSMutableArray alloc] init];
    channelScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    channelScrollView.delegate = self;
    channelScrollView.showsHorizontalScrollIndicator = NO;
    channelScrollView.showsVerticalScrollIndicator = NO;
    channelScrollView.clipsToBounds = NO;
    [self addSubview:channelScrollView];
    
    CGRect initialFrame;
    switch (self.menuAnimation) {
        case MHExtendedMenuAnimationRight:
            initialFrame = CGRectMake(0, 0, btnSize.width, btnSize.height);
            channelScrollView.contentSize = CGSizeMake(btnSize.width*nbrOfButtons+20*(nbrOfButtons-1), btnSize.height);
            break;
        case MHExtendedMenuAnimationLeft:
            initialFrame = CGRectMake(self.frame.size.width-btnSize.width, 0, btnSize.width, btnSize.height);
            channelScrollView.contentSize = CGSizeMake(btnSize.width*nbrOfButtons+20*(nbrOfButtons-1), btnSize.height);
            break;
        case MHExtendedMenuAnimationTop:
            initialFrame = CGRectMake(0, 0, btnSize.width, btnSize.height);
            channelScrollView.contentSize = CGSizeMake(btnSize.width, btnSize.height*nbrOfButtons+20*(nbrOfButtons-1));
            break;
        case MHExtendedMenuAnimationBottom:
            initialFrame = CGRectMake(0, self.frame.size.height-btnSize.height, btnSize.width, btnSize.height);
            channelScrollView.contentSize = CGSizeMake(btnSize.width, btnSize.height*nbrOfButtons+20*(nbrOfButtons-1));
            break;
        default:
            break;
    }
    
    for (int i = 0; i < nbrOfButtons; i++) {
        
        UIView *buttonView = [[UIView alloc] initWithFrame:initialFrame];
        buttonView.layer.cornerRadius = btnSize.width/2;
        
        if (i == 0 && nbrOfButtons > 1) {
            buttonView.layer.shadowColor = [[UIColor blackColor] CGColor];
            buttonView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            buttonView.layer.shadowRadius = 3.0f;
            buttonView.layer.shadowOpacity = 0.8f;
        }
        
        buttonView.tag = i;
        buttonView.userInteractionEnabled = YES;
        buttonView.clipsToBounds = NO;
        
        UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:buttonView.bounds];
        buttonImageView.image = imagesArray[i];
        buttonImageView.contentMode = UIViewContentModeScaleAspectFill;
        buttonImageView.layer.cornerRadius = btnSize.width/2;
        buttonImageView.clipsToBounds = YES;
        [buttonView addSubview:buttonImageView];
        
        UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(openMenu:)];
        longGestureRecognizer.delegate = self;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectButton:)];
        tapGestureRecognizer.delegate = self;
        
        [buttonView addGestureRecognizer:longGestureRecognizer];
        [buttonView addGestureRecognizer:tapGestureRecognizer];
        
        if (i == 0) {
            [channelScrollView addSubview:buttonView];
            mainItem = buttonView;
        } else {
            buttonView.alpha = 0;
            [channelScrollView insertSubview:buttonView belowSubview:[buttonsArray objectAtIndex:i-1]];
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
            if (delegateRespondsTo.willOpenMenu)
                [self.delegate MHExtendedMenuControlWillOpenMenu:self];
            
            [UIView animateWithDuration:Animation_Duration delay:0 options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 switch (self.menuAnimation) {
                                     case MHExtendedMenuAnimationTop:
                                         
                                         for (UIView *button in buttonsArray) {
                                             button.alpha = 1;
                                             button.layer.shadowColor = [[UIColor clearColor] CGColor];
                                             button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y-(btnSize.width-20)*[buttonsArray indexOfObject:button], button.frame.size.width, button.frame.size.height);
                                         }
                                         
                                         break;
                                     case MHExtendedMenuAnimationBottom:
                                         
                                         for (UIView *button in buttonsArray) {
                                             button.alpha = 1;
                                             button.layer.shadowColor = [[UIColor clearColor] CGColor];
                                             button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y+(btnSize.width+20)*[buttonsArray indexOfObject:button], button.frame.size.width, button.frame.size.height);
                                         }
                                         
                                         break;
                                     case MHExtendedMenuAnimationLeft:
                                         
                                         for (UIView *button in buttonsArray) {
                                             button.alpha = 1;
                                             button.layer.shadowColor = [[UIColor clearColor] CGColor];
                                             button.frame = CGRectMake(button.frame.origin.x-(btnSize.width-20)*[buttonsArray indexOfObject:button], button.frame.origin.y, button.frame.size.width, button.frame.size.height);
                                         }
                                         
                                         break;
                                     case MHExtendedMenuAnimationRight:
                                         
                                         for (UIView *button in buttonsArray) {
                                             button.alpha = 1;
                                             button.layer.shadowColor = [[UIColor clearColor] CGColor];
                                             button.frame = CGRectMake(button.frame.origin.x+(btnSize.width+20)*[buttonsArray indexOfObject:button], button.frame.origin.y, button.frame.size.width, button.frame.size.height);
                                         }
                                         
                                         break;
                                     default:
                                         break;
                                 }
                             }
                             completion:^(BOOL finished){
                                 if (delegateRespondsTo.didOpenMenu)
                                     [self.delegate MHExtendedMenuControlDidOpenMenu:self];
                             }
             ];
        }
    }
}

- (void)selectButton:(id)sender {
    
    if (isMenuOpen) {
        if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
            selectedButton = (int)tapGesture.view.tag;
            
            [self closeMenu];
            [self bringSubviewToFront:tapGesture.view];
            
            [self.delegate MHExtendedMenuControl:self didSelectButton:(int)tapGesture.view.tag];
        } else {
            selectedButton = (int)sender;
            
            [self closeMenu];
            [self bringSubviewToFront:buttonsArray[selectedButton]];
            
            [self.delegate MHExtendedMenuControl:self didSelectButton:selectedButton];
        }
        
    } else {
        [self.delegate MHExtendedMenuControlDidTapMenu:self];
    }
}

- (void)closeMenu {
    if (delegateRespondsTo.willCloseMenu)
        [self.delegate MHExtendedMenuControlWillCloseMenu:self];
    
    [UIView animateWithDuration:Animation_Duration
                     animations:^{
                         for (UIView *button in buttonsArray) {
                             if ([buttonsArray indexOfObject:button] != selectedButton) {
                                 button.layer.shadowColor = [[UIColor clearColor] CGColor];
                                 button.alpha = 0;
                             } else {
                                 if (nbrOfButtons > 1) {
                                     button.layer.shadowColor = [[UIColor blackColor] CGColor];
                                     button.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
                                     button.layer.shadowRadius = 3.0f;
                                     button.layer.shadowOpacity = 0.8f;
                                 }
                             }
                             
                             button.frame = ((UIView *)buttonsArray[0]).frame;
                         }
                         
                     }
                     completion:^(BOOL finished){
                         if (delegateRespondsTo.didCloseMenu)
                             [self.delegate MHExtendedMenuControlDidCloseMenu:self];
                         
                         isMenuOpen = NO;
                     }
     ];
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [UIView animateWithDuration:0.3 animations:^{
        mainItem.layer.shadowRadius = 5.0f;
    } completion:^(BOOL finished) {
        mainItem.layer.shadowRadius = 3.0f;
    }];
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.menuAnimation == MHExtendedMenuAnimationRight) {
        //Make sure navbar stay at the top
        CGRect frame = mainItem.frame;
        frame.origin.x = scrollView.contentOffset.x;
        mainItem.frame = frame;
        
        [self bringSubviewToFront:mainItem];
        
        for (UIView *view in buttonsArray) {
            if (view != mainItem) {
                CGRect frame = view.frame;
                CGFloat xPosition = frame.origin.x-scrollView.contentOffset.x;
                if (xPosition < btnSize.width) {
                    view.alpha = xPosition/btnSize.width;
                } else if (xPosition > CGRectGetMaxX(self.frame)-btnSize.width) {
                    [UIView animateWithDuration:0.3 animations:^{
                        view.alpha = 0;
                    }];
                } else
                    [UIView animateWithDuration:0.3 animations:^{
                        view.alpha = 1;
                    }];
            }
        }
    }
}

@end
