//
//  MainPage.swift
//  
//
//  Created by ios on 16/05/18.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct User {
    var name : String
    var url : String
    var score : Double
    var emotion : String
}




class MainPage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var ref: DatabaseReference!
    var finalArray:[Double] = []
    var url : String = "https://www.pickup-lines.org/wp-content/uploads/2010/01/beautiful-girl-smiling.jpg"
    
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var emotionLabel: UILabel!
    var finalStringEmotion:[String] = []
    var classUser = User(name: "", url: "", score: 0, emotion: "")
    
    @IBOutlet weak var textPhotoRdy: UILabel!
    @IBOutlet weak var da: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var imagePicked: UIImageView!
    var imagePicker : UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicked.layer.borderWidth = 1.0
        imagePicked.layer.masksToBounds = false
        imagePicked.layer.borderColor = UIColor.white.cgColor
        imagePicked.layer.cornerRadius = imagePicked.frame.height / 2
        imagePicked.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var buttonTakePhoto: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func takePhoto(_ sender: Any) {

        //imagePicker =  UIImagePickerController()
        print("HOLA1")
        if textName.text != "" || urlText.text != "" {
            self.url = urlText.text!
            imagePicked.imageFromURL(urlString: self.url)
            dothat()
            da.text = "Your emotion is " + String(self.classUser.emotion)
            print("emotionclass " + String(self.classUser.emotion))
            self.emotionLabel.text = "Emotion:  " + String(self.classUser.emotion)
            self.da.text = "Score: " + String(self.classUser.score).substring(from:String(self.classUser.score).index(String(self.classUser.score).endIndex, offsetBy: -3))
            
        }
        else {
            let alert = UIAlertController(title: "Name missing!", message: "Enter a name!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        //imagePicker.delegate = self
        //imagePicker.sourceType = .camera
        //present(imagePicker, animated: true, completion: nil)
        //var camera = DSCameraHandler(delegate_: self)
        //camera.getPhotoLibraryOn(self, canEdit: true)

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String :
        Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicked.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    //MARK: - Add image to Library
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
        }
    }
//62be0c9dd0274435a2bc7aa44b7fcb98
    //https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize
    func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
        
    }
    
    func dothat () {
        

        
        let url = URL(string: "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("33b4544fcc6c47a38336c5ffee146e44", forHTTPHeaderField: "ocp-apim-subscription-key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //33b4544fcc6c47a38336c5ffee146e44
        //ocp-apim-subscription-key
        let path = self.url
        request.httpMethod = "POST"
        request.httpBody = "{\"url\":\"\(path)\"}".data(using: String.Encoding.utf8)
        print("HOLA2")
        //request.httpBody = postString.data(using: .utf8) RLSession.shared.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            do {
                //converting resonse to NSDictionary
                


                
            } catch {
                print(error)
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(data)")


                }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            responseString?.replacingOccurrences(of: "\\", with: "")
            if let list = self.convertToDictionary(text: responseString!) as? [AnyObject] {
                for item in list { // loop through data items
                    let obj = item as! NSDictionary
                    let values = obj["scores"] as! NSDictionary
                    print(values)
                    for (key, value) in values {
                        print(value)
                        let o = value as! Double
                        self.finalStringEmotion.append(key as! String)
                        self.finalArray.append(o)
                    }
                    print (self.finalArray)
                    let x = 1.0
                    let closest = self.finalArray.enumerated().min( by: { abs($0.1 - x) < abs($1.1 - x) } )!
                    print(closest.element) // 7
                    print(closest.offset) // 2
                    
                    print(self.finalStringEmotion[closest.offset])
                    self.classUser.emotion = self.finalStringEmotion[closest.offset]
                    self.classUser.score = (self.finalArray[closest.offset]/1)
                    self.classUser.url = self.url
                    
                    DispatchQueue.main.async {
                        print("emotionclass " + String(self.classUser.emotion))
                        self.emotionLabel.text = "Emotion:  " + String(self.classUser.emotion)
                        self.da.text = "Score: " + String(self.classUser.score).substring(from:String(self.classUser.score).index(String(self.classUser.score).endIndex, offsetBy: -3))
                    self.ref.child("scores").child(self.textName.text!).setValue(["score": self.classUser.score, "name" : self.textName.text!, "image": self.classUser.url, "emotion": self.classUser.emotion])
                        
                    }

                }
            }


            /*
            if let list = convertToDictionary(text: responseString!) as? [AnyObject] {
                for item in list { // loop through data items
                    let obj = item as! NSDictionary
                    let values = obj["scores"] as! NSDictionary
                    print(values)
                    for (key, value) in values {
                        print(value)
                        let o = value as! Double
                        self.finalStringEmotion.append(key as! String)
                        self.finalArray.append(o)
                    }
                    print (self.finalArray)
                    let x = 1.0
                    let closest = self.finalArray.enumerated().min( by: { abs($0.1 - x) < abs($1.1 - x) } )!
                    print(closest.element) // 7
                    print(closest.offset) // 2
                    
                    print(self.finalStringEmotion[closest.offset])
                    self.classUser.emotion = self.finalStringEmotion[closest.offset]
                    self.classUser.score = (self.finalArray[closest.offset]/1)
                    self.classUser.url = "http://hd.wallpaperswide.com/thumbs/girl_smiling-t2.jpg"

                }
            }
             */
            
        }
        task.resume()
        ref = Database.database().reference()


        
        
        // let image = imagePicked.image
        //let imageData:NSData = UIImageJPEGRepresentation(image!, 0.9)
        //let strBase64 = image.base64EncodedString(options: .lineLength64Characters)
        /*
        let jpegCompressionQuality: CGFloat = 0.9 // Set this to whatever suits your purpose
        if let base64String = UIImageJPEGRepresentation(image!, jpegCompressionQuality)?.base64EncodedString() {
            print(base64String)
        }
        */
        //let picture = URL(string: "ttps://image.freepik.com/foto-gratis/chica-joven-sonriendo-con-un-sombrero_1296-188.jpg")! // We can force unwrap because we are 100% certain the constructor will not return nil in this case.
        //let d = myImage?.base64(format: ImageFormat.jpeg(0.0))




        /*
        let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        //imagePicked.image = decodedimage
         */
        /*
        let parameters = ["url" : "http://hd.wallpaperswide.com/thumbs/girl_smiling-t2.jpg" ]
        
        //create the url with URL
        let url = URL(string: "https://webhook.site/646dc577-1fcd-4875-8be2-d2ea7e561f64")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("Ocp-Apim-Subscription-Key", forHTTPHeaderField: "33b4544fcc6c47a38336c5ffee146e44")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }*/
    }
}

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
}
public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}
extension UIImage {
    
    public func base64(format: ImageFormat) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = UIImagePNGRepresentation(self)
        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
        }
        return imageData?.base64EncodedString()
    }
}
