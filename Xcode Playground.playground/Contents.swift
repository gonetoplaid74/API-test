import UIKit

        let urlString = "https://dog.ceo/api/breeds/image/random/"
        let session = URLSession.shared
        let url = URL(string:urlString)!
        print("hello")
        
        session.dataTask(with: url){ (data:Data?, response:URLResponse?, error:Error?) -> Void in
            if let responseData = data {
                do{
                    let json = try
                        JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
                    print(json)
                } catch {
                    print("could not work")
                }
            } else {
                print("oops")
            }
        }.resume()

