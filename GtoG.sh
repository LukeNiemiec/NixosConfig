sudo ip addr add 10.0.0.1/30 dev enp2s0
sudo ip link set enp2s0 up
sudo sysctl -w net.ipv4.ip_forward=1


sudo ip route add 192.168.4.0/24 via 10.0.0.2
sudo iptables -t nat -A POSTROUTING -o wlp3s0 -j MASQUERADE
