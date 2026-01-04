import UIKit

// MARK: - 键盘主视图代理协议
protocol KeyboardMainViewDelegate: AnyObject {
    func didTapKey(_ key: String)
    func didTapDelete()
    func didTapSpace()
    func didTapReturn()
    func didTapShift()
    func didDoubleTapShift()
    func didTapLanguageSwitch()
    func didTapKeyboardSwitch()
    func didTapSymbol()
    func didTapNumber()
    func didSelectCandidate(_ candidate: String)
    func didTapHelpReply()
    func didTapSuperTalk()
    func didTapMore()
    func didTapBackToKeyboard()
    func didTapPunctuation(_ punctuation: String)
    func didRequestPaste() -> String?
    func didRequestSendText(_ text: String)

    // 超会说专用
    func didTapKeyForSuperTalk(_ key: String)
    func didTapDeleteForSuperTalk()
    func didTapSpaceForSuperTalk()
    func didSelectCandidateForSuperTalk(_ candidate: String)
    func moveCursorLeft()
    func moveCursorRight()
    func getSuperTalkInputContent() -> String
}

// MARK: - 键盘主视图
class KeyboardMainView: UIView {

    weak var delegate: KeyboardMainViewDelegate?

    // MARK: - Subviews
    private var toolbarView: ToolbarView!
    private var candidateBarView: CandidateBarView!
    private var qwertyKeyboardView: QwertyKeyboardView!
    private var symbolKeyboardView: SymbolKeyboardView!
    private var helpReplyPanelView: HelpReplyPanelView!
    private var superTalkPanelView: SuperTalkPanelView!
    private var moreOptionsPanelView: MoreOptionsPanelView!

    private var currentKeyboardType: KeyboardType = .qwerty
    private var inputMode: InputMode = .chinese

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup
    private func setupViews() {
        backgroundColor = UIColor(hex: "D1D4DB")

        setupToolbar()
        setupCandidateBar()
        setupKeyboards()
        setupPanels()
    }

    private func setupToolbar() {
        toolbarView = ToolbarView()
        toolbarView.delegate = self
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(toolbarView)

        NSLayoutConstraint.activate([
            toolbarView.topAnchor.constraint(equalTo: topAnchor),
            toolbarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbarView.heightAnchor.constraint(equalToConstant: KeyboardLayout.toolbarHeight)
        ])
    }

    private func setupCandidateBar() {
        candidateBarView = CandidateBarView()
        candidateBarView.delegate = self
        candidateBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(candidateBarView)

        NSLayoutConstraint.activate([
            candidateBarView.topAnchor.constraint(equalTo: toolbarView.bottomAnchor),
            candidateBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            candidateBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            candidateBarView.heightAnchor.constraint(equalToConstant: KeyboardLayout.candidateBarHeight)
        ])
    }

