挂载共享文件夹
sudo mount -t vboxsf books /mnt/books

启动ss客户端
sslocal -c /etc/ss-config-mine.json

添加用户到组
usermod -a -G examplegroup $(whoami)

创建新用户并添加到组
useradd -G examplegroup exampleusername


