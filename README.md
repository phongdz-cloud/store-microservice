# Microservice Demo Project

Đây là một dự án demo về microservice architecture sử dụng Spring Boot, bao gồm các service sau:

- Service Registry (Eureka Server)
- API Gateway
- Identity Service (với Keycloak)
- Product Service
- Order Service

## Công nghệ sử dụng

- Java 17
- Spring Boot 3.x
- Spring Cloud
- Spring Security
- Keycloak
- PostgreSQL
- Docker & Docker Compose
- Maven

## Cấu trúc dự án

```
microservice/
├── service-registry/        # Eureka Server
├── api-gateway/            # API Gateway
├── identity-service/       # Identity Service với Keycloak
├── product-service/        # Product Service
├── order-service/         # Order Service
├── docker-compose.yml     # Docker Compose configuration
└── run.sh                # Script để quản lý Docker services
```

## Yêu cầu hệ thống

- Java 17 hoặc cao hơn
- Maven 3.6.x hoặc cao hơn
- Docker và Docker Compose
- PostgreSQL (được cài đặt thông qua Docker)

## Cài đặt và chạy

1. Clone repository:

```bash
git clone <repository-url>
cd microservice
```

2. Build các service:

```bash
mvn clean package
```

3. Chạy các service bằng Docker Compose:

```bash
./run.sh start
```

Các service sẽ được khởi động với các port sau:

- Service Registry: http://localhost:8761
- API Gateway: http://localhost:8085
- Keycloak: http://localhost:8080
- Identity Service: http://localhost:8082
- Product Service: http://localhost:8081
- Order Service: http://localhost:8083

## Quản lý Docker Services

Script `run.sh` cung cấp các lệnh sau để quản lý Docker services:

```bash
./run.sh start       # Build và khởi động tất cả services
./run.sh up          # Khởi động services mà không build lại
./run.sh stop        # Dừng tất cả services
./run.sh restart     # Khởi động lại tất cả services
./run.sh clean       # Dừng và xóa tất cả containers và volumes
./run.sh logs        # Xem logs của tất cả services
./run.sh logs [service] # Xem logs của một service cụ thể
./run.sh build [service1] [service2] # Build lại một hoặc nhiều service
```

## Cấu hình Keycloak

1. Truy cập Keycloak Admin Console:

   - URL: http://localhost:8080
   - Username: admin
   - Password: admin

2. Tạo realm mới:

   - Click "Add realm"
   - Đặt tên realm (ví dụ: "microservice")

3. Tạo client:

   - Chọn realm vừa tạo
   - Vào "Clients" -> "Create client"
   - Client ID: api-gateway
   - Client Protocol: openid-connect
   - Access Type: confidential

4. Tạo user:
   - Vào "Users" -> "Add user"
   - Điền thông tin user
   - Vào tab "Credentials" để set password

## API Documentation

### Identity Service

- POST /api/auth/register - Đăng ký user mới
- POST /api/auth/login - Đăng nhập
- GET /api/users/me - Lấy thông tin user hiện tại

### Product Service

- GET /api/products - Lấy danh sách sản phẩm
- GET /api/products/{id} - Lấy thông tin sản phẩm
- POST /api/products - Tạo sản phẩm mới
- PUT /api/products/{id} - Cập nhật sản phẩm
- DELETE /api/products/{id} - Xóa sản phẩm

### Order Service

- GET /api/orders - Lấy danh sách đơn hàng
- GET /api/orders/{id} - Lấy thông tin đơn hàng
- POST /api/orders - Tạo đơn hàng mới
- PUT /api/orders/{id} - Cập nhật đơn hàng
- DELETE /api/orders/{id} - Xóa đơn hàng

## Contributing

1. Fork repository
2. Tạo branch mới (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add some amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Tạo Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
