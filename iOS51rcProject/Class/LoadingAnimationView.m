#import "LoadingAnimationView.h"
@implementation LoadingAnimationView
@synthesize gifs = _gifs;


- (id)initWithFrame:(CGRect)frame loadingAnimationViewStyle:(LoadingAnimationViewStyle)style{
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		AnimatedGif *aniGif = [[AnimatedGif alloc] init];
		NSString *gifName = @"loading";
		NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
		[aniGif decodeGIF:[NSData dataWithContentsOfFile:path]];
		_gifs = [[aniGif frames] retain];
		self.animationImages = _gifs;
		self.animationDuration = 0.06f*[_gifs count];
		self.animationRepeatCount = 9999;
		[aniGif release];
    }
    return self;
}


-(void)startAnimating
{
	if(self.hidden)
		self.hidden = NO;
	[super startAnimating];	
}

-(void)stopAnimating
{
	[super stopAnimating];
	self.hidden = YES;
}

- (void)dealloc {
	[_gifs release];
    [super dealloc];
}


@end
