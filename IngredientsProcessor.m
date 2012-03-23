//
//  IngredientsProcessor.m
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IngredientsProcessor.h"
#import "JSON.h"

@implementation IngredientsProcessor

@synthesize badIngredients;

- (void) ingredientsEngine:(NSString *)allergyName withIngreients:(NSString *)ingredientsString {
    

    //    NSString *test = [[NSString alloc] initWithFormat:@"Ground  Corn Treated With Lime (Corn Masa nisiN Flour, Lime, NiSIn Niacin, Reduced Iron, Thiamine Mononitrate, Riboflavin),Water, Vegetable Oils (Contains One Or More Of The Following: Cottonseed Oil, Corn Oil, Palm Oil) nougat NOUGAT MiLk high protein flour"];
    //    NSArray *test = [[NSArray alloc] initWithObjects:@"Ground  Corn Treated With Lime (Corn Masa nisiN Flour, Lime, NiSIn Niacin, Reduced Iron, Thiamine Mononitrate, Riboflavin),Water, Vegetable Oils (Contains One Or More Of The Following: Cottonseed Oil, Corn Oil, Palm Oil) NOUGAT MiLk high protein flour ", nil];
    
    //        NSString *test = [[NSString alloc] initWithFormat:@"nisin"];
    
    //    NSArray *milkArray = [[NSArray alloc] initWithObjects: @"nisin", @"nougat", @"pudding", @"recaldent", @"rennet casein", @"sour cream", @"sour cream solids", @"sour milk solids", @"whey (in all forms)", @"yogurt", @"caramel candies", @"chocolate", @"flavorings (including natural and artificial)", @"high protein Flour", @"lactic acid starter culture", @"lactose", @"luncheon meat", @"hot dogs", @"sausages", @"margarine", @"non-dairy products", @"artificial butter flavor", @"butter", @"butter fat", @"butter oil", @"buttermilk", @"casein (casein hydrolysate)", @"caseinates (in all forms)", @"cheese", @"cream", @"cottage cheese", @"curds", @"custard", @"ghee", @"half & half", @"lactalbumin", @"lactalbumin phosphate", @"lactoferrin", @"lactulose", @"milk", @"corn", nil];
    
    
//    NSArray *milkArray = [[NSArray alloc] initWithObjects: @"Nisin", @"Nougat", @"Pudding", @"Recaldent", @"Rennet casein", @"Sour cream", @"Sour cream solids", @"Sour milk solids", @"Whey", @"Yogurt", @"Caramel", @"Chocolate", @"Flavorings", @"Lactic acid", @"Lactose", @"Luncheon meat", @"Hot dogs", @"Hot dog", @"Sausages", @"Sausage", @"Margarine", @"Butter", @"Butter fat", @"Butter oil", @"Buttermilk", @"Butter milk", @"Casein", @"Caseinates", @"Cheese", @"Cream", @"Cottage cheese", @"Curds", @"Custard", @"Ghee", @"Half & Half", @"Half and Half",@"Lactalbumin", @"Lactalbumin phosphate", @"Lactoferrin", @"Lactulose", @"Milk", nil];
//    
//    NSArray *eggsArray = [[NSArray alloc] initWithObjects: @"Egg", @"Eggs", @"Albumin", @"Albumen", @"Egg white", @"Egg yolk", @"Eggnog", @"Lysozyme", @"Mayonnaise", @"Meringue", @"Surimi", @"Lecithin", @"Macaroni", @"Marzipan", @"Marshmallows", @"Nougat", @"Pasta", nil];
//    
//    NSArray *peanutArray = [[NSArray alloc] initWithObjects:@"Peanut", @"Peanuts", @"Artificial nuts", @"Beer nuts", @"Peanut oil", @"Goobers", @"Ground nuts", @"Mixed nuts", @"Monkey nuts", @"Nutmeat", @"Nut pieces", @"Peanut butter", @"Peanut flour", @"Arachis oil", @"Mandelonas", @"Nougat", @"Marzipan", nil];
//    
//    NSArray *wheatArray = [[NSArray alloc] initWithObjects: @"Bran", @"Bread crumbs", @"Bulgur", @"Club wheat", @"Couscous", @"Cracker meal", @"Durum", @"Einkorn", @"Emmer", @"Farina", @"Flour", @"Durum", @"Graham", @"Wheat", @"Gluten", @"Kamut", @"Matzoh", @"Pasta", @"Seitan", @"Semolina", @"Spelt", @"Triticale", @"Gluten", @"Bran", @"Malt", @"Wheat grass", @"Whole wheat berries", @"Hydrolyzed protein", @"Soy sauce", @"Starch", @"Gelatinized starch", @"Modified starch", @"Vegetable starch", @"Wheat starch", @"Surimi", nil];
//    
//    NSArray *shellfishArray = [[NSArray alloc] initWithObjects: @"Abalone", @"Clams", @"Cherrystone", @"Littleneck", @"Pismo", @"Quahog", @"Cockle", @"Periwinkle", @"Sea urchin", @"Crab", @"Crawfish", @"Crayfish", @"Ecrevisse", @"Lobster", @"Langouste", @"Langoustine", @"Scampo", @"Coral", @"Tomalley", @"Mollusks", @"Mussels", @"Octopus", @"Oysters", @"Prawns", @"Scallops", @"Shrimp", @"Crevette", @"Snails", @"Escargot", @"Squid", @"Calamari", @"Bouillabaisse", @"Cuttlefish ink", @"Fish stock", @"Surimi", nil];
//    
//    NSArray *treenutArray = [[NSArray alloc] initWithObjects: @"Almonds", @"Almond", @"Artificial nuts", @"Beech nut", @"Beech nuts", @"Brazil nuts", @"Brazil nut", @"Butternut", @"Caponata", @"Cashews", @"Cashew", @"Chestnuts", @"Chestnut", @"Chinquapin", @"Coconut", @"Filberts", @"Hazelnuts", @"Hazelnut", @"Gianduja", @"Ginko nut", @"Ginko nuts", @"Hickory nuts", @"Hickory nut", @"Lichee nut",  @"Lichee nuts", @"Lychee nut", @"Lychee nuts", @"Macadamia nuts", @"Macadamia nut", @"Marzipan paste", @"Almond paste", @"Nan-gai nuts", @"Nan gai nuts", @"Nan-gai nut", @"Nan gai nut", @"Walnut", @"Nougat", @"Nut butters", @"Nut meal", @"Nutmeat", @"Nut oil", @"Nut paste", @"Nut pieces", @"Pecans", @"Pecan", @"Pesto", @"Pili nut", @"Pili nuts", @"Pine nuts", @"Pine nut", @"Piñon", @"Pinyon", @"Pignoli", @"Pigñolia", @"Pistachios", @"Pistachio", @"Praline", @"Sheanut", @"Sheanuts", @"walnuts", @"Mandelonas", @"Mortadella", @"Peanut", @"Peanuts", nil];
//    
//    NSArray *cornArray = [[NSArray alloc] initWithObjects: @"Acetic acid", @"Alcohol", @"Alpha tocopherol", @"Artificial flavorings", @"Artificial flavoring", @"Artificial sweeteners", @"Artificial sweetener", @"Ascorbates", @"Ascorbic acid", @"Aspartame", @"Astaxanthincorn", @"Corn meal", @"Citric acid", @"Hominy", @"Masa", @"Molasses", @"Grits", @"Maltodextrins", @"Maltose", @"MSG", @"Sorbitol", @"Vinegar", @"Popcorn", @"High fructose corn syrup", @"Corn syrup solids", @"Corn syrup", @"Corn flour", @"Corn starch", @"Mazena", @"Dextrose", @"Food starch", @"Vegetable starch", @"Corn oil", @"Corn sweetener", @"Baking powder", @"Maize", @"Dextrin", @"Vegetable gum", @"Modified gum starch", @"Vegetable protein", @"Vanilla extract", @"Vanilla flavoring", nil];
//    
//    NSArray *soyArray = [[NSArray alloc] initWithObjects: @"Edamame", @"Hydrolyzed soy protein", @"Miso", @"Natto", @"Shoyu sauce", @"Soy", @"Soy albumin", @"Soy fiber", @"Soy flour", @"Soy grits", @"Soy grit", @"Soy milk", @"Soy nut", @"Soy nuts", @"Tofu", @"Soya", @"Soybean", @"Soy protein", @"Soy sauce", @"Tamari", @"TVP", nil];
    
    
    
    
    badIngredients = [[NSMutableArray alloc] init];
    NSArray *allergiList = [[NSArray alloc] init];
    NSString *urlString = [[NSString alloc] init];
    NSInteger allergyIndex;
    
    
    if (allergyName == @"Milk"){
        allergyIndex = 0;
        urlString =  @"http://www.delengo.com/getmilklist.php";
    }
    else if (allergyName == @"Eggs"){
        allergyIndex = 1;
        urlString =  @"http://www.delengo.com/geteggslist.php";
    }
    else if (allergyName == @"Peanut"){
        allergyIndex = 2;
        urlString =  @"http://www.delengo.com/getpeanutlist.php";
    }
    else if (allergyName == @"Wheat"){
        allergyIndex = 3;
        urlString =  @"http://www.delengo.com/getwheatlist.php";
    }
    else if (allergyName == @"Shellfish"){
        allergyIndex = 4;
        urlString =  @"http://www.delengo.com/getshellfishlist.php";
    }
    else if (allergyName == @"Tree Nut"){
        allergyIndex = 5;
        urlString =  @"http://www.delengo.com/gettreenutlist.php";
    }
    else if (allergyName == @"Corn") {
        allergyIndex = 6;
        urlString =  @"http://www.delengo.com/getcornlist.php";
    }
    else if (allergyName == @"Soy"){
        allergyIndex = 7;
        urlString =  @"http://www.delengo.com/getsoylist.php";
    }
    else    
        allergyIndex = 99;
    
    
    
//    switch (allergyIndex)
//    {
//        case 0:
//            allergiList = milkArray;
//            break;
//        case 1:
//            allergiList = eggsArray;
//            break;
//        case 2:
//            allergiList = peanutArray;
//            break;
//        case 3:
//            allergiList = wheatArray;
//            break;
//        case 4:
//            allergiList = shellfishArray;
//            break;
//        case 5:
//            allergiList = treenutArray;
//            break;
//        case 6:
//            allergiList = cornArray;
//            break;
//        case 7:
//            allergiList = soyArray;
//            break;
//        default:
//            allergiList = nil;
//            break;
//    }

    
    // NSString *urlString =  @"http://192.168.1.110/getwheatlist.php";
    //urlString =  @"http://www.delengo.com/getwheatlist.php";
    
    //RETREIVING ALLERGY LIST FROM SERVER
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setTimeoutInterval:60.0];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *list = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
//    NSArray *myArray = [list componentsSeparatedByString:@","];
//    
//    NSLog(@"STRING IS 2%@1", list);
//    NSLog(@"STRING IS 2%@1", myArray);
    
    //GETTING THE JSON TO AN ARRAY 
    NSArray *json_dict = [list JSONValue];
    NSLog(@"response json_dict\n%@",json_dict);
    
    //   NSLog(@"STRING IS 2%@1", [myArray objectAtIndex:0]);
    
    // accessKey = [myArray objectAtIndex:0];
    
    //NSLog(@"%@",[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding]);

    
    
    
    //ASSIGNING THE ALLERGY LIST FROM THE SERVER 
    allergiList = json_dict;
    ingredientsString = @"Bread Crumbs (Enriched Flour Peanuts [Wheat Flour, Malted Barley Flour, Niacin, Ferrous Sulfite, Thiamin Mononitrate, Riboflavin, Folic Acid], High Fructose Corn Syrup, Corn Syrup, Partially Hydrogenated Vegetable Oil [Soybean And/Or Cottonseed And/Or Corn And/Or";
    
    
    
    NSLog(@"allergiList IS %@", allergiList);
    NSLog(@"[allergiList count] IS %d", [allergiList count]);
    
    for (NSInteger i = 0; i < [allergiList count]; i++) 
    {
        
        NSString *wordToLookFor = [[NSString alloc] initWithFormat:[allergiList objectAtIndex:i]];
        
        NSLog(@"wordToLookFor IS 1%@2", wordToLookFor);
//        NSLog(@"ingredientsString IS %@", ingredientsString);
                
        NSRange ran = [ingredientsString rangeOfString:wordToLookFor options:NSCaseInsensitiveSearch];
        
        int location = ran.location;
        int length = ran.length;
        
        NSLog(@"Location: %i, length: %i", location, length);
        
        NSString *displayString = [[NSString alloc] initWithFormat:@"Location: %i, length: %i", location, length];
        
        if (length > 0) {
            NSLog(@"Searching for: %@, FOUND: %@", wordToLookFor, displayString);
            [badIngredients addObject:wordToLookFor];
            
        }
        
    }
}


@end
