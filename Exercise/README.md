# Exercise

```
1) Create a VPC with CIDR block 30.0.0.0/16
2) Create and attach IGW.
3) Create 2 subnets - 30.0.10.0/24 and 30.0.40.0/24
4) 1 Public Route Table - Associate 30.0.10.0/24 subnet.
5) Add public Route to Public Route table.
6) 1 Private Route Table - Associate 30.0.40.0/24 subnet.
7) Create Security Group for EC2 - port 80, 22 - CIDR - <Your public IP> Should be passed dynamically.
8) Launch an EC2 instance in Public subnet, Install Apache and add a webpage.
9) Create Security Group for EC2 - port 3306 - CIDR - Only allow EC2 to connect to RDS.
10) Launch an RDS Instance - no multi AZ, db.t2.micro, Standard Monitoring, MySQL Engine.
11) The RDS Username and Password should be passed to TF during runtime.
```