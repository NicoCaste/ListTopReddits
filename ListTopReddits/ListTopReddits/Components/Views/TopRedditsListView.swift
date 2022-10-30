//
//  TopRedditsListView.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import UIKit

protocol TopReddistListDelegate: AnyObject {
    func goToReddistDetail(reddit: RedditWithImage)
    func reloadBestReddist() async
    func getMoreBest() async
}

class TopRedditsListView: UIView {
    lazy var refreshControl = UIRefreshControl()
    lazy var tableView: UITableView = UITableView()
    weak var delegate: TopReddistListDelegate?
    var redditsWithImage: [RedditWithImage] = []
    var previousLastRow: Int = 0

    init(frame: CGRect, reddist: [RedditWithImage]) {
        self.redditsWithImage = reddist
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBest(reddistWithImage: [RedditWithImage]) {
        self.redditsWithImage = reddistWithImage
        tableView.reloadData()
    }
    
    func addBest(reddistWithImage: [RedditWithImage]) {
        self.redditsWithImage += reddistWithImage
        tableView.reloadData()
    }
}

// MARK: - Config Views
extension TopRedditsListView {
    // MARK: - TableView
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(TopRedditsTableViewCell.self, forCellReuseIdentifier: "TopRedditsTableViewCell")
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        tableView.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        layoutTableView()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Task.detached {
            await self.reloadBestReddist()
        }
    }
    
    @MainActor func reloadBestReddist() async {
        previousLastRow = 0
        await delegate?.reloadBestReddist()
        tableView.refreshControl?.endRefreshing()
    }
    
    @MainActor func loadMoreReddits() async {
        await delegate?.getMoreBest()
    }
}

// MARK: - Collection View Delegate
extension TopRedditsListView: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Number Of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        redditsWithImage.count
    }
    
    // MARK: - Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRedditsTableViewCell") as? TopRedditsTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.populate(reddit: redditsWithImage[indexPath.row])
        
        return cell
    }
    
    // MARK: - Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.goToReddistDetail(reddit: redditsWithImage[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if redditsWithImage.count - 1 != previousLastRow && indexPath.row == redditsWithImage.count - 7 {
            Task.detached{
                await self.setPreviousLastRow(row: indexPath.row)
                await self.loadMoreReddits()
            }
        }
    }
    
    @MainActor func setPreviousLastRow(row: Int) {
        self.previousLastRow = row
    }
}

// MARK: - Layout
extension TopRedditsListView {
    // MARK: - TableView
    func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
