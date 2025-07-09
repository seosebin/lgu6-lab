# 확인
sudo apt update
sudo apt install mysql-server
sudo ufw all mysql
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl status mysql