import UIKit

/// 更多选项面板视图
class MoreOptionsPanelView: UIView {

    // MARK: - 回调
    var onOptionSelected: ((String) -> Void)?
    var onClose: (() -> Void)?

    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UI设置
    private func setupUI() {
        backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = "更多"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        setupOptions()
    }

    private func setupOptions() {
        let options = ["设置", "表情", "剪贴板"]

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            stack.heightAnchor.constraint(equalToConstant: 36)
        ])

        for option in options {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.backgroundColor = UIColor(white: 0.95, alpha: 1)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
    }

    @objc private func optionTapped(_ sender: UIButton) {
        guard let text = sender.title(for: .normal) else { return }
        onOptionSelected?(text)
    }
}
