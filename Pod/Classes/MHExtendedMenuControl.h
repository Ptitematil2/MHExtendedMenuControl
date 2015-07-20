//
//  MHExtendedMenuControl.h
//  Pods
//
//  Created by Mathilde Henriot on 17/07/2015.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHExtendedMenuAnimation) {
    MHExtendedMenuAnimationBottom,
    MHExtendedMenuAnimationTop,
    MHExtendedMenuAnimationRight,
    MHExtendedMenuAnimationLeft
};

@protocol MHExtendedMenuControlDelegate

- (void)didSelectButton:(int)buttonPosition;

@end

@interface MHExtendedMenuControl : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) MHExtendedMenuAnimation menuAnimation;
@property (nonatomic, assign) id <MHExtendedMenuControlDelegate> delegate;

- (id)initWith:(NSInteger)numberOfButtons buttonsWithImages:(NSArray *)images animation:(MHExtendedMenuAnimation)animation andDelegate:(id)delegate;

@end
