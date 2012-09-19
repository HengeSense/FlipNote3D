//
//  BottomBarButton.h
//  FlipBook3D
//
//  Created by huang xiang on 8/6/12.
//
//

#import "ObjectContainer3D.h"
#import "BitmapTexture.h"
#import "PagePart.h"

enum ButtonName{
    SWITCHVIEW,
    SHARE,
    ADD,
    SETTING,
    DELETE
};

@interface BottomBarButton : ObjectContainer3D{
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    int _u;
    int _v;
}

@property enum Part part;
@property(readonly)enum ButtonName buttonName;
-(id)initWidthPart:(enum Part)part andName:(enum ButtonName)name;

+(BitmapTexture*)getTexture;
-(void)updateBuffers:(int)u :(int)v :(BOOL)firstTime;
@end