    private func setupKeyboards() {
        // QWERTY键盘
        qwertyKeyboardView = QwertyKeyboardView()
        qwertyKeyboardView.delegate = self
        qwertyKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(qwertyKeyboardView)

        NSLayoutConstraint.activate([
            qwertyKeyboardView.topAnchor.constraint(equalTo: candidateBarView.bottomAnchor),
            qwertyKeyboardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            qwertyKeyboardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            qwertyKeyboardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // 符号键盘
        symbolKeyboardView = SymbolKeyboardView()
        symbolKeyboardView.delegate = self
        symbolKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        symbolKeyboardView.isHidden = true
        addSubview(symbolKeyboardView)

        NSLayoutConstraint.activate([
            symbolKeyboardView.topAnchor.constraint(equalTo: candidateBarView.bottomAnchor),
            symbolKeyboardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolKeyboardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            symbolKeyboardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupPanels() {
        // 帮你回面板
        helpReplyPanelView = HelpReplyPanelView()
        helpReplyPanelView.delegate = self
        helpReplyPanelView.translatesAutoresizingMaskIntoConstraints = false
        helpReplyPanelView.isHidden = true
        addSubview(helpReplyPanelView)

        NSLayoutConstraint.activate([
            helpReplyPanelView.topAnchor.constraint(equalTo: topAnchor),
            helpReplyPanelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            helpReplyPanelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            helpReplyPanelView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // 超会说面板
        superTalkPanelView = SuperTalkPanelView()
        superTalkPanelView.delegate = self
        superTalkPanelView.translatesAutoresizingMaskIntoConstraints = false
        superTalkPanelView.isHidden = true
        addSubview(superTalkPanelView)

        NSLayoutConstraint.activate([
            superTalkPanelView.topAnchor.constraint(equalTo: topAnchor),
            superTalkPanelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            superTalkPanelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            superTalkPanelView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // 更多选项面板
        moreOptionsPanelView = MoreOptionsPanelView()
        moreOptionsPanelView.delegate = self
        moreOptionsPanelView.translatesAutoresizingMaskIntoConstraints = false
        moreOptionsPanelView.isHidden = true
        addSubview(moreOptionsPanelView)

        NSLayoutConstraint.activate([
            moreOptionsPanelView.topAnchor.constraint(equalTo: topAnchor),
            moreOptionsPanelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moreOptionsPanelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreOptionsPanelView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public Methods
    func updateKeyboardType(_ type: KeyboardType) {
        currentKeyboardType = type

        qwertyKeyboardView.isHidden = type != .qwerty
        symbolKeyboardView.isHidden = type != .symbol
    }

    func updateInputMode(_ mode: InputMode) {
        inputMode = mode
        qwertyKeyboardView.updateInputMode(mode)
    }

    func updateShiftState(_ isShiftOn: Bool) {
        qwertyKeyboardView.updateShiftState(isShiftOn)
    }

    func updateCapsLockState(_ isCapsLockOn: Bool) {
        qwertyKeyboardView.updateCapsLockState(isCapsLockOn)
    }

    func updateCandidates(_ candidates: [String], pinyin: String) {
        candidateBarView.updateCandidates(candidates, pinyin: pinyin)
    }

    func showKeyboard() {
        toolbarView.isHidden = false
        candidateBarView.isHidden = false
        qwertyKeyboardView.isHidden = currentKeyboardType != .qwerty
        symbolKeyboardView.isHidden = currentKeyboardType != .symbol
        helpReplyPanelView.isHidden = true
        superTalkPanelView.isHidden = true
        moreOptionsPanelView.isHidden = true
    }

    func showHelpReplyPanel() {
        toolbarView.isHidden = true
        candidateBarView.isHidden = true
        qwertyKeyboardView.isHidden = true
        symbolKeyboardView.isHidden = true
        helpReplyPanelView.isHidden = false
        superTalkPanelView.isHidden = true
        moreOptionsPanelView.isHidden = true

        helpReplyPanelView.reset()
    }

    func showSuperTalkPanel() {
        toolbarView.isHidden = true
        candidateBarView.isHidden = true
        qwertyKeyboardView.isHidden = true
        symbolKeyboardView.isHidden = true
        helpReplyPanelView.isHidden = true
        superTalkPanelView.isHidden = false
        moreOptionsPanelView.isHidden = true

        superTalkPanelView.reset()
    }

    func showMoreOptionsPanel() {
        toolbarView.isHidden = true
        candidateBarView.isHidden = true
        qwertyKeyboardView.isHidden = true
        symbolKeyboardView.isHidden = true
        helpReplyPanelView.isHidden = true
        superTalkPanelView.isHidden = true
        moreOptionsPanelView.isHidden = false
    }

    // 超会说专用
    func updateCandidatesForSuperTalk(_ candidates: [String], pinyin: String) {
        superTalkPanelView.updateCandidates(candidates, pinyin: pinyin)
    }

    func updateSuperTalkInput(_ content: String, cursorPosition: Int) {
        superTalkPanelView.updateInputContent(content, cursorPosition: cursorPosition)
    }
}

// MARK: - ToolbarViewDelegate
extension KeyboardMainView: ToolbarViewDelegate {
    func toolbarDidTapLogo() {
        delegate?.didTapBackToKeyboard()
    }

    func toolbarDidTapHelpReply() {
        delegate?.didTapHelpReply()
    }

    func toolbarDidTapSuperTalk() {
        delegate?.didTapSuperTalk()
    }

    func toolbarDidTapMore() {
        delegate?.didTapMore()
    }
}

// MARK: - CandidateBarViewDelegate
extension KeyboardMainView: CandidateBarViewDelegate {
    func candidateBarDidSelectCandidate(_ candidate: String) {
        delegate?.didSelectCandidate(candidate)
    }
}

// MARK: - QwertyKeyboardViewDelegate
extension KeyboardMainView: QwertyKeyboardViewDelegate {
    func qwertyKeyboardDidTapKey(_ key: String) {
        delegate?.didTapKey(key)
    }

    func qwertyKeyboardDidTapDelete() {
        delegate?.didTapDelete()
    }

    func qwertyKeyboardDidTapSpace() {
        delegate?.didTapSpace()
    }

    func qwertyKeyboardDidTapReturn() {
        delegate?.didTapReturn()
    }

    func qwertyKeyboardDidTapShift() {
        delegate?.didTapShift()
    }

    func qwertyKeyboardDidDoubleTapShift() {
        delegate?.didDoubleTapShift()
    }

    func qwertyKeyboardDidTapLanguageSwitch() {
        delegate?.didTapLanguageSwitch()
    }

    func qwertyKeyboardDidTapKeyboardSwitch() {
        delegate?.didTapKeyboardSwitch()
    }

    func qwertyKeyboardDidTapSymbol() {
        delegate?.didTapSymbol()
    }
}

// MARK: - SymbolKeyboardViewDelegate
extension KeyboardMainView: SymbolKeyboardViewDelegate {
    func symbolKeyboardDidTapSymbol(_ symbol: String) {
        delegate?.didTapPunctuation(symbol)
    }

    func symbolKeyboardDidTapBack() {
        updateKeyboardType(.qwerty)
    }

    func symbolKeyboardDidTapDelete() {
        delegate?.didTapDelete()
    }

    func symbolKeyboardDidTapSpace() {
        delegate?.didTapSpace()
    }

    func symbolKeyboardDidTapReturn() {
        delegate?.didTapReturn()
    }
}

// MARK: - HelpReplyPanelViewDelegate
extension KeyboardMainView: HelpReplyPanelViewDelegate {
    func helpReplyPanelDidTapClose() {
        delegate?.didTapBackToKeyboard()
    }

    func helpReplyPanelDidTapPaste() -> String? {
        return delegate?.didRequestPaste()
    }

    func helpReplyPanelDidSelectReply(_ text: String) {
        delegate?.didRequestSendText(text)
    }
}

// MARK: - SuperTalkPanelViewDelegate
extension KeyboardMainView: SuperTalkPanelViewDelegate {
    func superTalkPanelDidTapClose() {
        delegate?.didTapBackToKeyboard()
    }

    func superTalkPanelDidTapKey(_ key: String) {
        delegate?.didTapKeyForSuperTalk(key)
    }

    func superTalkPanelDidTapDelete() {
        delegate?.didTapDeleteForSuperTalk()
    }

    func superTalkPanelDidTapSpace() {
        delegate?.didTapSpaceForSuperTalk()
    }

    func superTalkPanelDidSelectCandidate(_ candidate: String) {
        delegate?.didSelectCandidateForSuperTalk(candidate)
    }

    func superTalkPanelDidTapCursorLeft() {
        delegate?.moveCursorLeft()
    }

    func superTalkPanelDidTapCursorRight() {
        delegate?.moveCursorRight()
    }

    func superTalkPanelDidSelectResult(_ text: String) {
        delegate?.didRequestSendText(text)
    }

    func superTalkPanelGetInputContent() -> String {
        return delegate?.getSuperTalkInputContent() ?? ""
    }
}

// MARK: - MoreOptionsPanelViewDelegate
extension KeyboardMainView: MoreOptionsPanelViewDelegate {
    func moreOptionsPanelDidTapClose() {
        delegate?.didTapBackToKeyboard()
    }

    func moreOptionsPanelDidSelectKeyboardType(_ type: KeyboardType) {
        currentKeyboardType = type
        StorageService.shared.keyboardType = type
        delegate?.didTapBackToKeyboard()
    }
}
