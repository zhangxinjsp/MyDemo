//
//  ContactsViewController.m
//  UINavgationController
//
//  Created by xsw on 14-10-23.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController (){
    ABAddressBookRef addressBook;
}

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self allContacts];
    
    [self insertPersonWithFirstName:@"jjj" lastName:@"sup" phone:@"12345698745" address:@"beijing"];
    [self insertGroupWithName:@"friendGroup"];
}

-(void)createAddressBook{
//    addressBook = ABAddressBookCreate();//6.0之前的方法
    CFErrorRef createError = nil;
    addressBook = ABAddressBookCreateWithOptions(NULL, &createError);
    if (addressBook != nil){
        LOGINFO(@"create the address book Successful.");
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                LOGINFO(@"Request Access address book Successful");
            }else{
                LOGINFO(@"Request Access address book failed %@", error);
            }
        });
    } else {
        LOGINFO(@"Could not access the address book.");
    }
}



- (void) allContacts{

    if (addressBook == nil){
        [self createAddressBook];
    }
    NSArray *arrayOfAllPeople = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    LOGINFO(@"contact count %d", arrayOfAllPeople.count);
    for (int peopleCounter = 0; peopleCounter < [arrayOfAllPeople count]; peopleCounter++){
        ABRecordRef thisPerson = (__bridge ABRecordRef)[arrayOfAllPeople objectAtIndex:peopleCounter];
        LOGINFO(@"thisPerson is %@", thisPerson);
        
        NSString *firstName             = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty);          // First name - kABStringPropertyType
        NSString *lastName              = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonLastNameProperty);           // Last name - kABStringPropertyType
        NSString *MiddleName            = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonMiddleNameProperty);         // Middle name - kABStringPropertyType
        NSString *Prefix                = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonPrefixProperty);             // Prefix ("Sir" "Duke" "General") - kABStringPropertyType
        NSString *Suffix                = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonSuffixProperty);             // Suffix ("Jr." "Sr." "III") - kABStringPropertyType
        NSString *Nickname              = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonNicknameProperty);           // Nickname - kABStringPropertyType
        NSString *FirstNamePhonetic     = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonFirstNamePhoneticProperty);  // First name Phonetic - kABStringPropertyType
        NSString *LastNamePhonetic      = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonLastNamePhoneticProperty);   // Last name Phonetic - kABStringPropertyType
        NSString *MiddleNamePhonetic    = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonMiddleNamePhoneticProperty); // Middle name Phonetic - kABStringPropertyType
        NSString *Organization          = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonOrganizationProperty);       // Company name - kABStringPropertyType
        NSString *JobTitle              = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonJobTitleProperty);           // Job Title - kABStringPropertyType
        NSString *Department            = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonDepartmentProperty);         // Department name - kABStringPropertyType
        NSString *Email                 = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonEmailProperty);              // Email(s) - kABMultiStringPropertyType
        NSString *Birthday              = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonBirthdayProperty);           // Birthday associated with this person - kABDateTimePropertyType
        NSString *Note                  = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonNoteProperty);               // Note - kABStringPropertyType
        NSString *CreationDate          = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonCreationDateProperty);       // Creation Date (when first saved)
        NSString *ModificationDate      = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonModificationDateProperty);   // Last saved date
        NSString *Address               = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonAddressProperty);            // Street address - kABMultiDictionaryPropertyType
        NSString *Phone               = (__bridge  NSString *) ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);              // Generic phone number - kABMultiStringPropertyType
        
        
        
        
        LOGINFO(@"First Name = %@", firstName);
        LOGINFO(@"Last Name = %@", lastName);
        LOGINFO(@"MiddleName = %@", MiddleName);
        LOGINFO(@"Prefix = %@", Prefix);
        LOGINFO(@"Suffix = %@", Suffix);
        LOGINFO(@"Nickname = %@", Nickname);
        LOGINFO(@"FirstNamePhonetic = %@", FirstNamePhonetic);
        LOGINFO(@"LastNamePhonetic = %@", LastNamePhonetic);
        LOGINFO(@"MiddleNamePhonetic = %@", MiddleNamePhonetic);
        LOGINFO(@"Organization = %@", Organization);
        LOGINFO(@"JobTitle = %@", JobTitle);
        LOGINFO(@"Department = %@", Department);
        LOGINFO(@"Email = %@", Email);
        [self logEmail:ABRecordCopyValue(thisPerson, kABPersonEmailProperty)];
        LOGINFO(@"Birthday = %@", Birthday);
        LOGINFO(@"Note = %@", Note);
        LOGINFO(@"CreationDate = %@", CreationDate);
        LOGINFO(@"ModificationDate = %@", ModificationDate);
        LOGINFO(@"Address = %@", Address);
        [self logAddress:ABRecordCopyValue(thisPerson, kABPersonAddressProperty)];
        LOGINFO(@"Address = %@", Phone);
        [self logEmail:ABRecordCopyValue(thisPerson, kABPersonPhoneProperty)];
        /* Use the [thisPerson] address book record */
        if ([firstName isEqualToString:@"zhang"]) {
            UIImage* image = [self getPersonImage:thisPerson];
            if (image == nil) {
                [self setPersonImage:thisPerson withImageData:UIImagePNGRepresentation([UIImage imageNamed:@"dragdown.png"])];
            }
        }
    }
}


