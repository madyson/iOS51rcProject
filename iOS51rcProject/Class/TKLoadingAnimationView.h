#import <UIKit/UIKit.h>
#import "AnimatedGif.h"

typedef enum _TKLoadingAnimationViewStyle {
	TKLoadingAnimationViewStyleNormal = 0,
	TKLoadingAnimationViewStyleSpot = 1,
	TKLoadingAnimationViewStyleFlow = 2,
	TKLoadingAnimationViewStyleCarton = 3
	
} TKLoadingAnimationViewStyle;

@interface TKLoadingAnimationView : UIImageView {
	
	NSMutableArray *_gifs;
}

@property(nonatomic, retain) NSMutableArray *gifs;

- (id)initWithFrame:(CGRect)frame tkLoadingAnimationViewStyle:(TKLoadingAnimationViewStyle)style;

@end
