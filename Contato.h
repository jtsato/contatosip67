//
//  Contato.h
//  ContatosIP67
//
//  Created by ios6998 on 10/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface Contato : NSObject

@property (strong) NSString* nome;
@property (strong) NSString* telefone;
@property (strong) NSString* endereco;
@property (strong) NSString* site;
@property (strong) UIImage* foto;
@property (strong) NSNumber* latitude;
@property (strong) NSNumber* longitude;

-(id)initWithNome:(NSString *)nome_;

@end
