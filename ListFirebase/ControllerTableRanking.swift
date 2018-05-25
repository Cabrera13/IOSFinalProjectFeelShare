//
//  ControllerTableRanking.swift
//  ListFirebase
//
//  Created by ios on 24/05/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct Users{
    var name : String
    var url : String
    var score : Double
    var emotion : String
}

class ControllerTableRanking: UITableViewController {
    var listUser:[Users]=[]
    var ref : DatabaseReference!
    var classUser = Users(name: "", url: "", score: 0, emotion: "")

    func getData() {
        
        print("holadwadaw")
        self.listUser.removeAll()
        ref = Database.database().reference()
        ref.child("scores").observe(.childAdded, with: {
            (snapshot : DataSnapshot) in
            if let data = snapshot.value as? [String: Any] {
                print(data)
                let name = data["name"]!
                let url = data["image"]!
                let score = data["score"]! 
                let emotion = data ["emotion"]!
                self.classUser.name = name as! String
                self.classUser.url = url as! String
                self.classUser.score = score as! Double
                self.classUser.emotion = emotion as! String
                self.listUser.append(self.classUser)
                print("0123")
                print(self.listUser)
            }
            self.tableView.reloadData()
            
        })
        
    }

 

    override func viewDidAppear(_ animated: Bool) {
        print("HOOLAA")
        getData()
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(" hola \(self.listUser.count)")
        return self.listUser.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellViewTableRankingController
        print("OWAD")
        cell.name?.text = self.listUser[indexPath.row].name
        print(self.listUser[indexPath.row].name)
        cell.score?.text = String(self.listUser[indexPath.row].score)
        print(self.listUser[indexPath.row].score)
        //cell.imageView = String(self.listUser[indexPath.row].score)
        cell.img.imageFromURL(urlString: self.listUser[indexPath.row].url)
        //let number = list[indexPath.row]
       // cell.name?.text = String(array[indexPath.row])
        cell.img.layer.borderWidth = 1.0
        cell.img.layer.masksToBounds = false
        cell.img.layer.borderColor = UIColor.white.cgColor
        cell.img.layer.cornerRadius = cell.img.frame.height / 2
        cell.img.clipsToBounds = true
        //cell.score?.text = String(array[indexPath.row])
        
        // Configure the cell...
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
