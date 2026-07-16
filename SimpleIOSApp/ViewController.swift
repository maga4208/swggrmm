import UIKit
import TDLibKit

class ViewController: UIViewController, UITextFieldDelegate {

    // Это наши поля и кнопки
    private let phoneTextField = UITextField()
    private let codeTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let statusLabel = UILabel()

    // Переменные для запоминания, что мы уже попросили код
    private var isCodeRequested = false
    private var phoneNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    // Рисуем экран (размещаем поля, кнопку и надпись)
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [phoneTextField, codeTextField, loginButton, statusLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])

        phoneTextField.placeholder = "Номер телефона (например, 79123456789)"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self

        codeTextField.placeholder = "Код из Telegram"
        codeTextField.borderStyle = .roundedRect
        codeTextField.isHidden = true // Сначала скрыто
        codeTextField.keyboardType = .numberPad
        codeTextField.delegate = self

        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)

        statusLabel.text = "Введите номер"
        statusLabel.textAlignment = .center
        statusLabel.textColor = .gray
    }

    // Это действие когда нажимаешь кнопку "Войти"
    @objc private func loginAction() {
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            statusLabel.text = "Введите номер"
            return
        }

        if !isCodeRequested {
            // Если код ещё не запрошен – запрашиваем
            phoneNumber = phone
            TDLibClient.shared.requestAuthCode(phoneNumber: phoneNumber) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.isCodeRequested = true
                        self?.codeTextField.isHidden = false
                        self?.loginButton.setTitle("Подтвердить", for: .normal)
                        self?.statusLabel.text = "Код отправлен на твой номер"
                    case .failure(let error):
                        self?.statusLabel.text = "Ошибка: \(error.localizedDescription)"
                    }
                }
            }
        } else {
            // Если код уже запрошен – проверяем код
            guard let code = codeTextField.text, !code.isEmpty else {
                statusLabel.text = "Введи код"
                return
            }
            TDLibClient.shared.checkAuthCode(code: code) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.statusLabel.text = "🎉 Ты вошёл в Telegram!"
                        self?.showSuccess()
                    case .failure(let error):
                        self?.statusLabel.text = "Неверный код: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

    // После входа показываем радостное сообщение (пока просто алерт)
    private func showSuccess() {
        let alert = UIAlertController(title: "Ура!", message: "Теперь ты в Telegram. Скоро тут будет список чатов.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    // Это чтобы клавиатура убиралась по нажатию "Готово"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
