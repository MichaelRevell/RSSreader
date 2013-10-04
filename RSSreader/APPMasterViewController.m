

#import "APPMasterViewController.h"

#import "APPDetailViewController.h"
#import "NewFeedViewController.h"

@interface APPMasterViewController ()
@property NSXMLParser *parser;
@property NSMutableArray *feeds;
@property NSMutableDictionary *item;
@property NSMutableString *itemTitle;
@property NSMutableString *link;
@property NSString *element;

@property (strong, nonatomic) NewFeedViewController *viewController;
    
@end

@implementation APPMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.textField.text = self.viewController.str;
    
    [self.feeds removeAllObjects];
    NSURL *url = [NSURL URLWithString:self.textField.text];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self.parser setDelegate:self];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewController = [[NewFeedViewController alloc] init];
    self.textField.text = @"http://news.yahoo.com/rss/";
    self.viewController.str = self.textField.text;
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New Feed" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    self.navigationItem.leftBarButtonItem = newButton;
    self.feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:self.textField.text];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self.parser setDelegate:self];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
}

- (void)buttonClicked:(UIBarButtonItem *)barButton {
    self.viewController.str = self.textField.text;
    [self presentViewController:self.viewController animated:YES completion:nil];
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    return cell;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.element = elementName;
    
    if ([self.element isEqualToString:@"item"]) {
        
        self.item    = [[NSMutableDictionary alloc] init];
        self.itemTitle   = [[NSMutableString alloc] init];
        self.link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        NSLog(@"%@", self.item);
        
        [self.item setObject:self.itemTitle forKey:@"title"];
        [self.item setObject:self.link forKey:@"link"];
        
        [self.feeds addObject:[self.item copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([self.element isEqualToString:@"title"]) {
        [self.itemTitle appendString:string];
    } else if ([self.element isEqualToString:@"link"]) {
        [self.link appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [self.feeds[indexPath.row] objectForKey: @"link"];
        [[segue destinationViewController] setUrl:string];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Call your calculation and clearing method.
    return YES;
}

@end
