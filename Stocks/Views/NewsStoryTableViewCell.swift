//
//  NewsStoryTableViewCell.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import UIKit
import SDWebImage

final class NewsStoryTableViewCell: UITableViewCell {

    static let identifier = "NewsStoryTableViewCell"
    static let preferredHeight: CGFloat = 140
    
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageURL: URL?
        
        init(model: NewsStory) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = String.string(from: model.datetime)
            self.imageURL = URL(string: model.image)
        }
    }
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let headLine: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(sourceLabel, headLine, dateLabel, storyImageView)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height / 1.2
        storyImageView.frame = .init(x: contentView.width - imageSize - 10,
                                     y: (contentView.height - imageSize) / 2,
                                     width: imageSize,
                                     height: imageSize)
        
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imageSize - 20
        
        dateLabel.frame = .init(x: separatorInset.left,
                                y: contentView.height - 40,
                                width: availableWidth,
                                height: 40)
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = .init(x: separatorInset.left,
                                  y: 4,
                                  width: availableWidth,
                                  height: sourceLabel.height)
        
        headLine.frame = .init(x: separatorInset.left,
                               y: sourceLabel.bottom + 5,
                               width: availableWidth,
                               height: contentView.height - sourceLabel.bottom - dateLabel.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headLine.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    public func configure(with viewModel: ViewModel) {
        sourceLabel.text = viewModel.source
        headLine.text = viewModel.headline
        dateLabel.text = viewModel.dateString
        storyImageView.sd_setImage(with: viewModel.imageURL)
    }
}
