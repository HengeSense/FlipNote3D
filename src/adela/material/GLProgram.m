//
//  ProgramGenerator.m
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLProgram.h"



@implementation GLProgram

@synthesize program         = _program;

@synthesize modelViewProjMtx = _modelViewProjMtx;
@synthesize modelViewMtx    = _modelViewMtx;
@synthesize projectionMtx   = _projectionMtx;
@synthesize normalMtx       = _normalMtx;
@synthesize shadowMtx       = _shadowMtx;

@synthesize color           = _color;
@synthesize alpha           = _alpha;
@synthesize lightPosition   = _lightPosition;





+(void)initialize{
    
}

-(id)initWithShader:(NSString*)vertexShader:(NSString*)fragmentShader
{
    self = [super init];
    if(self){
        [self loadShaders:vertexShader:fragmentShader];
    }
    return self;
}

- (BOOL)loadShaders:(NSString*)vertexShader:(NSString*)fragmentShader
{
    
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:vertexShader ofType:@"vsh"];
    if (![self compileShader:&_vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:fragmentShader ofType:@"fsh"];
    if (![self compileShader:&_fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, _vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, _fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    
    return YES;
    
}

-(void)dispose{
    glDeleteProgram(_program);
    _program = 0;
}

-(void)bindPosition{
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
}
-(void)bindNormal{
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
}
-(void)bindTextCoord{
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord");
}

-(void)bindTextCoord0{
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord0");
}
-(void)bindTextCoord1{
    glBindAttribLocation(_program, GLKVertexAttribTexCoord1, "texCoord1");
}
-(BOOL)linking{
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (_vertShader) {
            glDeleteShader(_vertShader);
            _vertShader = 0;
        }
        if (_fragShader) {
            glDeleteShader(_fragShader);
            _fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    
    
    

        
    NSLog(@"program init success");
    return YES;
}

-(void)bindModelViewProjMtx{
    _modelViewProjMtx   = glGetUniformLocation(_program, "modelViewProjectionMatrix");
}
-(void)bindModelViewMtx{
    _modelViewMtx       = glGetUniformLocation(_program,"modelViewMatrix");
}
-(void)bindProjMtx{
    _projectionMtx      = glGetUniformLocation(_program,"projectionMatrix");
}
-(void)bindShadowMtx{
    _shadowMtx          = glGetUniformLocation(_program,"shadowMatrix");
}
-(void)bindNormalMtx{
    _normalMtx          = glGetUniformLocation(_program, "normalMatrix");
}

-(void)bindColor{
    _color          = glGetUniformLocation(_program, "color");
}

-(void)bindAlpha{
    _alpha              = glGetUniformLocation(_program, "alpha");
}
-(void)bindLightPos{
    _lightPosition      = glGetUniformLocation(_program,"lightPosition");
}

-(void)deleteShader{
    if (_vertShader) {
        glDetachShader(_program,_vertShader);
        glDeleteShader(_vertShader);
    }
    if (_fragShader) {
        glDetachShader(_program,_fragShader);
        glDeleteShader(_fragShader);
    }
}



- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}


@end
