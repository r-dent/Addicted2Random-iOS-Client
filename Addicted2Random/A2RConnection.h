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

- (void)dispatchRPCMethod:(NSString *)methodString withParameters:(NSString *)parametersString andCallback:(void (^)(id))completionBlock;

@end
