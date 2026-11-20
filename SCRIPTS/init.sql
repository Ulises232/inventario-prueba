CREATE DATABASE IF NOT EXISTS inventario_db;
USE inventario_db;

CREATE TABLE IF NOT EXISTS roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(100) NOT NULL,
    id_rol INT NOT NULL,
    estatus INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

INSERT INTO roles (id_rol, nombre) VALUES
    (1, 'ADMINISTRADOR'),
    (2, 'ALMACENISTA')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

INSERT INTO usuarios (nombre, correo, contrasena, id_rol, estatus) VALUES
    ('Administrador', 'admin@inventario.local', '$2a$10$FbJEBtd4viCQ5v1u/VNp9.Rx1jcmdll2tSFRPcPuQjBbOc1sLAWhO', 1, 1),
    ('Almacenista', 'almacenista@inventario.local', '$2a$10$Dm8Jy1ab/cm7/vg7uDvv4OmBNeYbW3a8n0fxFP7cCbtlvbzbbU/SS', 2, 1)
ON DUPLICATE KEY UPDATE correo = VALUES(correo);


CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,
    precio DECIMAL(12, 2) NOT NULL,
    estatus BIT(1) NOT NULL DEFAULT b'1',
    fecha_alta DATETIME(6) NOT NULL,
    fecha_modificacion DATETIME(6) NULL,
    usuario_alta INT NOT NULL,
    usuario_modificacion INT NULL,
    CONSTRAINT fk_productos_usuario_alta FOREIGN KEY (usuario_alta) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_productos_usuario_modificacion FOREIGN KEY (usuario_modificacion) REFERENCES usuarios(id_usuario),
    CONSTRAINT chk_productos_nombre CHECK (CHAR_LENGTH(TRIM(nombre)) > 0),
    CONSTRAINT chk_productos_cantidad CHECK (cantidad >= 0),
    CONSTRAINT chk_productos_precio CHECK (precio > 0)
);

CREATE TABLE IF NOT EXISTS productos_historico (
    id_historico BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    accion ENUM('CREAR', 'ENTRADA', 'SALIDA') NOT NULL,
    cantidad_inicial INT NOT NULL,
    cantidad_final INT NOT NULL,
    id_usuario INT NOT NULL,
    fecha_movimiento DATETIME(6) NOT NULL,
    CONSTRAINT fk_historico_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_historico_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT chk_historico_cantidades CHECK (
        (accion = 'CREAR' AND cantidad_inicial = 0 AND cantidad_final = 0)
        OR (accion = 'ENTRADA' AND cantidad_inicial >= 0 AND cantidad_final > cantidad_inicial)
        OR (accion = 'SALIDA' AND cantidad_final >= 0 AND cantidad_inicial > cantidad_final)
    ),
    INDEX idx_historico_fecha (fecha_movimiento),
    INDEX idx_historico_accion_fecha (accion, fecha_movimiento)
);
