//
//  BitmapTexture.m
//  FlipNote3D
//
//  Created by xiang huang on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "BitmapTexture.h"
#import "Adela3DGLVIew.h"

@implementation BitmapTexture

@synthesize fileName    = _fileName;
@synthesize texName     = _texName;
@synthesize cgImg       = _cgImg;

//@synthesize texInfo = _texInfo;

@synthesize width       = _width;
@synthesize height      = _height;
@synthesize origWidth   = _origWidth;
@synthesize origHeight  = _origHeight;

@synthesize isLoaded    = _isLoaded;

static int MAX_TEXTURE_SIZE = 2048;
static NSMutableArray *asyncLoadJobs;
static bool _isAsyncLoading = false;

+(void)initialize{
    asyncLoadJobs = [[NSMutableArray alloc]init];
}

-(id)initWithFileName:(NSString *)fileName asynchronous:(BOOL)async{
    self        = [super init];
    if(self){
        _isLoaded   = false;
        _fileName   = fileName;
        if (async) {
            [BitmapTexture addAsyncLoadJob:self];
        }else{
            [self loadTextureSync];
            _isLoaded   = true;
        }
    }
    return self;
}

-(id)initWithCGImage:(CGImageRef)img{
    self        = [super init];
    if(self){
        _isLoaded   = false;
        _cgImg      = img;
        [self covertCGImageSync];
        _isLoaded   = true;
    }
    return self;
}


-(void)covertCGImageSync{
    _origWidth  = CGImageGetWidth(_cgImg);
    _origHeight = CGImageGetHeight(_cgImg);
    if ([BitmapTexture isDimensionValid:_origWidth] && [BitmapTexture isDimensionValid:_origHeight]) {
        _width  = _origWidth;
        _height = _origHeight;
    }else{
        _width  = [BitmapTexture getBestPowerOf2:_origWidth];
        _height = [BitmapTexture getBestPowerOf2:_origHeight];
    }
    
    GLubyte * spriteData = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, _width, _height, 8, _width*4,
                                                       CGImageGetColorSpace(_cgImg), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, _origWidth, _origHeight), _cgImg);
    glGenTextures(1, &_texName);
    glBindTexture(GL_TEXTURE_2D, _texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    CGContextRelease(spriteContext);
    free(spriteData);

}
// load texture synchronously
-(void)loadTextureSync
{
    NSLog(@"load image %@", _fileName);

    CGImageRef spriteImage = [UIImage imageNamed:_fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", _fileName);
        exit(1);
    }
    _origWidth  = CGImageGetWidth(spriteImage);
    _origHeight = CGImageGetHeight(spriteImage);
    if ([BitmapTexture isDimensionValid:_origWidth] && [BitmapTexture isDimensionValid:_origHeight]) {
        _width  = _origWidth;
        _height = _origHeight;
    }else{
        _width  = [BitmapTexture getBestPowerOf2:_origWidth];
        _height = [BitmapTexture getBestPowerOf2:_origHeight];
    }
    
    GLubyte * spriteData = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, _width, _height, 8, _width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, _origWidth, _origHeight), spriteImage);
    glGenTextures(1, &_texName);
    glBindTexture(GL_TEXTURE_2D, _texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    CGContextRelease(spriteContext);
    free(spriteData);
}


// load texture asynchronously

+(void)addAsyncLoadJob:(BitmapTexture*)texture{
    [asyncLoadJobs addObject:texture];
}

+(void)doAsyncLoadJob{
    if (!_isAsyncLoading && asyncLoadJobs.count>0) {
        _isAsyncLoading = true;
        BitmapTexture *tex = [asyncLoadJobs objectAtIndex:0];
        [asyncLoadJobs removeObjectAtIndex:0];
        [tex performSelectorInBackground: @selector(loadTextureAsync) withObject:Nil];
    }
}
-(void)loadTextureAsync
{
    
    NSLog(@"load image %@", _fileName);

    UIImage *uiImage    = [UIImage imageNamed:_fileName];

    CGImageRef spriteImage = uiImage.CGImage;
    
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", _fileName);
        [BitmapTexture performSelectorOnMainThread:@selector(doAsyncLoadQueue) withObject:Nil waitUntilDone:false];
    }
    _origWidth  = CGImageGetWidth(spriteImage);
    _origHeight = CGImageGetHeight(spriteImage);
    
    if ([BitmapTexture isDimensionValid:_origWidth] && [BitmapTexture isDimensionValid:_origHeight]) {
        _width  = _origWidth;
        _height = _origHeight;
    }else{
        _width  = [BitmapTexture getBestPowerOf2:_origWidth];
        _height = [BitmapTexture getBestPowerOf2:_origHeight];
    }

    GLubyte * spriteData = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, _width, _height, 8, _width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, _origWidth, _origHeight), spriteImage);
    
    //[EAGLContext setCurrentContext: [Adela3DGLVIew getinstance].context];
    //EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:[Adela3DGLVIew getinstance].context.sharegroup];
    [EAGLContext setCurrentContext:[Adela3DGLVIew getinstance].bgContext];
    glGenTextures(1, &_texName);
    glBindTexture(GL_TEXTURE_2D, _texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glFlush();
    CGContextRelease(spriteContext);
    free(spriteData);
    
    _isLoaded   = true;
   
    NSLog(@"img name %d", _texName);
    
    [EAGLContext setCurrentContext: nil];
    _isAsyncLoading = false;
}


-(void)dispose{
    glBindTexture(GL_TEXTURE_2D, _texName);
    glDeleteTextures(1, &_texName);
}




//size validation

+(BOOL)isCGImageSizeValid:(CGImageRef)img
{
    int w = CGImageGetWidth(img);
    int h = CGImageGetHeight(img);
    return [BitmapTexture isDimensionValid:w] && [BitmapTexture isDimensionValid:h];
}

+(BOOL)isDimensionValid:(int)d
{
    return d >= 2 && d <= MAX_TEXTURE_SIZE && [BitmapTexture isPowerOfTwo:d];
}

+(BOOL)isPowerOfTwo:(int)value
{
    return value ? ((value & -value) == value) : false;
}

+(int)getBestPowerOf2:(int)value
{
    int p = 1;
    while (p < value)
        p <<= 1;

    if (p > MAX_TEXTURE_SIZE) p = MAX_TEXTURE_SIZE;
    return p;
}

@end
