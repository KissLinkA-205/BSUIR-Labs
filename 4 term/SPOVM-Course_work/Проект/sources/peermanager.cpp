#include <QtNetwork>

#include "client.h"
#include "connection.h"
#include "peermanager.h"

static const qint32 BroadcastInterval = 2000;
static const unsigned broadcastPort = 45000;

PeerManager::PeerManager(Client *client)
    : QObject(client)
{
    this->client = client;

    username = client->getUserName();

    if (username.isEmpty())
        username = "unknown";

    updateAddresses();
    serverPort = 0;

    broadcastSocket.bind(QHostAddress::Any, broadcastPort, QUdpSocket::ShareAddress
                         | QUdpSocket::ReuseAddressHint);
    connect(&broadcastSocket, &QUdpSocket::readyRead,
            this, &PeerManager::readBroadcastDatagram);

    broadcastTimer.setInterval(BroadcastInterval);
    connect(&broadcastTimer, &QTimer::timeout,
            this, &PeerManager::sendBroadcastDatagram);
}

void PeerManager::setServerPort(int port)
{
    serverPort = port;
}

QString PeerManager::getUserName() const
{
    return username;
}

void PeerManager::startBroadcasting()
{
    broadcastTimer.start();
}

bool PeerManager::isLocalHostAddress(const QHostAddress &address) const
{
    for (const QHostAddress &localAddress : ipAddresses) {
        if (address.isEqual(localAddress))
            return true;
    }
    return false;
}

void PeerManager::sendBroadcastDatagram()
{
    QByteArray datagram;
    {
        QCborStreamWriter writer(&datagram);
        writer.startArray(2);
        writer.append(username);
        writer.append(serverPort);
        writer.endArray();
    }

    bool validBroadcastAddresses = true;
    for (const QHostAddress &address : qAsConst(broadcastAddresses)) {
        if (broadcastSocket.writeDatagram(datagram, address,
                                          broadcastPort) == -1)
            validBroadcastAddresses = false;
    }

    if (!validBroadcastAddresses)
        updateAddresses();
}

void PeerManager::readBroadcastDatagram()
{
    while (broadcastSocket.hasPendingDatagrams()) {
        QHostAddress senderIp;
        quint16 senderPort;
        QByteArray datagram;
        datagram.resize(broadcastSocket.pendingDatagramSize());
        if (broadcastSocket.readDatagram(datagram.data(), datagram.size(),
                                         &senderIp, &senderPort) == -1)
            continue;

        int senderServerPort;
        {
            QCborStreamReader reader(datagram);
            if (reader.lastError() != QCborError::NoError || !reader.isArray())
                continue;
            if (!reader.isLengthKnown() || reader.length() != 2)
                continue;

            reader.enterContainer();
            if (reader.lastError() != QCborError::NoError || !reader.isString())
                continue;
            while (reader.readString().status == QCborStreamReader::Ok) {
            }

            if (reader.lastError() != QCborError::NoError || !reader.isUnsignedInteger())
                continue;
            senderServerPort = reader.toInteger();
        }

        if (isLocalHostAddress(senderIp) && senderServerPort == serverPort)
            continue;

        if (!client->hasConnection(senderIp)) {
            Connection *connection = new Connection(this);
            emit newConnection(connection);
            connection->connectToHost(senderIp, senderServerPort);
        }
    }
}

void PeerManager::updateAddresses()
{
    broadcastAddresses.clear();
    ipAddresses.clear();
    const QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();
    for (const QNetworkInterface &interface : interfaces) {
        const QList<QNetworkAddressEntry> entries = interface.addressEntries();
        for (const QNetworkAddressEntry &entry : entries) {
            QHostAddress broadcastAddress = entry.broadcast();
            if (broadcastAddress != QHostAddress::Null && entry.ip() != QHostAddress::LocalHost) {
                broadcastAddresses << broadcastAddress;
                ipAddresses << entry.ip();
            }
        }
    }
}
