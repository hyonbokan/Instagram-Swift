//
//  IGFeedPostTableViewCell.swift
//  Instagram
//
//  Created by dnlab on 2023/08/18.
//

import UIKit

final class IGFeedPostTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostTableViewCell"
    
    //override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?): This is the designated initializer for the UITableViewCell subclass. It overrides the initializer from the superclass (UITableViewCell) to provide custom initialization behavior. The parameters style and reuseIdentifier are passed to the superclass initializer using the super keyword.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    // required init?(coder: NSCoder): This initializer is required when creating instances of the class from a storyboard or nib file. It is marked as required because it is required for the superclass (UITableViewCell). This initializer is not implemented (fatalError) since this cell is not intended to be created from a storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        // Configure the cell
            
    }

}
