import UIKit

// MARK: - ToolbarViewDelegate协议
protocol ToolbarViewDelegate: AnyObject {
    func toolbarDidTapLogo()
    func toolbarDidTapHelpReply()
    func toolbarDidTapSuperTalk()
    func toolbarDidTapMore()
}

/// 工具栏视图 - 显示帮你回、超会说等功能按钮
class ToolbarView: UIView {

    // MARK: - Delegate
    weak var delegate: ToolbarViewDelegate?

    // MARK: - UI组件
    private let stackView = UIStackView()
    private let logoButton = UIButton(type: .system)
    private let helpReplyButton = UIButton(type: .system)
    private let superTalkButton = UIButton(type: .system)
    private let moreButton = UIButton(type: .system)

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
        backgroundColor = UIColor(white: 0.95, alpha: 1)

        // 配置StackView
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

        setupButtons()
    }

    private func setupButtons() {
        // Logo按钮
        logoButton.setTitle("Love", for: .normal)
        logoButton.addTarget(self, action: #selector(logoTapped), for: .touchUpInside)
        stackView.addArrangedSubview(logoButton)

        // 帮你回按钮
        helpReplyButton.setTitle("帮你回", for: .normal)
        helpReplyButton.addTarget(self, action: #selector(helpReplyTapped), for: .touchUpInside)
        stackView.addArrangedSubview(helpReplyButton)

        // 超会说按钮
        superTalkButton.setTitle("超会说", for: .normal)
        superTalkButton.addTarget(self, action: #selector(superTalkTapped), for: .touchUpInside)
        stackView.addArrangedSubview(superTalkButton)

        // 更多按钮
        moreButton.setTitle("更多", for: .normal)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        stackView.addArrangedSubview(moreButton)
    }

    // MARK: - 事件处理
    @objc private func logoTapped() {
        delegate?.toolbarDidTapLogo()
    }

    @objc private func helpReplyTapped() {
        delegate?.toolbarDidTapHelpReply()
    }

    @objc private func superTalkTapped() {
        delegate?.toolbarDidTapSuperTalk()
    }

    @objc private func moreTapped() {
        delegate?.toolbarDidTapMore()
    }
}
