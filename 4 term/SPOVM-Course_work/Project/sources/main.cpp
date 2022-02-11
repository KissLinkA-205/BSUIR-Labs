#include <QApplication>

#include "chatdialog.h"

#include <QtCore/QSettings>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    ChatDialog dialog;
    dialog.show();
    return app.exec();
}
