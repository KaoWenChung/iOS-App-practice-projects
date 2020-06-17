import UIKit

var str = "Hello, playground"



/*
let json = """
[{
"name": "John Davis",
"location":{
"country": "Peru"
},
"use": "to buy a new collection of clothes to stock her shop before the holidays.",
"loan_amount": 150
},{
"name": "Las Margaritas Group",
"location":{
"country": "Colombia"
},
"use": "purchase coal in large quantities for resale",
"loan_amount": 200
}]
"""

struct Loan: Codable {
    var name: String
    var country: String
    var use: String
    var amount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case country = "location"
        case use
        case amount = "loan_amount"
    }
    
    enum LocationKeys: String, CodingKey {
        case country
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        
        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        country = try location.decode(String.self, forKey: .country)
        
        use = try values.decode(String.self, forKey: .use)
        amount = try values.decode(Int.self, forKey: .amount)
    }
}

let decoder = JSONDecoder()

if let jsonData = json.data(using: .utf8) {
    
    do {
        let loan = try decoder.decode([Loan].self, from: jsonData)
        print(loan)
    } catch {
        print(error)
    }
 }
 */
let json = """
{
"paging": {
"page": 1,
"total": 6083,
"page_size": 20,
"pages": 305
},
"loans":
[{
"name": "John Davis",
"location": {
"country": "Paraguay",
},
"use": "to buy a new collection of clothes to stock her shop before the holidays.",
"loan_amount": 150
},
{
"name": "Las Margaritas Group",
"location": {
"country": "Colombia",
},
"use": "to purchase coal in large quantities for resale.",
"loan_amount": 200
}]
}
"""

struct LoanDataStore: Codable {
    var loans: [Loan]

}
struct Loan: Codable {
    var name: String
    var country: String
    var use: String
    var amount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case country = "location"
        case use
        case amount = "loan_amount"
    }
    
    enum LocationKeys: String, CodingKey {
        case country
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        
        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        country = try location.decode(String.self, forKey: .country)
        
        use = try values.decode(String.self, forKey: .use)
        amount = try values.decode(Int.self, forKey: .amount)
    }
}

let decoder = JSONDecoder()

if let jsonData = json.data(using: .utf8) {
    
    do {
        let loanDataStore = try decoder.decode(LoanDataStore.self, from: jsonData)
        
        for loan in loanDataStore.loans{
            print(loan)
        }
    } catch {
        print(error)
    }
 }
