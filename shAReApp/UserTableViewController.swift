//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by admin on 14/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse


class UserTableViewController: UITableViewController {
    
    // set up array to later get usernames from parse User class
    var usernames = [""]
    // set up array to define user IDs as parse object IDs
    var userIDs = [""]
    //set up dictionary w/ userID and whether user is being followed or not
    var isFollowing = ["" : false]
    
    var refresher: UIRefreshControl!
    
    
    
    @IBAction func logout(_ sender: Any) {
    
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func refresh() {
        
        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, error) in
            
            
            if error != nil {
                print(error)
            } else {
                
                if let users = objects {
                    
                    // start by clearing default values we assigned when defining variables above
                    self.usernames.removeAll()
                    self.userIDs.removeAll()
                    self.isFollowing.removeAll()
                    
                    for object in users {
                        if let user = object as? PFUser {
                            
                            if user.objectId != PFUser.current()?.objectId  {
                                
                                // we wrap everything in this if so it will display all the users EXCEPT the current user
                                
                                // splices email address domain from entries on friends list
                                let usernameArray = user.username!.components(separatedBy: "@")
                                
                                // start by adding all our usernames to above array without email domains
                                self.usernames.append(usernameArray[0])
                                // and include their userIDs
                                self.userIDs.append(user.objectId!)
                                
                                let query = PFQuery(className: "Followers")
                                
                                // where i'm the follower
                                query.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
                                // and i'm following other users
                                query.whereKey("following", equalTo: user.objectId!)
                                // get those relationships from db
                                query.findObjectsInBackground(block: { (objects, error) in
                                    
                                    if let objects = objects {
                                        if objects.count > 0 {
                                            // if i'm following more than 0 people, i must be following someone
                                            self.isFollowing[user.objectId!] = true
                                            
                                        } else {
                                            // otherwise i'm following no one
                                            self.isFollowing[user.objectId!] = false
                                        }
                                        
                                        if self.isFollowing.count == self.usernames.count {
                                            self.tableView.reloadData()
                                            
                                            self.refresher.endRefreshing()
                                            
                                        }
                                        
                                    }
                                    
                                })
                                
                                
                            }
                        }
                    }
                    
                }
            }
            
            
        })
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        refresh()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull down to refresh.")
        refresher.addTarget(self, action: #selector(UserTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
        
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
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 'cell' here wil be the table we set up in the storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // sets the text on each row to usernames in db
        cell.textLabel?.text = usernames[indexPath.row]
        
        //print(userIDs[indexPath.row])
        
        // display checkmarks next to all users i'm following
        if isFollowing[userIDs[indexPath.row]]! {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // selecting row in friends list
        
        // 'cell' is going to be whatever we tap on
        let cell = tableView.cellForRow(at: indexPath)
        
        // if there's a user at that row (which there always will be)
        if isFollowing[userIDs[indexPath.row]]! {
            
            // set isFollowing to false
            isFollowing[userIDs[indexPath.row]] = false
            
            // remove the checkmark
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            let query = PFQuery(className: "Followers")
            
            // where the current user is me and the user i just tapped on is someone i was following
            query.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            query.whereKey("following", equalTo: userIDs[indexPath.row])
            
            // find that relationship in the db
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let objects = objects {
                    
                    // and delete that relationship
                    for object in objects {
                        object.deleteInBackground()
                    }
                    
                }
                
            })
            
        } else {
            
            // if i'm not following them already, set isFollowing to true
            
            isFollowing[userIDs[indexPath.row]] = true

            // show checkmark
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            // 'following' will symbolise an object in our followers class in parse
            let following = PFObject(className: "Followers")
            
            // make me a follower
            following["follower"] = PFUser.current()?.objectId
            // of the person i just selected
            following["following"] = userIDs[indexPath.row]
            // and save that to the db
            following.saveInBackground()
            
            // (don't need to use whereKey etc because we're not looking for an existing entry in the db, we're creating one)
        }
        
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
