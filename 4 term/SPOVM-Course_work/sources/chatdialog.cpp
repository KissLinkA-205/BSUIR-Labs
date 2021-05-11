#include <QtWidgets>

#include "chatdialog.h"

ChatDialog::ChatDialog(QWidget *parent)
    : QDialog(parent)
{
    setupUi(this);
    this->setWindowFlags(this->windowFlags() & ~Qt::WindowContextHelpButtonHint);

    //sendButton->setFocus();
    //inputMessage->setFocusPolicy(Qt::StrongFocus);
    //connectButton->setFocus();
    textEdit->setFocusPolicy(Qt::NoFocus);

    inputMessage->setDisabled(true);
    textEdit->setDisabled(true);
    listWidget->setDisabled(true);

    connect(inputMessage, &QLineEdit::returnPressed,
            this, &ChatDialog::returnPressed);
    connect(&client, &Client::newMessage,
            this, &ChatDialog::appendMessage);
    connect(&client, &Client::newParticipant,
            this, &ChatDialog::newParticipant);
    connect(&client, &Client::participantLeft,
            this, &ChatDialog::participantLeft);

    tableFormat.setBorder(0);
}

void ChatDialog::on_connectButton_clicked()
{
    if (nickName->text().isEmpty())
        return;

    client.setParameters(nickName->text());
    myNickName = nickName->text();
    newParticipant(myNickName);

    inputMessage->setDisabled(false);
    textEdit->setDisabled(false);
    listWidget->setDisabled(false);
    nickName->setDisabled(true);
    connectButton->setDisabled(true);

    inputMessage->setFocusPolicy(Qt::StrongFocus);
    listWidget->item(0)->setForeground(Qt::blue);
}

void ChatDialog::appendMessage(const QString &from, const QString &message)
{
    if (from.isEmpty() || message.isEmpty())
        return;

    QTextCursor cursor(textEdit->textCursor());
    cursor.movePosition(QTextCursor::End);
    if (from == nickName->text()) {

        textEdit->setTextColor(Qt::blue);
        textEdit->append('<' + from + "> " + message);

    } else {
        QTextTable *table = cursor.insertTable(1, 2, tableFormat);
        table->cellAt(0, 0).firstCursorPosition().insertText('<' + from + "> ");
        table->cellAt(0, 1).firstCursorPosition().insertText(message);
    }
    QScrollBar *bar = textEdit->verticalScrollBar();
    bar->setValue(bar->maximum());
}

void ChatDialog::returnPressed()
{
    QString text = inputMessage->text();
    if (text.isEmpty())
        return;

    if (text.startsWith(QChar('/'))) {
        QColor color = textEdit->textColor();
        if(text == "/info") {
            textEdit->setTextColor(Qt::darkGreen);
            textEdit->append(tr("/info: Peer-to-peer chat created by Angelika Derkach :)"));
        } else {
            textEdit->setTextColor(Qt::red);
            textEdit->append(tr("! Unknown command: %1")
                          .arg(text.left(text.indexOf(' '))));
            textEdit->setTextColor(color);
        }
    } else {
        client.sendMessage(text);
        appendMessage(myNickName, text);
    }

    inputMessage->clear();
}

void ChatDialog::newParticipant(const QString &nick)
{
    if (nick.isEmpty())
        return;

    QColor color = textEdit->textColor();
    textEdit->setTextColor(Qt::gray);
    textEdit->append(tr("* %1 has joined").arg(nick));
    textEdit->setTextColor(color);
    listWidget->addItem(nick);
}

void ChatDialog::participantLeft(const QString &nick)
{
    if (nick.isEmpty())
        return;

    QList<QListWidgetItem *> items = listWidget->findItems(nick,
                                                           Qt::MatchExactly);
    if (items.isEmpty())
        return;

    delete items.at(0);
    QColor color = textEdit->textColor();
    textEdit->setTextColor(Qt::gray);
    textEdit->append(tr("* %1 has left").arg(nick));
    textEdit->setTextColor(color);
}

