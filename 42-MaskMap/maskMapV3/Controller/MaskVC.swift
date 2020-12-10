//
//  MaskVC.swift
//  maskMapV3
//
//  Created by wyn on 2020/3/16.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class MaskVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var spinner = UIActivityIndicatorView()
    private var masks = [Mask]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        setupSpinner()
        spinner.startAnimating()

        fetchMaskData()
    }

    private func setupSpinner() {
        spinner.style = .large
        spinner.hidesWhenStopped = true

        // Define the constraint of spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        var navHeight: CGFloat = 0.0
        if let nav = navigationController, nav.navigationBar.frame.maxY > 0 {
            navHeight = nav.navigationBar.frame.maxY
        }

        let height = view.frame.height
        spinner.topAnchor.constraint(equalTo: view.topAnchor, constant: (height / 2) - navHeight).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    private func fetchMaskData() {
        let urlString = "https://quality.data.gov.tw/dq_download_json.php?nid=116285&md5_url=2150b333756e64325bdbc4a5fd45fad1"

        guard let url = URL(string: urlString) else { return }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error == nil && data != nil{
                // Parse JSON
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                do {
                let downloadedMasks = try decoder.decode([Mask].self, from: data!)
                    self.masks = downloadedMasks
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
                catch{
                    print("Error in JSON parsing")
                }
            }
        }
        dataTask.resume()
    }
}

extension MaskVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masks.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaskCell") as? MaskTableViewCell else { return MaskTableViewCell() }
        
        cell.setUpView(mask: masks[indexPath.row])
        return cell
    }
}

extension MaskVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard else { return }
        guard let navigation = navigationController else { return }

        let destionation = storyboard.instantiateViewController(identifier: "HospitalDetailViewController") as! HospitalDetailViewController
        destionation.maskData = masks[indexPath.row]
        navigation.pushViewController(destionation, animated: true)
    }
}
        
