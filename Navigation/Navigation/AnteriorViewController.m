//
//  AnteriorViewController.m
//  Navigation
//
//  Created by Rodrigo Soldi Lopes on 25/02/14.
//  Copyright (c) 2014 Vinicius Miana. All rights reserved.
//

#import "AnteriorViewController.h"
#import "ProximoViewController.h"
#import "Singleton.h"
#import "Dicionario.h"


@interface AnteriorViewController ()

@end

@implementation AnteriorViewController

-(id)init{
    self = [super init];
    if (self) {
        UIBarButtonItem *next = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(next:)];
        self.navigationItem.rightBarButtonItem=next;
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = back;
        
        _texto = [[UILabel alloc]initWithFrame:CGRectMake(130, 500, 10, 10)];
        [_texto setText:@"App Store"];
        [_texto sizeToFit];
        [_texto setNumberOfLines:0];
        [self.view addSubview:_texto];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _synthesizer = [[AVSpeechSynthesizer alloc]init];

    _botaoAnterior = [UIButton buttonWithType:UIButtonTypeSystem];
    [_botaoAnterior addTarget:self action:@selector(executaSom:) forControlEvents:UIControlEventTouchUpInside];
    [_botaoAnterior sizeToFit];
    [_botaoAnterior setFrame:CGRectMake((self.view.frame.size.width/2)-128, (self.view.frame.size.height/2)-128, 256, 256)];
    [self.view addSubview:_botaoAnterior];
    
}


-(void)next: (id)sender{
    Singleton *single = [Singleton inicia];
    if (single.indice>=26) {
        [single setIndice:0];
    }
    Dicionario *novaLetra = [[single letras]objectAtIndex:[single indice]];
    single.indice++;

    ProximoViewController *proximo = [[ProximoViewController alloc]init];

    [proximo setTitle:[novaLetra letraGrande]];
    
    [[proximo botaoProximo] setBackgroundImage:[novaLetra imagem] forState:UIControlStateNormal];
    proximo.botaoProximo.center = proximo.view.center;
    [[proximo texto] setText:[novaLetra palavra]];
    
    [[self navigationController] pushViewController:proximo animated:YES];

}
-(void)back: (id)sender{
    Singleton *single = [Singleton inicia];
    single.indice--;
    if (single.indice<=0) {
        [single setIndice:26];
    }
    
    Dicionario *novaLetra = [[single letras]objectAtIndex:[single indice]-1];
    ProximoViewController *proximo = [[ProximoViewController alloc]init];
    
    [[self navigationController] pushViewController:proximo animated:YES];
    [proximo setTitle:[novaLetra letraGrande]];
    [[proximo botaoProximo] setBackgroundImage:[novaLetra imagem] forState:UIControlStateNormal];
    [[proximo texto] setText:[novaLetra palavra]];
}

-(void)executaSom:(id)sender{
    Singleton *single = [Singleton inicia];
    Dicionario *novaLetra = [[single letras]objectAtIndex:[single indice]-1];

    _utterance = [AVSpeechUtterance speechUtteranceWithString:[novaLetra palavra]];
    _utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    _utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"pt-br"];
    [_synthesizer speakUtterance:_utterance];
}
@end
