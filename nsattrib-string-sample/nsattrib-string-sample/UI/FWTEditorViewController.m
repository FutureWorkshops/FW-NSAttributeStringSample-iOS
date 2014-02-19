//
//  FWTEditorViewController.m
//  nsattrib-string-sample
//
//  Created by Carlos Vidal on 19/02/2014.
//
//

#import "FWTEditorViewController.h"
#import "FWTWebViewController.h"
#import "FWTHTMLSyntax.h"

@interface FWTEditorViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *editorTextView;
@property (nonatomic, weak) IBOutlet UITextView *previewerTextView;

@end

@implementation FWTEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _setupTextViews];
    [self _setupNavigationBar];
}

#pragma mark - Private methods
- (UIColor*)_borderColor
{
    return [UIColor lightGrayColor];
}

- (void)_setupNavigationBar
{
    UIBarButtonItem *clearButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(_clearText)];
    self.navigationItem.rightBarButtonItem = clearButtonItem;
    
    UIBarButtonItem *aboutButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(_presentAbout)];
    self.navigationItem.leftBarButtonItem = aboutButtonItem;
}

- (void)_setupTextViews
{
    [self.editorTextView.layer setBorderWidth:1.f];
    [self.editorTextView.layer setBorderColor:[self _borderColor].CGColor];
    
    [self _renderPlainText:self.editorTextView.text];
}

- (void)_clearText
{
    self.editorTextView.text = @"";
    self.previewerTextView.text = @"";
}

- (void)_renderPlainText:(NSString*)plainText
{
    NSMutableAttributedString *attributedProductDescription = [[NSMutableAttributedString alloc] initWithData:[plainText dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                      options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                                           documentAttributes:nil
                                                                                                        error:nil];
    [self.previewerTextView setAttributedText:attributedProductDescription];
}

- (IBAction)_presentHTMLSyntax:(id)sender
{
    [self.editorTextView setText:kSyntax];
    [self _renderPlainText:kSyntax];
}

- (void)_presentAbout
{
    FWTWebViewController *webViewController = [[FWTWebViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    [self _renderPlainText:newString];
    
    return YES;
}

@end