- (void) logEmail:(ABMultiValueRef)multiValue{
    if (multiValue == NULL){
        return;
    }
    /* Go through all the emails */
    for (NSUInteger emailCounter = 0; emailCounter < ABMultiValueGetCount(multiValue); emailCounter++){
        /* Get the label of the email (if any) */
        NSString *label = (__bridge NSString *) ABMultiValueCopyLabelAtIndex(multiValue, emailCounter);
        NSString *localizedLabel = (__bridge NSString *) ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)label);
        /* And then get the email address itself */
        NSString *value = (__bridge NSString *) ABMultiValueCopyValueAtIndex(multiValue, emailCounter);
        LOGINFO(@"Label = %@, value = %@", localizedLabel, value);
    }
}

- (void) logAddress:(ABMultiValueRef)multiValue{
    if (multiValue == NULL){
        return;
    }
    /* Go through all the emails */
    for (NSUInteger emailCounter = 0; emailCounter < ABMultiValueGetCount(multiValue); emailCounter++){
        /* Get the label of the email (if any) */
        NSString *label = (__bridge NSString *) ABMultiValueCopyLabelAtIndex(multiValue, emailCounter);
        NSString *localizedLabel = (__bridge NSString *) ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)label);
        /* And then get the email address itself */
        CFDictionaryRef value = ABMultiValueCopyValueAtIndex(multiValue, emailCounter);
        
        NSString *value1 = CFDictionaryGetValue(value, kABPersonAddressStreetKey);
        NSString *value2 = CFDictionaryGetValue(value, kABPersonAddressCityKey);
        NSString *value3 = CFDictionaryGetValue(value, kABPersonAddressStateKey);
        NSString *value4 = CFDictionaryGetValue(value, kABPersonAddressZIPKey);
        NSString *value5 = CFDictionaryGetValue(value, kABPersonAddressCountryKey);
        NSString *value6 = CFDictionaryGetValue(value, kABPersonAddressCountryCodeKey);
        
        LOGINFO(@"Label = %@, value1 = %@, value2 = %@, value3 = %@, value4 = %@, value5 = %@, value6 = %@", localizedLabel, value1, value2, value3, value4, value5, value6);
    }
}

- (ABRecordRef) insertPersonWithFirstName:(NSString *)paramFirstName lastName:(NSString *)paramLastName phone:(NSString*)phone address:(NSString*)address{
    if (addressBook == NULL){
        [self createAddressBook];
    }
    //判断数据的完整性
    if ([paramFirstName length] == 0 && [paramLastName length] == 0){
        NSLog(@"First name and last name are both empty.");
        return NULL;
    }
    ABRecordRef result = ABPersonCreate();
    if (result == NULL){
        NSLog(@"Failed to create a new person.");
        return NULL;
    }
//    添加名
    CFErrorRef setFirstNameError = NULL;
    BOOL couldSetFirstName = ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef)paramFirstName, &setFirstNameError);
//    添加名
    CFErrorRef setLastNameError = NULL;
    BOOL couldSetLastName = ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef)paramLastName, &setLastNameError);
//    添加手机号
    CFErrorRef setPhoneError = NULL;
    ABMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phone), kABHomeLabel, 0);
    BOOL couldSetPhone = ABRecordSetValue(result, kABPersonPhoneProperty, multiPhone, &setPhoneError);

