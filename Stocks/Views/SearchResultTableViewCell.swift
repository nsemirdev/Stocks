//
//  SearchResultTableViewCell.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell {

    static let identifier = "SearchResultTableViewCell"
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
