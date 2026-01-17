# Frontend ALB Security Group
resource "aws_security_group" "alb_frontend" {
  name        = "${var.project_name}-frontend-alb-sg"
  description = "Security group for frontend ALB"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-frontend-alb-sg"
  }
}

# Backend ALB Security Group
resource "aws_security_group" "alb_backend" {
  name        = "${var.project_name}-backend-alb-sg"
  description = "Security group for backend ALB"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-backend-alb-sg"
  }
}

# Frontend ECS Tasks Security Group
resource "aws_security_group" "ecs_frontend" {
  name        = "${var.project_name}-frontend-ecs-sg"
  description = "Security group for frontend ECS tasks"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    description     = "Allow traffic from frontend ALB"
    from_port       = var.frontend_container_port
    to_port         = var.frontend_container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_frontend.id]
  }
  
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-frontend-ecs-sg"
  }
}

# Backend ECS Tasks Security Group
resource "aws_security_group" "ecs_backend" {
  name        = "${var.project_name}-backend-ecs-sg"
  description = "Security group for backend ECS tasks"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    description     = "Allow traffic from backend ALB"
    from_port       = var.backend_container_port
    to_port         = var.backend_container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_backend.id]
  }
  
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-backend-ecs-sg"
  }
}