//    添加地址
#if 0
    CFStringRef keys[] = { kABPersonAddressCountryCodeKey, kABPersonAddressCountryKey, kABPersonAddressCityKey};
    CFTypeRef values[] = { (__bridge CFTypeRef)(@"cn"), (__bridge CFTypeRef)(@"China"), (__bridge CFTypeRef)(@"beijing")};
    CFDictionaryRef addressDict = CFDictionaryCreate(kCFAllocatorDefault, ( const void **)&keys, ( const void **)&values, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
#else
    CFMutableDictionaryRef addressDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 10, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionaryAddValue(addressDict, kABPersonAddressStreetKey, @"asdfasdfasd");
    CFDictionaryAddValue(addressDict, kABPersonAddressCityKey, @"nanjing");
    CFDictionaryAddValue(addressDict, kABPersonAddressStateKey, @"12341234");
    CFDictionaryAddValue(addressDict, kABPersonAddressZIPKey, @"11111");
    CFDictionaryAddValue(addressDict, kABPersonAddressCountryKey, @"China");
    CFDictionaryAddValue(addressDict, kABPersonAddressCountryCodeKey, @"cn");
#endif
    CFErrorRef setAddressError = NULL;
    ABMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    ABMultiValueAddValueAndLabel(multiAddress, addressDict, kABHomeLabel, 0);
    BOOL couldSetAddress = ABRecordSetValue(result, kABPersonAddressProperty, multiAddress, &setAddressError);
    
    CFErrorRef setImageError = NULL;
    ABPersonSetImageData(result, (__bridge CFDataRef)(UIImagePNGRepresentation([UIImage imageNamed:@"bubble_blue_recieve_doctor.png"])), &setImageError);
    
    if (couldSetFirstName && couldSetLastName && couldSetPhone && couldSetAddress){
        NSLog(@"Successfully set the first name and the last name of the person.");
    } else {
        NSLog(@"Failed to set the first name and/or last name of the person.");
    }
    
    CFErrorRef couldAddPersonError = NULL;
    BOOL couldAddPerson = ABAddressBookAddRecord(addressBook, result, &couldAddPersonError);
    
    if (couldAddPerson){
        NSLog(@"Successfully added the person.");
    } else {
        NSLog(@"Failed to add the person.");
        CFRelease(result);
        result = NULL;
        return result;
    }
    
    if (ABAddressBookHasUnsavedChanges(addressBook)){
        CFErrorRef couldSaveAddressBookError = NULL;
        BOOL couldSaveAddressBook = ABAddressBookSave(addressBook, &couldSaveAddressBookError);
        if (couldSaveAddressBook){
            NSLog(@"Successfully saved the address book.");
        } else {
            NSLog(@"Failed to save the address book. error is %@ ", couldSaveAddressBookError);
        }
    }
    return result;
}

