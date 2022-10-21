//
//  ViewController.swift
//  CodableRealm
//
//  Created by Cedan Misquith on 21/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var users: Users!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkManager.sharedInstance.makeNetworkRequest(urlString: "https://reqres.in/api/users?page=1", prametres: [:], type: .withoutAuth, method: .GET) { (data) in
            do {
                let decoder = JSONDecoder()
                self.users = try decoder.decode(Users.self, from: data)
                self.tableView.reloadData()
            } catch let error {
                print(error)
            }
        }
    }
    @IBAction func saveUserButtonAction(_ sender: UIButton) {
        RealmDataManager.sharedInstance.saveUsers(users: users)
    }
    @IBAction func getUsersButtonAction(_ sender: UIButton) {
        if let savedUsers = RealmDataManager.sharedInstance.getAllUsers() {
            print(savedUsers)
        }
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users.data.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if users != nil {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            let user = users.data[indexPath.row]
            cell.textLabel?.text = "\(user.first_name) \(user.last_name)"
        return cell
        } else {
            return UITableViewCell()
        }
    }
}
