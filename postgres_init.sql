-- Create databases
CREATE DATABASE keycloak;
CREATE DATABASE identity_db;
CREATE DATABASE product_db;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE keycloak TO postgres;
GRANT ALL PRIVILEGES ON DATABASE identity_db TO postgres;
GRANT ALL PRIVILEGES ON DATABASE product_db TO postgres; 