//
//  A2RConnection.h
//  Addicted2Random
//
//  Created by Roman Gille on 22.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A2RConnection : NSObject

- (id)initWithURL:(NSURL *)url established:(void (^)(void))establishedBlock;

- (void)closeWithCallback:(void (^)(void))closedBlock;

- (void)dispatchRPCMethod:(NSString *)methodString withParameters:(NSArray *)parameters andCallback:(void (^)(id result))completionBlock;

- (void)sendValues:(NSArray*)values toOSCAddress:(NSString*)address;

@end



@interface A2ROSCValue : NSObject

typedef enum {
    A2ROSCDataTypeInt,
    A2ROSCDataTypeFloat,
    A2ROSCDataTypeString
}A2ROSCDataType;

+ (A2ROSCValue*)valueWithObject:(NSObject*)object ofType:(A2ROSCDataType)type;

@property (nonatomic, assign) A2ROSCDataType type;
@property (nonatomic, strong) NSObject* value;

@end
