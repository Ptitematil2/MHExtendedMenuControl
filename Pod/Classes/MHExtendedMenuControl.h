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

@class MHExtendedMenuControl;

@protocol MHExtendedMenuControlDelegate <NSObject>

@required
- (void)MHExtendedMenuControl:(MHExtendedMenuControl *)control didSelectButton:(int)buttonPosition;
- (void)MHExtendedMenuControlDidTapMenu:(MHExtendedMenuControl *)control;

@optional
- (void)MHExtendedMenuControlWillOpenMenu:(MHExtendedMenuControl *)control;
- (void)MHExtendedMenuControlDidOpenMenu:(MHExtendedMenuControl *)control;
- (void)MHExtendedMenuControlWillCloseMenu:(MHExtendedMenuControl *)control;
- (void)MHExtendedMenuControlDidCloseMenu:(MHExtendedMenuControl *)control;


@end

@interface MHExtendedMenuControl : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) MHExtendedMenuAnimation menuAnimation;
@property (nonatomic, assign) id <MHExtendedMenuControlDelegate> delegate;

- (id)initWith:(NSInteger)numberOfButtons buttonsWithImages:(NSArray *)images withSize:(CGSize)buttonSize animation:(MHExtendedMenuAnimation)animation andDelegate:(id)delegate;
- (void)setSelectedButton:(int)buttonIndex;
- (void)loadMenuWith:(NSInteger)numberOfButtons buttonsWithImages:(NSArray *)images;
- (void)closeMenu;

@end