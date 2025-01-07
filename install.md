# Install Reminder

This is a reminder of the command to run when I install arch linux to a new machine,
all taken from archwiki

```bash

# Verify boot mode, should output 64 and efi/ should exist
cat /sys/firmware/efi/fw_platform_size

# connect to internet
iwctl device list
iwctl device DEVICE set-property Powered on
iwctl station DEVICE scan
iwctl -p PASSWORD station DEVICE connect SSID
# verify
ping google.com

# timedate
timedatectl set-timezone America/Montreal
```

## Connecting to install machine trough ssh (optional)

```bash
# uncomment and set PermitRootLogin yes
vim /etc/ssh/sshd_config

systemctl restart sshd

passwd

ip addr
```

## Disk Partitioning

I want:

- 32gb swap (=RAM)
- 100bg /boot
- 250gb /home

```bash
# List all available disks to identify the correct one (e.g., /dev/sdX)
lsblk

# Open parted in interactive mode for the target disk
sudo parted /dev/sdX

# Create a new GPT partition table
(parted) mklabel gpt  # Create a GPT partition table

# Create the EFI boot partition (100MB)
(parted) mkpart primary fat32 1MiB 100MiB  # Create the EFI boot partition (100MB)
(parted) set 1 boot on  # Mark partition as bootable

# Create the swap partition (32GB, from 100MiB to 32GiB)
(parted) mkpart primary linux-swap 100MiB 32GiB

# Create the root partition (100GB, from 32GiB to 132GiB)
(parted) mkpart primary btrfs 32GiB 132GiB

# Create the home partition (250GB, from 132GiB to 382GiB)
(parted) mkpart primary btrfs 132GiB 382GiB

# Exit the parted interactive mode
(parted) quit

# Verify partitions
fdisk -l /dev/sdX

# Format the first partition as swap space
mkswap /dev/sdX2

# Enable the swap partition
swapon /dev/sdX2

# Format the first partition (EFI) as FAT32
mkfs.fat -F32 /dev/sdX1

# Format the second partition as a Btrfs filesystem for the root partition
mkfs.btrfs -L root /dev/sdX3

# Format the third partition as a Btrfs filesystem for the home partition
mkfs.btrfs -L home /dev/sdX4

# Create and mount the EFI partition to /mnt/boot/efi
mount --mkdir /dev/sdX1 /mnt/boot/efi

# Mount the root partition to /mnt
mount /dev/sdX3 /mnt

# Mount the home partition to /mnt/home with --mkdir flag
mount --mkdir /dev/sdX4 /mnt/home

# Done! The disk is now partitioned and mounted with swap, root, and home.
```

## Installation

```bash
pacstrap -K /mnt base linux linux-firmware intel-ucode xf86-video-amdgpu\\
networkmanager vim nano man-db man-pages texinfo wayland openssh cmake sudo
```

## Configuration

```bash
# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
# chroot into mnt
arch-chroot /mnt
# Set timezone
ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
hwclock --systohc

# set locale
localectl set-locale LANG=en_US.UTF-8
localectl set-keymap us
localectl set-x11-keymap us pc105+inet terminate:ctrl_alt_bksp
locale-gen

# hostname
hostnamectl hostname HOSTNAME

# set root password
passwd

# Grub bootlaoder
pacman -S grub efibootmgr dosfstools os-prober mtools
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

# eneable ssh (optional)
systemctl enable sshd
# uncomment and set PermitRootLogin yes
vim /etc/ssh/sshd_config
systemctl restart sshd


# Finish configuration
exit
umount -R /mnt
reboot
```

```bash
# Create the user "felix" and set up their home directory, bash shell,
# and add to wheel group for sudo
useradd -m -G wheel -s /bin/bash felix

# Set password for the user "felix"
passwd felix

# add to sudoers
pacman -S sudo
# uncomment %wheel ALL=(ALL) ALL
nano /etc/sudoers

# verify
su - felix
whoami
sudo -v
```
