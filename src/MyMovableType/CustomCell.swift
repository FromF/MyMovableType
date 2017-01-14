//
//  CustomCell.swift
//  MyMovableType
//
//  Created by haruhito on 2017/01/02.
//  Copyright © 2017年 Swift-Beginners. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // TableViewの画像表示レイアウト調整
    // 参考サイト：http://www.wrichards.com/blog/2011/11/sdwebimage-fixed-width-cell-images/
    self.imageView?.frame = CGRect(x: 5, y: 5, width: 40, height: 32.5)
    let imageWidth = Int((self.imageView?.image?.size.width)!)
    
    if imageWidth > 0 {
      self.textLabel?.frame = CGRect(x: 55, y: (self.textLabel?.frame.origin.y)!, width: (self.textLabel?.frame.size.width)!, height: (self.textLabel?.frame.size.height)!)
      self.detailTextLabel?.frame = CGRect(x: 55, y: (self.detailTextLabel?.frame.origin.y)!, width: (self.detailTextLabel?.frame.size.width)!, height: (self.detailTextLabel?.frame.size.height)!)
    }
  }
}
