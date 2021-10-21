//
//  ViewController.swift
//  WhitehousePetition
//
//  Created by Andrei Korikov on 21.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filter: String?
    var filteredPetitions: [Petition] {
        if let filter = filter {
            if !filter.isEmpty {
                return petitions.filter { $0.title.contains(filter) }
            }
        }
        
        return petitions
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promptForSearch))
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showMessage(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.")
    }
    
    func parse(json: Data) {
        if let jsonPetitions = try? JSONDecoder().decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        showMessage(title: "Credits", message: "Data comes from the 'We The People API' of the Whitehouse")
    }
    
    @objc func promptForSearch() {
        let ac = UIAlertController(title: "Filter", message: "Enter the string to filter petitions by Title.", preferredStyle: .alert)
        ac.addTextField()
        
        let filterAction = UIAlertAction(title: "OK", style: .default) { [unowned ac, weak self] _ in
            self?.filter = ac.textFields?[0].text
            self?.tableView.reloadData()
        }
        ac.addAction(filterAction)
        
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = filteredPetitions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

