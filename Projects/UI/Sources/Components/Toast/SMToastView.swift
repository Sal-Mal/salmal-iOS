import UIKit
import SwiftUI

public final class SMToastView: UIView {
  
  lazy var containerView: UIStackView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .ds(.gray4)
    $0.axis = .horizontal
    $0.spacing = 8
    return $0
  }(UIStackView())
  
  lazy var iconImageView: UIImageView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = toast.color
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 12
    $0.image = toast.iconImage
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())
  
  lazy var textLabel: UILabel = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .ds(.white)
    $0.font = .ds(.title4(.medium))
    $0.text = toast.title
    return $0
  }(UILabel())
  
  let toast: SMToast
  
  public init(toast: SMToast) {
    self.toast = toast
    super.init(frame: .zero)
    
    setupUI()
    setupConstraints()
  }
  
  required public init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setupUI() {
    layer.cornerRadius = 24
    backgroundColor = .ds(.gray4)
    clipsToBounds = true
    
    addSubview(containerView)
    containerView.addArrangedSubview(iconImageView)
    containerView.addArrangedSubview(textLabel)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: 48)
    ])
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
    ])
    
    NSLayoutConstraint.activate([
      iconImageView.heightAnchor.constraint(equalToConstant: 24),
      iconImageView.widthAnchor.constraint(equalToConstant: 24)
    ])
  }
}
