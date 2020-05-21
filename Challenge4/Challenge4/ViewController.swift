
import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Countries to see"

        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let decodedData = try? decoder.decode([Country].self, from: json) {
            countries = decodedData
            tableView.reloadData()
        }
    }

}

