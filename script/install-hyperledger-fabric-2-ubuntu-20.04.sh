#!/bin/bash
#
# Install Hyperledger Fabric 2.0.0 on Ubuntu 20.04 Linux.
#
# Usage:
#    ./install-hyperledger-fabric-2-ubuntu-20.04.sh
#

echo ""
echo "Installa packages ..."
sudo apt install git curl wget docker docker-compose nodejs npm
sudo npm install npm -g
sudo usermod -aG docker $USER

echo ""
echo "Versions of software:"
docker --version
docker-compose --version
npm --version
go version

go get -u github.com/hyperledger/fabric-samples || rt=1
cd $GOPATH/src/github.com/hyperledger/fabric-samples
git checkout a026a4ffbfcf69f33a2a25cd71c5a776ca2fdda5

echo ""
echo "Install Hyperledger Fabric 2.0.0 binaries and coker images ..."
sg docker -c "curl -sSL https://bit.ly/2ysbOFE | bash -s"
mkdir -p $GOPATH/bin/
cp -rv bin/* $GOPATH/bin/

echo ""
echo "Now start test-network ..."
cd $GOPATH/src/github.com/hyperledger/fabric-samples/test-network
sg docker -c "./network.sh up"

echo ""
echo ""
echo ""
echo "Congratulations! Your Hyperledger Fabric 2.0.0 test network is up."
echo ""
echo "Will create channel and register chaincode after a while..."
sleep 5

echo ""
echo "Creating channel mychannel ..."
sg docker -c "./network.sh createChannel -c mychannel"

echo ""
echo "Create a chaincode in go ..."
sg docker -c "./network.sh deployCC -l go"
echo ""
echo "**** Congratulations! ****"
echo "Your Hyperledger Fabric 2.0.0 test network with channel mychannel and chaincode fabcar is ready. Enjoy."
echo ""
echo ""
echo "To shutdown the network, first logout and then login again, then run:"
echo "cd $GOPATH/src/github.com/hyperledger/fabric-samples/test-network && ./network.sh down"
echo ""
