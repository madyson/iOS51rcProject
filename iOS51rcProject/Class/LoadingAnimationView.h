#import <UIKit/UIKit.h>
#import "AnimatedGif.h"

typedef enum _LoadingAnimationViewStyle {
	LoadingAnimationViewStyleNormal = 0,
	LoadingAnimationViewStyleSpot = 1,
	LoadingAnimationViewStyleFlow = 2,
	LoadingAnimationViewStyleCarton = 3
	
} LoadingAnimationViewStyle;

@interface LoadingAnimationView : UIImageView {
	
	NSMutableArray *_gifs;
}

@property(nonatomic, retain) NSMutableArray *gifs;

- (id)initWithFrame:(CGRect)frame loadingAnimationViewStyle:(LoadingAnimationViewStyle)style;

@end
