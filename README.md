This repo intends to help me when I need it to setup my raspberry cluster again. The process is not hard at all, but some tools and apps have some details that I will certainly forget.


1. [New Raspberry Setup](#newrasp)
    1. [Upgrade](#upgrading)
    2. [Static IP](#staticip)
    2. [SSD](#ssd)
3. [Tools](#tools)
    1. [k3s](#k3s)
        1. [Install](#install)
        1. [Master node Token](#masternode)
        1. [Worked node Setup](#workernode)
    1. [metalb](#metalb)

## Setup a new raspberry <a name="newrasp"></a>

-  use the official [Raspberry Imager](https://www.raspberrypi.com/software/)
- image: select OS 64 Lite
- config: for my case, I prefer to enable just the ssh through GUI and enable Wifi with wpa_supplicant.conf


Use a good quality usb-c cable. Sometimes the rpi will fail to read the sd card, in my case, it was a faulty usb cable. Seriosly.

### Upgrading <a name="upgrading"></a>

1 - Discover your rpi IP through your gateway and SSH into it

```
sudo apt update
sudo apt full-upgrade
sudo reboot
```

### Set a static IP <a name="staticip"></a>
- vim /etc/dhcpcd.conf

```
interface wlan0
static ip_address=192.168.15.180/24
static routers=192.168.15.1
static domain_name_servers=8.8.8.8
```

where interface, routers will depend of wifi/eth and your router gateway.

### Raspberry from an SSD <a name="ssd"></a>

With [rpi-clone](https://github.com/billw2/rpi-clone) it's possible to copy your SD card to a newly formatted SSD drive. The approach that worked for me is to first create the SD card with the Raspberry Imager, make sure it is working and you can SSH, then run rpi-clone.

- Create an SD card with your image
- Make sure you can boot with it and SSH
- Use rpi-cloner to copy SD card content into the SSD drive
- Run raspi-config and change boot order (A6)
- Shutdown your rpi
- Unplug the SD card and left only the SSD.


## Tools <a name="tools"></a>

### k3s <a name="k3s"></a>

I choose k3s as my main kubernetes flavor just for testing purposes. And, as the cluster itself does not have much RAM available, I thought it would be a good idea to experiment with something lighter than the ~official~.

#### Install <a name="install"></a>

k3s come with their load balancer and lb service named traefik and klipper, respectively. Although I have never play with them before, I want my cluster as close as possible to what we do on Cloud, so I chose nginx with MetaLB. Install k3s without the default tools:

```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --no-deploy=traefik --disable servicelb" sh -s -
```

#### Get master node token <a name="masternode"></a>

```
cat /var/lib/rancher/k3s/server/node-token
```

#### Install k3s on a worker node <a name="workernode"></a>

On the second raspberry - or node:

```
curl -sfL https://get.k3s.io | K3S_URL=https://masterip:6443 K3S_TOKEN=mastertoken sh -
```


## metalb <a name="metalb"></a>

