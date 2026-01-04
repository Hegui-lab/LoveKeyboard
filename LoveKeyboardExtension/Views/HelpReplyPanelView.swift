import UIKit

/// 帮你回面板视图
class HelpReplyPanelView: UIView {

    // MARK: - 回调
    var onReplySelected: ((String) -> Void)?
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
        titleLabel.text = "帮你回"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        setupReplies()
    }

    private func setupReplies() {
        let replies = ["好的", "谢谢", "没问题", "稍等"]

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            stack.heightAnchor.constraint(equalToConstant: 36)
        ])

        for reply in replies {
            let button = UIButton(type: .system)
            button.setTitle(reply, for: .normal)
            button.backgroundColor = UIColor(white: 0.95, alpha: 1)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(replyTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
    }

    @objc private func replyTapped(_ sender: UIButton) {
        guard let text = sender.title(for: .normal) else { return }
        onReplySelected?(text)
    }
}