- (BOOL) doesPersonExistWithFirstName:(NSString *)paramFirstName lastName:(NSString *)paramLastName {
    BOOL result = NO;
    if (addressBook == NULL){
        [self createAddressBook];
    }
    NSArray *allPeople = (__bridge  NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for (NSUInteger peopleCounter = 0; peopleCounter < [allPeople count]; peopleCounter++){
        
        ABRecordRef person = (__bridge ABRecordRef)[allPeople objectAtIndex:peopleCounter];
        NSString *firstName = (__bridge  NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge  NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        BOOL firstNameIsEqual = [firstName isEqualToString:paramFirstName];
        
        BOOL lastNameIsEqual =  [lastName isEqualToString:paramLastName];
        
        if (firstNameIsEqual && lastNameIsEqual){
            return YES;
        }
    }
    return result;
}

- (UIImage *) getPersonImage:(ABRecordRef)paramPerson{
    UIImage *result = nil;
    if (paramPerson == NULL){
        NSLog(@"The person is nil.");
        return NULL;
    }
    NSData *imageData = (__bridge NSData *)ABPersonCopyImageData(paramPerson);
    if (imageData != nil){
        UIImage *image = [UIImage imageWithData:imageData];
        result = image;
    }
    return result;
}

- (BOOL) setPersonImage:(ABRecordRef)paramPerson withImageData:(NSData *)paramImageData{
    BOOL result = NO;
    if (addressBook == NULL){
        [self createAddressBook];
    }
    if (paramPerson == NULL){
        NSLog(@"The person is nil.");
        return NO;
    }
    CFErrorRef couldSetPersonImageError = NULL;
    BOOL couldSetPersonImage = ABPersonSetImageData(paramPerson, (__bridge CFDataRef)paramImageData, &couldSetPersonImageError);
    if (couldSetPersonImage){
        NSLog(@"Successfully set the person's image. Saving...");
        if (ABAddressBookHasUnsavedChanges(addressBook)){
            CFErrorRef couldSaveAddressBookError = NULL;
            BOOL couldSaveAddressBook = ABAddressBookSave(addressBook, &couldSaveAddressBookError);
            if (couldSaveAddressBook){
                NSLog(@"Successfully saved the address book.");
                result = YES;
            } else {
                NSLog(@"Failed to save the address book.");
            }
        } else {
            NSLog(@"There are no changes to be saved!");
        }
    } else {
        NSLog(@"Failed to set the person's image.");
    }
    return result;
}






- (ABRecordRef) insertGroupWithName:(NSString *)paramGroupName {
    if (addressBook == NULL){
        [self createAddressBook];
    }
    
    ABRecordRef result = ABGroupCreate();
    if (result == NULL){
        NSLog(@"Failed to create a new group.");
        return NULL;
    }
    
    CFErrorRef error = NULL;
    BOOL couldSetGroupName = ABRecordSetValue(result, kABGroupNameProperty, (__bridge CFTypeRef)paramGroupName, &error);
    
    if (couldSetGroupName){
        CFErrorRef couldAddRecordError = NULL;
        BOOL couldAddRecord = ABAddressBookAddRecord(addressBook, result, &couldAddRecordError);
        
        if (couldAddRecord){
            NSLog(@"Successfully added the new group.");
            if (ABAddressBookHasUnsavedChanges(addressBook)){
                CFErrorRef couldSaveAddressBookError = NULL;
                BOOL couldSaveAddressBook = ABAddressBookSave(addressBook, &couldSaveAddressBookError);

                if (couldSaveAddressBook){
                    NSLog(@"Successfully saved the address book.");
                } else {
                    CFRelease(result);
                    result = NULL;
                    NSLog(@"Failed to save the address book.");
                }
            } else {
                CFRelease(result);
                result = NULL;
                NSLog(@"No unsaved changes.");
            }
        } else {
            CFRelease(result);
            result = NULL;
            NSLog(@"Could not add a new group.");
        }
    } else {
        CFRelease(result);
        result = NULL;
        NSLog(@"Failed to set the name of the group.");
    }
    return result;
}

- (BOOL) doesGroupExistWithGroupName:(NSString *)paramGroupName{
    BOOL result = NO;
    if (addressBook == NULL){
        [self createAddressBook];
    }
    NSArray *allGroups = (__bridge NSArray *) ABAddressBookCopyArrayOfAllGroups(addressBook);
    
    for (NSUInteger groupCounter = 0; groupCounter < [allGroups count]; groupCounter++){
        ABRecordRef group = (__bridge ABRecordRef)[allGroups objectAtIndex:groupCounter];
        NSString *groupName = (__bridge NSString *) ABRecordCopyValue(group, kABGroupNameProperty);
       
        if ([groupName isEqualToString:paramGroupName]){
            return YES;
        }
    }
    return result;
}

- (BOOL) addPerson:(ABRecordRef)paramPerson toGroup:(ABRecordRef)paramGroup {
    if (addressBook == nil) {
        [self createAddressBook];
    }
    BOOL result = NO;
    if (paramPerson == NULL || paramGroup == NULL){
        NSLog(@"Invalid parameters are given.");
        return NO;
    }
    CFErrorRef error = NULL;
    /* Now attempt to add the person entry to the group */
    result = ABGroupAddMember(paramGroup, paramPerson, &error);
    if (result == NO){
        NSLog(@"Could not add the person to the group.");
        return result;
    }
    /* Make sure we save any unsaved changes */
    if (ABAddressBookHasUnsavedChanges(addressBook)){
        CFErrorRef couldSaveAddressBookError = NULL;
        BOOL couldSaveAddressBook = ABAddressBookSave(addressBook, &couldSaveAddressBookError);
        if (couldSaveAddressBook){
            NSLog(@"Successfully added the person to the group.");
            result = YES;
        } else {
            NSLog(@"Failed to save the address book.");
        }
    } else {
        NSLog(@"No changes were saved.");
    }
    return result;
}
















-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CFRelease(addressBook);
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
