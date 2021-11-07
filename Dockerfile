FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /vbox/vms
RUN mkdir -p /vbox/iso
RUN apt update && apt upgrade -y
RUN apt install -y virtualbox
RUN apt install -y  linux-headers-generic virtualbox-dkms linux-headers-$(uname -r)
RUN dpkg-reconfigure virtualbox-dkms
RUN dpkg-reconfigure virtualbox
RUN modprobe vboxdrv
RUN modprobe vboxnetflt
RUN mkdir -p /vbox/vdisks

COPY image.iso /vbox/iso/
RUN VBoxManage createvm --name cygwin --register --basefolder /vbox/vms/ &&\
    VBoxManage createhd --filename /vbox/vdisks/cygwin.vdi --size 10240 --variant Standard &&\
    VBoxManage storagectl cygwin --name "IDE Controller" --add ide --controller PIIX4 --bootable on &&\
    VBoxManage storageattach cygwin --storagectl "IDE Controller" --type dvddrive --port 1 --device 0 --medium emptydrive &&\
    VBoxManage storageattach cygwin --storagectl "IDE Controller" --type hdd --port 0 --device 0 --medium /vbox/vdisks/cygwin.vdi &&\
    VBoxManage modifyvm cygwin --dvd /vbox/iso/image.iso &&\
    VBoxManage modifyvm cygwin --boot1 dvd &&\
    VBoxManage modifyvm cygwin --boot2 disk &&\
    VBoxManage modifyvm cygwin --memory 1024 &&\
    VBoxManage modifyvm cygwin --nic1 nat &&\
    VBoxManage modifyvm cygwin --cableconnected1 on &&\
    VBoxManage modifyvm cygwin --nicpromisc1 allow-all &&\
    VBoxManage modifyvm cygwin --natpf1 "ssh,tcp,,22,,22"
COPY waitSSHup.sh ./

EXPOSE 22
CMD [ "VBoxHeadless", "-v", "on", "-startvm", "cygwin" ]