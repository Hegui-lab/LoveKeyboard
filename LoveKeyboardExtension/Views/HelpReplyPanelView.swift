import UIKit

// MARK: - HelpReplyPanelViewDelegate协议
protocol HelpReplyPanelViewDelegate: AnyObject {
    func helpReplyPanelDidTapClose()
    func helpReplyPanelDidTapPaste() -> String?
    func helpReplyPanelDidSelectReply(_ text: String)
}

/// 帮你回面板视图
class HelpReplyPanelView: UIView {

    // MARK: - Delegate
    weak var delegate: HelpReplyPanelViewDelegate?

    // MARK: - UI组件
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let pasteButton = UIButton(type: .system)
    private let inputTextView = UITextView()
    private let repliesStackView = UIStackView()
    private var replyButtons: [UIButton] = []

    // 快捷回复数据
    private let quickReplies = [
        "好的", "谢谢", "没问题", "稍等",
        "收到", "明白", "好的呢", "马上"
    ]

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

        setupHeader()
        setupInputArea()
        setupReplies()
    }

    private func setupHeader() {
        // 关闭按钮
        closeButton.setTitle("×", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 24)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)

        // 标题
        titleLabel.text = "帮你回"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        // 粘贴按钮
        pasteButton.setTitle("粘贴", for: .normal)
        pasteButton.addTarget(self, action: #selector(pasteTapped), for: .touchUpInside)
        pasteButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pasteButton)

        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),

            pasteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            pasteButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
    }

    private func setupInputArea() {
        inputTextView.font = .systemFont(ofSize: 14)
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 8
        inputTextView.isEditable = false
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputTextView)

        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            inputTextView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupReplies() {
        repliesStackView.axis = .vertical
        repliesStackView.spacing = 8
        repliesStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(repliesStackView)

        NSLayoutConstraint.activate([
            repliesStackView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 12),
            repliesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            repliesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])

        // 创建两行快捷回复
        for rowIndex in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 8
            rowStack.distribution = .fillEqually

            let startIndex = rowIndex * 4
            let endIndex = min(startIndex + 4, quickReplies.count)

            for i in startIndex..<endIndex {
                let button = createReplyButton(title: quickReplies[i])
                rowStack.addArrangedSubview(button)
                replyButtons.append(button)
            }

            repliesStackView.addArrangedSubview(rowStack)
        }
    }

    private func createReplyButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(replyTapped(_:)), for: .touchUpInside)
        return button
    }

    // MARK: - 公共方法
    func reset() {
        inputTextView.text = ""
    }

    func setInputText(_ text: String) {
        inputTextView.text = text
    }

    // MARK: - 事件处理
    @objc private func closeTapped() {
        delegate?.helpReplyPanelDidTapClose()
    }

    @objc private func pasteTapped() {
        if let text = delegate?.helpReplyPanelDidTapPaste() {
            inputTextView.text = text
        }
    }

    @objc private func replyTapped(_ sender: UIButton) {
        guard let text = sender.title(for: .normal) else { return }
        delegate?.helpReplyPanelDidSelectReply(text)
    }
}
