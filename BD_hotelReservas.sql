DROP DATABASE gestionHotelera;
CREATE DATABASE gestionHotelera;
use gestionHotelera;
 

--Crear tablas " FASE 3 "

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT,
    nombre VARCHAR(40) NOT NULL,
    apellido1 VARCHAR(40) NOT NULL,
    apellido2 VARCHAR(40),
    email VARCHAR(60) NOT NULL,
    CONSTRAINT pk_idCliente PRIMARY KEY (id_usuario),
    CONSTRAINT uq_correo UNIQUE (email)
);

CREATE TABLE peticiones(
    id_peticion INT AUTO_INCREMENT,
    id_usuario INT,
    peticion TEXT,
    CONSTRAINT pk_idPeticion PRIMARY KEY (id_peticion),
    CONSTRAINT fk_idUsuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE paises(
    id_pais INT AUTO_INCREMENT,
    nombre VARCHAR(40) NOT NULL,
    CONSTRAINT pk_idPais PRIMARY KEY (id_pais),
    CONSTRAINT uq_nombrePais UNIQUE (nombre)
);

CREATE TABLE provincias(
    id_provincia INT AUTO_INCREMENT,
    id_pais INT,
    nombre VARCHAR(40) NOT NULL,
    CONSTRAINT pk_idProvincia PRIMARY KEY (id_provincia),
    CONSTRAINT fk_idPais FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
);
 
CREATE TABLE cargos (
    id_cargo INT AUTO_INCREMENT,
    nombre_cargo VARCHAR (40) NOT NULL,
    sueldo DECIMAL (10,2) NOT NULL,
    CONSTRAINT pk_cargoID PRIMARY KEY (id_cargo)
);

CREATE TABLE tipoHabitacion(
    id_tipoHabitacion INT AUTO_INCREMENT,
    tipo_habitacion VARCHAR(10) NOT NULL,
    precio_noche DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_Tipohabitacion PRIMARY KEY (id_tipoHabitacion)  
);

CREATE TABLE habitaciones (
    num_habitacion VARCHAR(5) NOT NULL,
    tipoHabitacion INT NOT NULL,
    CONSTRAINT pk_habitacion PRIMARY KEY (num_habitacion),
    CONSTRAINT fk_tipoHabitacion FOREIGN KEY (tipoHabitacion) REFERENCES tipoHabitacion (id_tipoHabitacion)
);


CREATE TABLE empresa_excursiones (
    cifEmpresa VARCHAR(9) NOT NULL,
    nombreEmpresa VARCHAR(50) NOT NULL,
    CONSTRAINT fk_idEmpresa PRIMARY KEY (cifEmpresa)
);

CREATE TABLE empleados (
   id_empleado INT AUTO_INCREMENT,
   id_cargoEmpleado INT NOT NULL,
   NombreEmpleado VARCHAR (40) NOT NULL,
   apellidos VARCHAR (40) NOT NULL,
   dni VARCHAR (9) NOT NULL,
   domicilio VARCHAR (100) NOT NULL,
   CONSTRAINT pk_idEmpleado PRIMARY KEY (id_empleado),
   CONSTRAINT uq_dni UNIQUE (dni),
   CONSTRAINT fk_cargoEmpleado FOREIGN KEY (id_cargoEmpleado) REFERENCES cargos (id_cargo)
);

CREATE TABLE telefonos_empleados (
    id_empleado INT NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    CONSTRAINT pk_telefonoEmpleados PRIMARY KEY (id_empleado,telefono),
    CONSTRAINT fk_empleado_telefono FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado)
);

CREATE TABLE clientes (
    num_documento_cliente VARCHAR(9) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    domicilio VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    id_provincia INT NOT NULL,
    id_pais INT NOT NULL,
    CONSTRAINT pk_documentoCliente PRIMARY KEY (num_documento_cliente),
    CONSTRAINT fk_provinciaCliente FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia),
    CONSTRAINT fk_paisCliente FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
);
 
CREATE TABLE telefonos_clientes (
    num_documento_cliente VARCHAR (9) NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    CONSTRAINT pk_telefonoClientes PRIMARY KEY (num_documento_cliente ,telefono),
    CONSTRAINT fk_cliente_telefono FOREIGN KEY (num_documento_cliente) REFERENCES clientes (num_documento_cliente)
);

CREATE TABLE tipoServicio(
    id_tipo_servicio INT AUTO_INCREMENT,
    tipoServicio VARCHAR(100),
    CONSTRAINT pk_idTipoServicio PRIMARY KEY (id_tipo_servicio)
);

CREATE TABLE servicios_extras (
    id_servicio INT AUTO_INCREMENT,
    tipo_servicio INT NOT NULL,
    CONSTRAINT pk_servicio PRIMARY KEY (id_servicio),
    CONSTRAINT fk_tipoServicio FOREIGN KEY (tipo_servicio) REFERENCES tipoServicio(id_tipo_servicio)
);

CREATE TABLE reservas (
    numero_reserva INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_empleado INT NOT NULL,
    habitaciones_cantidad INT NOT NULL,
    numero_personas INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    num_habitacion VARCHAR(5) NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    CONSTRAINT pk_numeroReserva PRIMARY KEY (numero_reserva),
    CONSTRAINT fk_idClienteReserva FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario),
    CONSTRAINT fk_idEmpleadoReserva FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado),
    CONSTRAINT fk_num_habitacion_cliente FOREIGN KEY (num_habitacion) REFERENCES habitaciones (num_habitacion),
    CONSTRAINT chk_numeroPersonas CHECK (numero_personas <= 4)  
);
 
CREATE TABLE registroClientes (
    id_empleado INT NOT NULL,
    num_documento_cliente VARCHAR (9) NOT NULL,
    fecha_inicio DATETIME DEFAULT CURRENT_TIMESTAMP, 
    fecha_fin DATETIME,
    CONSTRAINT pk_registroCliente PRIMARY KEY
    (id_empleado,num_documento_cliente,fecha_inicio),
    CONSTRAINT fk_documentoClienteRegistro FOREIGN KEY (num_documento_cliente ) REFERENCES clientes (num_documento_cliente),
    CONSTRAINT fk_idEmpleadoRegistro FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado)  
);
 
CREATE TABLE Incluyen (
    num_reserva INT NOT NULL,
    num_documento_cliente VARCHAR (9) NOT NULL,
    CONSTRAINT pk_incluyen PRIMARY KEY (num_reserva, num_documento_cliente),
    CONSTRAINT fk_reserva_incluye FOREIGN KEY (num_reserva) REFERENCES  reservas (numero_reserva),
    CONSTRAINT fk_cliente_incluye FOREIGN KEY (num_documento_cliente)    REFERENCES clientes (num_documento_cliente)
);


CREATE TABLE facturas (
    id_factura INT AUTO_INCREMENT,
    num_documento_cliente VARCHAR(9) NOT NULL,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    precio_total DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_facturaid PRIMARY KEY (id_factura),
    CONSTRAINT fk_cliente_factura FOREIGN KEY (num_documento_cliente)REFERENCES clientes (num_documento_cliente)
);


CREATE TABLE detalles_facturas (
    id_detalle_factura INT AUTO_INCREMENT,
    id_factura INT NOT NULL,
    estado_pago ENUM('PAGADO','PENDIENTE'),
    igic INT DEFAULT 7 NOT NULL,
    tipo_pago VARCHAR(30),
    subtotal DECIMAL(10,2) NOT NULL,
    num_reserva INT,
    id_servicio INT,
    tipo_detalle ENUM('RESERVA','SERVICIO') NOT NULL,
    CONSTRAINT pk_factura_detalleId PRIMARY KEY (id_detalle_factura, id_factura),
    CONSTRAINT fk_detalle_reserva FOREIGN KEY (num_reserva) REFERENCES reservas (numero_reserva),
    CONSTRAINT fk_id_facturaD FOREIGN KEY (id_factura) REFERENCES facturas (id_factura),
    CONSTRAINT fk_id_servicio FOREIGN KEY (id_servicio) REFERENCES servicios_extras (id_servicio)
    );
    

CREATE TABLE reviews (
    id_review INT AUTO_INCREMENT,
    num_documento_cliente VARCHAR(9) NOT NULL,
    comentario TEXT NOT NULL,
    puntuacion INT NOT NULL,
    CONSTRAINT pk_reviewId PRIMARY KEY (id_review),
    CONSTRAINT fk_reviewCliente FOREIGN KEY (num_documento_cliente) REFERENCES clientes (num_documento_cliente)
);

CREATE TABLE tipoExcursion(
    id_tipoExcursion INT AUTO_INCREMENT,
    tipoExcursion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tipoExcursionID PRIMARY KEY (id_tipoExcursion)
);

CREATE TABLE excursiones (
    id_servicio INT NOT NULL,
    cifEmpresa VARCHAR(9) NOT NULL,
    tipoExcursion INT NOT NULL,
    nombreExcursion VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    lugar VARCHAR (50),
    fecha DATE NOT NULL,
    hora_salida TIME NOT NULL,
    hora_llegada TIME NOT NULL,
    CONSTRAINT pk_excursiones PRIMARY KEY (id_servicio),
    CONSTRAINT fk_servicioExcursiones FOREIGN KEY (id_servicio) REFERENCES servicios_extras (id_servicio),
    CONSTRAINT fk_empresaExcursion FOREIGN KEY (cifEmpresa) REFERENCES empresa_excursiones(cifEmpresa),
    CONSTRAINT fk_tipoExcursion FOREIGN KEY (tipoExcursion) REFERENCES tipoExcursion (id_tipoExcursion)
);

CREATE TABLE tipoVehiculo(
    id_tipoVehiculo INT AUTO_INCREMENT,
    tipoVehiculo VARCHAR (100) NOT NULL,
    precio_dia DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_tipoVehiculo PRIMARY KEY (id_tipoVehiculo)
);

CREATE TABLE alquiler_vehiculos (
    id_servicio INT NOT NULL,
    fecha_recogida DATE NOT NULL,
    fecha_entrega DATE NOT NULL,
    tipo_vehiculo INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_servicioAlquilerVehiculos PRIMARY KEY (id_servicio),
    CONSTRAINT fk_serviciosVehiculos FOREIGN KEY (id_servicio) REFERENCES servicios_extras(id_servicio),
    CONSTRAINT fK_tipoVehiculoID FOREIGN KEY (tipo_vehiculo) REFERENCES tipoVehiculo (id_tipoVehiculo)
);

CREATE TABLE servicioCliente(
    id_servicio INT NOT NULL,
    num_documento_cliente VARCHAR (9) NOT NULL,
    CONSTRAINT pk_servicioCliente PRIMARY KEY (id_servicio,num_documento_cliente),
    CONSTRAINT fk_servicioID FOREIGN KEY (id_servicio) REFERENCES servicios_extras (id_servicio),
    CONSTRAINT fk_clienteServicio FOREIGN KEY (num_documento_cliente) REFERENCES clientes (num_documento_cliente)
);



-- Insercion y Modificacion de datos " FASE 4"

--INSERTAMOS LOS REGISTROS DE LAS TABLAS


INSERT INTO usuarios (nombre, apellido1, apellido2, email) 
VALUES 
('Juan', 'Pérez', 'Gómez','juan.perez@example.com'), 
('Carlos', 'González', 'Hernández','carlos.gonzalez@example.com'), 
('Michael', 'Smith', NULL,'michael.smith@example.com'),
('Sofia', 'Garcia', 'Ramirez','sofia.garcia@example.com'), 
('Isabella', 'Müller', NULL,'isabella.muller@example.com'), 
('Hugo', 'Silva', 'Almeida', 'hugo.silva@example.com'), 
('Ethan', 'Kim', NULL, 'ethan.kim@example.com'), 
('Daniel', 'Ivanov', NULL,'daniel.ivanov@example.com'), 
('Liam', 'OConnor', NULL,'liam.oconnor@example.com'),
('Martin', 'Vega', 'Domínguez','martin.vega@example.com'), 
('Adriana', 'Gómez', 'Ramírez','adriana.gomez@example.com'), 
('Álvaro', 'López', NULL,'alvaro.lopez@example.com'), 
('Sofía', 'Martínez', 'Sanz','sofia.martinez@example.com');

INSERT INTO peticiones (id_usuario,peticion) 
VALUES 
(3,'Necesito acceso para silla de ruedas'),
(4,'Almohada extra, por favor'), 
(5,'Alergia a frutos secos'), 
(9,'Almohada extra, por favor');
 

INSERT INTO cargos (nombre_cargo, sueldo) 
VALUES
('Director', 8000.00),
('Subdirector', 6500.00),
('Jefe de Recepcion', 5500.00),
('Recepcionista', 2500.00),
('Conserje', 2200.00),
('Jefe de Cocina', 5000.00),
('Chef', 4000.00),
('Ayudante de Cocina', 2000.00),
('Cocinero', 1800.00),
('Barman', 2000.00),
('Camarero', 1900.00),
('Subgobernanta', 3000.00),
('Personal de Limpieza', 1500.00),
('Técnico de Mantenimiento', 2500.00),
('Gobernanta', 4900.00),
('Maitre', 5200.00);

INSERT INTO paises (nombre) 
VALUES
('Argentina'),
('Irlanda'),
('España'), 
('Alemania'), 
('Francia'), 
('Italia'), 
('Portugal'), 
('China'),
('Corea'),
('Reino Unido'),
('Estados Unidos');


INSERT INTO provincias (id_pais, nombre)
VALUES
(1,'Buenos Aires'),
(2,'Dublin'),
(3,'Alicante'),
(3,'Valladolid'),
(4,'Berlin'),
(3,'Gijón'),
(3,'Madrid'),
(5,'Paris'),
(3,'Barcelona'),
(6,'Roma'),
(3,'Sevilla'),
(7,'Lisboa'),
(3,'Valencia'),
(8,'Pekin'),
(3,'Bilbao'),
(9,'Seul'),
(10,'Londres'),
(3,'Málaga'),
(3,'Granada'),
(3,'Zaragoza'),
(3,'Murcia'),
(3,'Cádiz'),
(3,'Salamanca'),
(3,'Córdoba'),
(3,'Burgos'),
(3,'Huelva'),
(3,'León'),
(3,'Santiago'),
(3,'Oviedo'),
(3,'Toledo'),
(11,'Nueva York');

INSERT INTO empleados (id_cargoEmpleado, NombreEmpleado, apellidos, dni, domicilio) 
VALUES
(1, 'Luis', 'Pérez Gómez', '12345678A', 'Av. Central 45, Madrid'),
(2, 'Marta', 'López Martínez', '23456789B', 'Calle Mayor 12, Barcelona'),
(3, 'Juan', 'González Hernández', '34567890C', 'Calle del Sol 23, Sevilla'),
(4, 'Laura', 'Rodríguez Ruiz', '45678901D', 'Plaza Real 10, Valencia'),
(5, 'Carlos', 'Sánchez Torres', '56789012E', 'Calle Luna 8, Málaga'),
(6, 'Ana', 'Ramírez Ortega', '67890123F', 'Av. Marítima 33, Alicante'),
(7, 'Miguel', 'Fernández Vargas', '78901234G', 'Paseo del Río 15, Bilbao'),
(8, 'Raquel', 'Martínez Moreno', '89012345H', 'Calle Jardines 20, Granada'),
(9, 'Lucía', 'Moreno García', '90123456I', 'Av. de la Paz 14, Zaragoza'),
(10, 'José', 'Díaz Álvarez', '01234567J', 'Calle Palma 7, Toledo'),
(11, 'Carmen', 'Mendoza Soto', '11121314K', 'Av. Mediterráneo 21, Murcia'),
(12, 'Javier', 'Cruz Pacheco', '21231415L', 'Calle del Parque 4, Cádiz'),
(13, 'Sofía', 'Ortiz Castillo', '31341516M', 'Plaza Mayor 3, Salamanca'),
(14, 'Antonio', 'Castillo Luna', '41451617N', 'Calle del Olivo 18, Valladolid'),
(15, 'Rosa', 'Luna Romero', '51561718O', 'Av. España 56, Oviedo'),
(6, 'Pedro', 'Romero Iglesias', '61671819P', 'Calle de los Pinos 9, Santiago'),
(4, 'Clara', 'Iglesias Ramos', '71781920Q', 'Calle Alameda 12, León'),
(7, 'Ángel', 'Vega Campos', '81892021R', 'Plaza Nueva 17, Huelva'),
(2, 'Paula', 'Paredes López', '91902122S', 'Calle Buenavista 30, Burgos'),
(3, 'Hugo', 'López García', '02012223T', 'Av. Libertad 25, Córdoba');



INSERT INTO telefonos_empleados (id_empleado, telefono) 
VALUES
(1, '+34 600123456'),
(1, '+34 600654321'),
(2, '+34 601123456'),
(3, '+34 602123456'),
(4, '+34 603123456'),
(5, '+34 604123456'),
(6, '+34 605123456'),
(7, '+34 606123456'),
(8, '+34 607123456'),
(9, '+34 608123456'),
(10, '+34 609123456'),
(11, '+34 610123456'),
(12, '+34 611123456'),
(13, '+34 612123456'),
(14, '+34 613123456'),
(15, '+34 614123456'),
(16, '+34 615123456'),
(17, '+34 616123456'),
(18, '+34 617123456'),
(19, '+34 618123456'),
(20, '+34 619123456'),
(20, '+34 620987654');

INSERT INTO tipoHabitacion (tipo_habitacion,precio_noche)
VALUES
('Simple',50.00),
('Doble',75.00),
('Suite',120.00),
('Familiar', 90.00),
('Lujo', 200.00),
('Simple +',55.00),
('Doble +',80.00),
('Suite +',125.00),
('Familiar +',95.00),
('Lujo +', 210.00);
 
INSERT INTO habitaciones (num_habitacion, tipoHabitacion) 
VALUES
('101',1),
('102',1),
('103',1),
('104',1),
('105',1),
('201',2),
('202',2),
('203',2),
('204',2),
('205',2),
('301',3),
('302',3),
('303',3),
('304',3),
('305',3),
('401',4),
('402',4),
('403',4),
('404',4),
('405',4),
('501',5),
('502',5),
('503',5),
('504',5),
('505',5),
('601',6),
('602',7),
('603',8),
('604',9),
('605',10);

INSERT INTO clientes (num_documento_cliente, nombre, apellido1, apellido2, domicilio, fecha_nacimiento, id_provincia,id_pais) 
VALUES
('12345678A', 'Juan', 'Pérez', 'Gómez', 'Calle Gran Vía 10', '1990-05-12',7,3),
('23456789B', 'María', 'López', 'Martínez', 'Av. Diagonal 220', '1985-09-20',9,3),
('34567890C', 'Carlos', 'González', 'Hernández', 'Calle Sierpes 15', '1992-03-14',11,3),
('45678901D', 'Laura', 'Rodríguez', 'Ruiz', 'Plaza Ayuntamiento 3', '1998-07-08',13,3),
('56789012E', 'Ana', 'Sánchez', NULL, 'Paseo Abandoibarra 5', '1995-11-25',15,3),
('67890123F', 'Michael', 'Smith', NULL, '221B Baker Street', '1982-01-15',17,10),
('78901234G', 'Emma', 'Johnson', NULL, '123 Fifth Avenue', '1988-04-10',31,11),
('89012345H', 'Liam', 'Brown', 'Taylor', '789 Maple Street', '1990-08-22',31,11),
('90123456I', 'Sofia', 'Garcia', 'Ramirez', 'Calle 85 #12-34','1994-12-18',1,1),
('01234567J', 'Lucas', 'Martinez', 'Fernandez', 'Av. Corrientes 980', '1996-06-30',1,1),
('11121314K', 'Isabella', 'Müller', NULL, 'Kanzlerstrasse 12', '1991-02-05',5,4),
('21231415L', 'Noah', 'Dubois', NULL, 'Rue de Rivoli 42', '1989-09-12',8,5),
('31341516M', 'Amelia', 'Rossi', 'Bianchi', 'Via del Corso 8', '1987-10-19',10,6),
('41451617N', 'Hugo', 'Silva', 'Almeida', 'Rua Augusta 14', '1993-03-27',12,7),
('51561718O', 'Olivia', 'Wang', NULL, 'No. 5 Chang’an Avenue', '1992-07-15',14,8),
('61671819P', 'Ethan', 'Kim', NULL, 'Gangnam-daero 11, Seúl', '1995-05-23',16,9),
('71781920Q', 'Chloe', 'Nguyen', NULL, 'Calle Tran Hung Dao 33', '1990-11-03',14,8),
('81892021R', 'Daniel', 'Ivanov', NULL, 'Ulitsa Arbat 22', '1984-04-11',17,10),
('91902122S', 'Sophia', 'Leclerc', 'Martel', 'Rue Sainte-Catherine 78', '1986-12-28',31,11),
('02012223T', 'Liam', 'O`Connor', NULL, '15 St. Stephen`s Green', '1997-06-14',2,2),
('32323232U', 'Alicia', 'Castro', NULL, 'Calle Luna 45', '1992-02-12',7,3),
('43434343V', 'Martin', 'Vega', 'Domínguez', 'Av. Libertad 60', '1993-06-25',13,3),
('54545454W', 'Sergio', 'Moreno', 'Álvarez', 'Paseo Prado 11', '1994-11-08',11,3), 
('65656565X', 'Nuria', 'Reyes', NULL, 'Av. Marítima 90', '1990-09-15',9,3), 
('76767676Y', 'Adriana', 'Gómez', 'Ramírez', 'Calle Central 34', '1995-03-05',18,3), 
('87878787Z', 'Manuel', 'Fernández', NULL, 'Calle Mayor 12', '1989-07-21',15,3), 
('98989898A', 'Lucía', 'Hernández', 'Pérez', 'Av. América 75', '1991-05-10',20,3), 
('10101010B', 'Álvaro', 'López', NULL, 'Calle Jardín 20', '1996-12-02', 3,3), 
('11111111C', 'Sofía', 'Martínez', 'Sanz', 'Paseo Real 33', '1988-08-19',4,3), 
('12121212D', 'Mario', 'Ruiz', 'Fernández', 'Calle Colón 9', '1987-01-30',6,3);


INSERT INTO telefonos_clientes (num_documento_cliente, telefono) 
VALUES
('12345678A', '+34 600123456'),
('12345678A', '+34 610654321'),
('23456789B', '+34 611223344'),
('34567890C', '+34 622334455'),
('45678901D', '+34 633445566'),
('56789012E', '+34 644556677'),
('67890123F', '+44 700123456'),
('78901234G', '+1 2123456789'),
('89012345H', '+1 4167890123'),
('90123456I', '+57 3101234567'),
('01234567J', '+54 91123456789'),
('11121314K', '+49 15112345678'),
('21231415L', '+33 612345678'),
('31341516M', '+39 3214567890'),
('41451617N', '+351 912345678'),
('51561718O', '+86 13123456789'),
('61671819P', '+82 1023456789'),
('71781920Q', '+84 982345678'),
('81892021R', '+7 9123456789'),
('91902122S', '+1 5149876543'),
('02012223T', '+353 851234567');
 
INSERT INTO telefonos_clientes (num_documento_cliente, telefono) 
VALUES 
('23456789B', '+34 622223344'), 
('34567890C', '+34 633334455'), 
('45678901D', '+34 644445566'), 
('56789012E', '+34 655556677'), 
('67890123F', '+44 700234567'), 
('78901234G', '+1 2134567890'), 
('89012345H', '+1 4168901234'), 
('90123456I', '+57 3102345678'), 
('01234567J', '+54 91134567890'),
('11121314K', '+49 15123456789'), 
('21231415L', '+33 613456789'), 
('31341516M', '+39 3215678901'), 
('41451617N', '+351 913456789'), 
('51561718O', '+86 13234567890'), 
('61671819P', '+82 1034567890');

INSERT INTO tipoServicio (tipoServicio) 
VALUES
('Alquiler'),
('Excursiones'),
('Caja Fuerte');
 
INSERT INTO servicios_extras (tipo_servicio) 
VALUES
(1),
(1),
(1),
(1),
(2),
(1),
(2),
(1),
(2),
(1),
(2),
(2),
(2),
(2),
(2),
(1),
(1),
(2),
(1),
(2),
(1);


INSERT INTO empresa_excursiones (cifEmpresa, nombreEmpresa) 
VALUES
('B12345678', 'Aventura Tours'),
('A23456789', 'Excursiones del Valle'),
('C34567890', 'Rutas Mágicas'),
('D45678901', 'Viajes EcoExplorer'),
('E56789012', 'Turismo Aventura'),
('F67890123', 'Explora el Mundo'),
('G78901234', 'Recorridos Naturales'),
('H89012345', 'Viajando por la Historia'),
('I90123456', 'Rutas y Senderos'),
('J01234567', 'Escapadas Extremas');
 
INSERT INTO reservas (id_usuario, id_empleado, num_habitacion, habitaciones_cantidad, numero_personas, fecha_inicio, fecha_fin, precio) 
VALUES 
(1, 4, '101', 1, 2, '2024-12-10 14:00:00', '2024-12-15 12:00:00', 500.00),
(2, 17, '102', 1, 3, '2024-12-12 16:00:00', '2024-12-17 11:00:00', 750.00),
(3, 3, '103', 1, 2, '2024-12-14 18:00:00', '2024-12-19 09:00:00', 500.00),
(5, 20, '104', 2, 4, '2024-12-16 15:00:00', '2024-12-20 10:00:00', 800.00),
(4, 2, '105', 1, 2, '2024-12-18 14:00:00', '2024-12-22 12:00:00', 400.00), 
(6, 18, '201', 1, 1, '2024-12-19 12:00:00', '2024-12-21 11:00:00', 150.00),
(2, 4, '202', 1, 3, '2024-12-20 13:00:00', '2024-12-24 10:00:00', 900.00), 
(8, 17, '203', 1, 2, '2024-12-21 15:00:00', '2024-12-25 12:00:00', 600.00),
(1, 3, '204', 1, 2, '2024-12-22 14:00:00', '2024-12-26 11:00:00', 600.00),
(10, 20, '205', 2, 4, '2024-12-23 13:00:00', '2024-12-28 10:00:00', 1500.00),
(4, 2, '301', 1, 2, '2024-12-24 14:00:00', '2024-12-29 12:00:00', 1200.00),
(9, 18, '302', 1, 1, '2024-12-25 16:00:00', '2024-12-28 10:00:00', 360.00),
(7, 4, '303', 1, 3, '2024-12-26 17:00:00', '2024-12-30 12:00:00', 1440.00),
(11, 17, '304', 1, 2, '2024-12-27 14:00:00', '2024-12-31 11:00:00', 960.00),
(12, 3, '305', 1, 2, '2024-12-28 12:00:00', '2024-12-31 10:00:00', 720.00),
(1, 2, '402', 1, 1, '2024-12-30 16:00:00', '2025-01-02 09:00:00', 270.00),
(4, 18, '403', 1, 2, '2024-12-31 15:00:00', '2025-01-04 10:00:00', 720.00),
(13, 4, '404', 1, 3, '2025-01-02 14:00:00', '2025-01-06 12:00:00', 1080.00),
(1, 4, '505', 1, 2, '2025-01-09 16:00:00', '2025-01-12 10:00:00', 1200.00);



INSERT INTO registroClientes (id_empleado, num_documento_cliente, fecha_inicio, fecha_fin) 
VALUES 
(4, '12345678A', '2024-12-10 14:00:00', '2024-12-15 12:00:00'), 
(4, '23456789B', '2024-12-10 14:00:00', '2024-12-15 12:00:00'),
(2, '34567890C', '2024-12-12 16:00:00', '2024-12-17 11:00:00'), 
(2, '45678901D', '2024-12-12 16:00:00', '2024-12-17 11:00:00'), 
(2, '56789012E', '2024-12-12 16:00:00', '2024-12-17 11:00:00'), 
(17, '67890123F', '2024-12-14 18:00:00', '2024-12-19 09:00:00'), 
(17, '78901234G', '2024-12-14 18:00:00', '2024-12-19 09:00:00'),
(4, '89012345H', '2024-12-16 15:00:00', '2024-12-20 10:00:00'), 
(4, '11121314K', '2024-12-16 15:00:00', '2024-12-20 10:00:00'), 
(4, '21231415L', '2024-12-16 15:00:00', '2024-12-20 10:00:00'), 
(4, '31341516M', '2024-12-16 15:00:00', '2024-12-20 10:00:00'),
(17, '90123456I', '2024-12-18 14:00:00', '2024-12-22 12:00:00'), 
(17, '01234567J', '2024-12-18 14:00:00', '2024-12-22 12:00:00'),
(17, '41451617N', '2024-12-19 12:00:00', '2024-12-21 11:00:00'),
(4, '34567890C', '2024-12-20 13:00:00', '2024-12-24 10:00:00'), 
(4, '45678901D', '2024-12-20 13:00:00', '2024-12-24 10:00:00'), 
(4, '56789012E', '2024-12-20 13:00:00', '2024-12-24 10:00:00'),
(4, '81892021R', '2024-12-21 15:00:00', '2024-12-25 12:00:00'), 
(4, '91902122S', '2024-12-21 15:00:00', '2024-12-25 12:00:00'),
(17, '12345678A', '2024-12-22 14:00:00', '2024-12-26 11:00:00'), 
(17, '23456789B', '2024-12-22 14:00:00', '2024-12-26 11:00:00'),
(17, '32323232U', '2024-12-23 13:00:00', '2024-12-28 10:00:00'), 
(17, '43434343V', '2024-12-23 13:00:00', '2024-12-28 10:00:00'), 
(17, '54545454W', '2024-12-23 13:00:00', '2024-12-28 10:00:00'), 
(17, '65656565X', '2024-12-23 13:00:00', '2024-12-28 10:00:00'),
(4, '90123456I', '2024-12-24 14:00:00', '2024-12-29 12:00:00'), 
(4, '01234567J', '2024-12-24 14:00:00', '2024-12-29 12:00:00'),
(4, '02012223T', '2024-12-25 16:00:00', '2024-12-28 10:00:00'), 
(3, '51561718O', '2024-12-26 17:00:00', '2024-12-30 12:00:00'), 
(3, '61671819P', '2024-12-26 17:00:00', '2024-12-30 12:00:00'), 
(3, '71781920Q', '2024-12-26 17:00:00', '2024-12-30 12:00:00'),
(2, '76767676Y', '2024-12-27 14:00:00', '2024-12-31 11:00:00'), 
(2, '87878787Z', '2024-12-27 14:00:00', '2024-12-31 11:00:00'),
(17, '98989898A', '2024-12-28 12:00:00', '2024-12-31 10:00:00'), 
(17, '10101010B', '2024-12-28 12:00:00', '2024-12-31 10:00:00'),
(3, '12345678A', '2024-12-30 16:00:00', '2025-01-02 09:00:00'),
(4, '90123456I', '2024-12-31 15:00:00', '2025-01-04 10:00:00'), 
(4, '01234567J', '2024-12-31 15:00:00', '2025-01-04 10:00:00'),
(17, '11111111C', '2025-01-02 14:00:00', '2025-01-06 12:00:00'), 
(17, '12121212D', '2025-01-02 14:00:00', '2025-01-06 12:00:00'),
(17, '12345678A', '2025-01-09 16:00:00', '2025-01-12 10:00:00'),
(17, '23456789B', '2025-01-09 16:00:00', '2025-01-12 10:00:00');

INSERT INTO Incluyen (num_reserva, num_documento_cliente) 
VALUES 
(1, '12345678A'), 
(1, '23456789B'),
(2, '34567890C'),
(2, '45678901D'),
(2, '56789012E'),
(3, '67890123F'),
(3, '78901234G'),
(4, '89012345H'),
(4, '11121314K'),
(4, '21231415L'),
(4, '31341516M'),
(5, '90123456I'),
(5, '01234567J'),
(6, '41451617N'),
(7, '45678901D'),
(7, '56789012E'),
(8, '81892021R'),
(8, '91902122S'),
(9, '12345678A'),
(9, '23456789B'),
(10, '32323232U'),
(10, '43434343V'),
(10, '54545454W'),
(10, '65656565X'),
(11, '90123456I'),
(11, '01234567J'),
(12, '02012223T'),
(13, '51561718O'),
(13, '61671819P'),
(13, '71781920Q'),
(14, '76767676Y'),
(14, '87878787Z'),
(15, '98989898A'),
(15, '10101010B'),
(16, '12345678A'),
(17, '90123456I'),
(17, '01234567J'),
(18, '11111111C'),
(18, '12121212D'),
(19, '12345678A'),
(19, '23456789B');
 

INSERT INTO facturas (num_documento_cliente, precio_total) 
VALUES 
('45678901D', 342.40), 
('12345678A', 863.80), 
('89012345H', 80.25), 
('34567890C', 910.50), 
('21231415L', 128.40), 
('78901234G', 481.50), 
('67890123F', 607.00), 
('11121314K', 800.00), 
('45678901D', 53.50), 
('41451617N', 342.60), 
('90123456I', 464.20), 
('34567890C', 1114.00),
('81892021R', 835.40),
('12345678A', 749.80),
('87878787Z', 246.10), 
('43434343V', 1821.00), 
('02012223T', 360.00), 
('90123456I', 1200.00), 
('51561718O', 267.50), 
('61671819P', 1440.00), 
('10101010B', 720.00), 
('76767676Y', 960.00), 
('12345678A', 484.00), 
('90123456I', 720.00), 
('11111111C', 1486.60), 
('12345678A', 1200.00);
 
INSERT INTO detalles_facturas (id_factura, estado_pago, IGIC, tipo_pago, subtotal, num_reserva, id_servicio, tipo_detalle)
VALUES
(1, 'PAGADO', 22.40, 'EFECTIVO', 320.00, 2, 2, 'SERVICIO'),
(2, 'PAGADO', 32.71, 'TARJETA', 467.29, 1, NULL, 'RESERVA'),
(2, 'PAGADO', 17.50, 'EFECTIVO', 250.00, 1, 1, 'SERVICIO'),
(9, 'PAGADO', 6.30, 'EFECTIVO', 90.00, 2, 13, 'SERVICIO'),
(3, 'PAGADO', 5.25, 'TARJETA', 75.00, 4, 9, 'SERVICIO'),
(4, 'PAGADO', 49.07, 'TARJETA', 700.93, 2, NULL, 'RESERVA'),
(4, 'PAGADO', 10.50, 'EFECTIVO', 150.00, 2, 5, 'SERVICIO'),
(5, 'PAGADO', 8.40, 'EFECTIVO', 120.00, 4, 11, 'SERVICIO'),
(6, 'PAGADO', 31.50, 'TARJETA', 450.00, 3, 3, 'SERVICIO'),
(7, 'PAGADO', 32.71, 'EFECTIVO', 467.29, 3, NULL, 'RESERVA'),
(7, 'PAGADO', 7.00, 'EFECTIVO', 100.00, 3, 7, 'SERVICIO'),
(8, 'PAGADO', 52.34, 'TRANSFERENCIA', 747.66, 4, NULL, 'RESERVA'),
(9, 'PAGADO', 3.50, 'EFECTIVO', 50.00, 7, 14, 'SERVICIO'),
(10, 'PAGADO', 9.81, 'EFECTIVO', 140.19, 6, NULL, 'RESERVA'),
(10, 'PAGADO', 12.60, 'TARJETA', 180.00, 6, 4, 'SERVICIO'),
(11, 'PAGADO', 26.17, 'TARJETA', 373.83, 5, NULL, 'RESERVA'),
(11, 'PAGADO', 4.20, 'EFECTIVO', 60.00, 5, 12, 'SERVICIO'),
(12, 'PAGADO', 58.88, 'TARJETA', 841.12, 7, NULL, 'RESERVA'),
(12, 'PAGADO', 14.00, 'TARJETA', 200.00, 7, 8, 'SERVICIO'),
(13, 'PAGADO', 39.25, 'TARJETA', 560.75, 8, NULL, 'RESERVA'),
(13, 'PAGADO', 5.95, 'EFECTIVO', 85.00, 8, 15, 'SERVICIO'),
(13, 'PAGADO', 6.65, 'TARJETA', 95.00, 8, 18, 'SERVICIO'),
(13, 'PAGADO', 2.80, 'EFECTIVO', 40.00, 8, 20, 'SERVICIO'),
(14, 'PAGADO', 39.25, 'TARJETA', 560.75, 9, NULL, 'RESERVA'),
(14, 'PAGADO', 9.80, 'EFECTIVO', 140.00, 9, 16, 'SERVICIO'),
(15, 'PAGADO', 16.10, 'TARJETA', 230.00, 9, 17, 'SERVICIO'),
(16, 'PAGADO', 98.13, 'TARJETA', 1401.87, 10, NULL, 'RESERVA'),
(16, 'PAGADO', 21.00, 'TARJETA', 300.00, 10, 10, 'SERVICIO'),
(17, 'PAGADO', 23.55, 'TARJETA', 336.45, 12, NULL, 'RESERVA'),
(18, 'PAGADO', 78.50, 'TRANSFERENCIA', 1121.50, 11, NULL, 'RESERVA'),
(19, 'PAGADO', 17.50, 'EFECTIVO', 250.00, 13, 7, 'SERVICIO'),
(20, 'PAGADO', 94.21, 'TRANSFERENCIA', 1345.79, 13, NULL, 'RESERVA'),
(21, 'PAGADO', 47.10, 'TARJETA', 672.90, 15, NULL, 'RESERVA'),
(22, 'PENDIENTE', 62.80, 'TARJETA', 897.20, 14, NULL, 'RESERVA'),
(23, 'PENDIENTE', 17.66, 'TARJETA', 252.34, 16, NULL, 'RESERVA'),
(23, 'PAGADO', 14.00, 'EFECTIVO', 200.00, 16, 19, 'SERVICIO'),
(24, 'PAGADO', 47.10, 'TARJETA', 672.90, 17, NULL, 'RESERVA'),
(25, 'PENDIENTE', 70.65, 'TARJETA', 1009.35, 18, NULL, 'RESERVA'),
(25, 'PENDIENTE', 26.60, 'TRANSFERENCIA', 380.00, 18, 21, 'SERVICIO'),
(26, 'PENDIENTE', 78.50, 'TRANSFERENCIA', 1121.50, 19, NULL, 'RESERVA');

INSERT INTO tipoExcursion (tipoExcursion ) 
VALUES
('Aventura'),
('Senderismo'),
('Cultural'),
('Acuático'),
('Deportivo');

INSERT INTO excursiones (id_servicio,cifEmpresa, tipoExcursion, nombreExcursion, precio, lugar, fecha, hora_salida, hora_llegada) 
VALUES 
(5,'B12345678', 1, 'Buceo en Sardina', 150.00, 'Faro de Sardina', '2024-12-15', '08:00:00', '18:00:00'), 
(7,'A23456789', 2, 'Ruta de los Volcanes', 100.00, 'Parque Natural de Tamadaba', '2024-12-16', '09:00:00', '16:00:00'), 
(9,'C34567890', 3, 'Visita Guiada al Roque Nublo', 75.00, 'Roque Nublo', '2024-12-17', '10:00:00', '14:00:00'), 
(11,'D45678901', 1, 'Safari en el Desierto de Maspalomas', 120.00, 'Maspalomas', '2024-12-18', '08:30:00', '17:00:00'), 
(12,'E56789012', 4, 'Excursión en Kayak por la Costa', 60.00, 'Playa de Las Canteras', '2024-12-19', '09:00:00', '12:00:00'), 
(13,'F67890123', 1, 'Excursión en Quad por el Barranco de Guayadeque', 90.00, 'Barranco de Guayadeque', '2024-12-23', '10:00:00', '13:00:00'), 
(14,'G78901234', 3, 'Tour por los Pueblos Históricos de Gran Canaria', 50.00, 'Tejeda', '2024-12-21', '11:00:00', '15:00:00'), 
(15,'H89012345', 1, 'Rutas en 4x4 por la Caldera de Bandama', 85.00, 'Caldera de Bandama', '2024-12-22', '08:00:00', '14:00:00'), 
(18,'I90123456', 2, 'Ascenso al Pico de las Nieves', 95.00, 'Pico de las Nieves', '2024-12-23', '07:00:00', '12:00:00'), 
(20,'J01234567', 3, 'Tour por la Ciudad de Las Palmas', 40.00, 'Las Palmas de Gran Canaria', '2024-12-24', '09:00:00', '12:00:00');
 
INSERT INTO tipoVehiculo (tipoVehiculo,precio_dia) 
VALUES
('Coche compacto', 50.00),
('SUV', 64.00),
('Coche de lujo',90.00),
('Monovolumen',36.00),
('Covertible',62.50),
('Coche eléctrico',50.00),
('Furgoneta', 60.00);

INSERT INTO alquiler_vehiculos (id_servicio, fecha_recogida, fecha_entrega, tipo_vehiculo, precio) 
VALUES
(1, '2024-12-10', '2024-12-15',1, 250.00),
(2, '2024-12-12', '2024-12-17',2, 320.00),
(3, '2024-12-14', '2024-12-19',3, 450.00),
(4, '2024-12-18', '2024-12-21', 4, 180.00),
(6, '2024-12-26', '2024-12-30', 5, 250.00),
(8, '2024-12-20', '2024-12-24', 6, 200.00),
(10, '2024-12-21', '2024-12-26',7, 300.00),
(16, '2024-12-22', '2024-12-26', 1, 140.00),
(17, '2024-12-27', '2024-12-31', 2, 230.00),
(19, '2024-12-30', '2025-01-02', 4, 200.00),
(21, '2025-01-02', '2025-01-06', 3, 380.00);
 
INSERT INTO servicioCliente (id_servicio, num_documento_cliente) 
VALUES
(1, '12345678A'), 
(2, '45678901D'), 
(3, '78901234G'), 
(4, '41451617N'), 
(5, '34567890C'), 
(6, '51561718O'), 
(7, '67890123F'), 
(8, '34567890C'), 
(9, '89012345H'), 
(10, '43434343V'), 
(11, '21231415L'), 
(12, '90123456I'), 
(13, '12345678A'), 
(14, '45678901D'), 
(15, '81892021R'), 
(16, '12345678A'), 
(17, '87878787Z'), 
(18, '81892021R'), 
(19, '12345678A'), 
(20, '81892021R'), 
(21, '11111111C');
 

INSERT INTO reviews (comentario, puntuacion, num_documento_cliente) 
VALUES
('Excelente servicio y atención al cliente, todo perfecto.', 5, '12345678A'),
('La habitación estaba limpia, pero el desayuno podría mejorar.', 4, '23456789B'),
('El personal fue amable, pero hubo problemas con la reserva.', 3, '34567890C'),
('Todo fue perfecto, desde el check-in hasta el check-out.', 5, '45678901D'),
('El hotel estaba en una buena ubicación, pero era algo ruidoso.', 4, '56789012E'),
('No me gustó la comida del restaurante, esperaba más calidad.', 2, '67890123F'),
('La suite era increíble, espaciosa y con vistas hermosas.', 5, '78901234G'),
('El servicio de limpieza tardó mucho en atender mi solicitud.', 3, '89012345H'),
('Un hotel muy cómodo y tranquilo, lo recomendaría.', 5, '90123456I'),
('La conexión Wi-Fi era lenta y se interrumpía frecuentemente.', 2, '01234567J'),
('Buena relación calidad-precio, repetiría sin duda.', 4, '11121314K'),
('La piscina estaba cerrada por mantenimiento, decepcionante.', 2, '21231415L'),
('El personal fue muy atento y servicial, un gran equipo.', 5, '31341516M'),
('El aire acondicionado de la habitación no funcionaba bien.', 3, '41451617N'),
('Todo estuvo excelente, especialmente la comida y la limpieza.', 5, '51561718O'),
('La habitación era pequeña, pero estaba limpia y acogedora.', 4, '61671819P'),
('El spa del hotel fue lo mejor de mi experiencia.', 5, '71781920Q'),
('Había demasiado ruido en los pasillos por las noches.', 2, '81892021R'),
('El hotel estaba bien, pero el servicio al cliente fue deficiente.', 3, '91902122S'),
('Mi estancia fue maravillosa, volveré el próximo año.', 5, '02012223T');



--Indicar la instrucción en formato texto  update para modificar los datos de dos tablas como mínimos. (Updates complejos con filtros o cálculos)

---	Incrementar un 10% al precio de los servicios de excursiones y su precio en detalle factura.

UPDATE excursiones
    SET precio = precio+(precio*0.10);

UPDATE detalles_facturas
    SET subtotal = subtotal + (subtotal * 0.10), IGIC = IGIC + (IGIC * 0.10)
    WHERE id_servicio IN (SELECT id_servicio FROM excursiones);

-- PRIMERA FORMA 
/**
UPDATE facturas f 
SET precio_total = precio_total + ( 
SELECT ROUND(SUM(((df.subtotal / 1.10) * 0.10) + ((df.igic / 1.10) * 0.10)), 2)
FROM detalles_facturas df 
WHERE df.id_factura = f.id_factura AND df.id_servicio IN (
SELECT id_servicio FROM excursiones) ) 
WHERE id_factura IN ( 
SELECT id_factura FROM detalles_facturas 
WHERE id_servicio IN (
SELECT id_servicio FROM excursiones) 
GROUP BY id_factura );

**/
-- SEGUNDA FORMA

UPDATE facturas f 
SET precio_total = precio_total + ( 
SELECT ROUND(SUM(((df.subtotal / 1.10) * 0.10) + ((df.igic / 1.10) * 0.10)), 2)
FROM detalles_facturas df 
JOIN excursiones e ON e.id_servicio = df.id_servicio
WHERE df.id_factura = f.id_factura
)WHERE EXISTS (SELECT 1 FROM detalles_facturas df
            JOIN excursiones e ON e.id_servicio = df.id_servicio
            WHERE df.id_factura = f.id_factura);


--Indicar las instrucciones en formato texto delete para eliminar al menos 4 registros de 3 tablas, realizando algún filtro complejo. 
--Debe respetarse la integridad referencial de todas las tablas. No se puede eliminar la integridad referencial.

--Eliminar reviews

DELETE r 
FROM reviews r
JOIN clientes c ON c.num_documento_cliente = r.num_documento_cliente
JOIN registroClientes rc ON rc.num_documento_cliente = c.num_documento_cliente
WHERE rc.fecha_fin BETWEEN '2024-12-10' AND '2024-12-20';

--Eliminar telefonos cliente

DELETE tc 
FROM telefonos_clientes tc
JOIN clientes c ON c.num_documento_cliente = tc.num_documento_cliente
JOIN registroClientes rc ON rc.num_documento_cliente = c.num_documento_cliente
WHERE rc.fecha_fin BETWEEN '2024-12-10' AND '2024-12-20';

--Eliminar registro de cliente

DELETE FROM registroClientes 
WHERE fecha_fin BETWEEN '2024-12-10' AND '2024-12-20';
















--TABLA HABITACIONES









--CONSULTAS " FASE 6 "

-- 1º ¿Cuántas reservas se realizaron para el mes de diciembre de 2024? ¿Y cuales de ellas su salida fue en enero de 2025?
SELECT * FROM RESERVAS 
WHERE fecha_inicio BETWEEN '2024-12-01 00:00:00' AND '2024-12-31 23:59:59'; 

SELECT * FROM RESERVAS 
WHERE fecha_inicio BETWEEN '2024-12-01 00:00:00' AND '2024-12-31 23:59:59' 
AND fecha_fin BETWEEN '2025-01-01 00:00:00' AND '2025-01-31 23:59:59';

-- 2º ¿Indica qué clientes tienen facturas pendientes de pago? Además, indica la suma total pendiente por cliente.

SELECT c.num_documento_cliente AS 'Documento', CONCAT(c.nombre, " ", c.apellido1," ", COALESCE(c.apellido2, " ")) AS 'Nombre Completo', SUM(f.precio_total) AS 'Importe Total Pendiente'
FROM clientes c 
JOIN facturas f ON c.num_documento_cliente = f.num_documento_cliente
JOIN detalles_facturas df ON f.id_factura = df.id_factura
WHERE estado_pago = 'PENDIENTE'
GROUP by c.num_documento_cliente;


-- 3º- ¿Cuántos clientes se han registrado son Madrid que tengan servicios extras?
SELECT c.*, ts.tipoServicio FROM clientes c 
JOIN facturas f ON c.num_documento_cliente = f.num_documento_cliente
JOIN detalles_facturas df ON f.id_factura = df.id_factura
JOIN tipoServicio ts ON df.id_servicio = ts.id_tipo_servicio
WHERE c.id_provincia = (
    SELECT p.id_provincia
    FROM provincias p
    WHERE p.nombre = 'Madrid'
);



-- 4º- Calcula el total facturado por cada cliente y ordena los resultados de mayor a menor.
SELECT c.*, SUM(f.precio_total) AS "Total Facturas" FROM clientes c
JOIN facturas f ON c.num_documento_cliente = f.num_documento_cliente
WHERE EXISTS (SELECT f.num_documento_cliente FROM facturas f
    WHERE f.num_documento_cliente= c.num_documento_cliente )
GROUP BY c.num_documento_cliente
ORDER BY SUM(f.precio_total) DESC;


-- 5º - Haz un listado con UNION de los servicios de excursión y alquiler, mostrando su nombre y precio.
--  Diferenciados por columnas para cada tipo por cliente (id y nombre completo en una columna) que posea un servicio.

SELECT c.num_documento_cliente, CONCAT (c.nombre, " ", c.apellido1, " ", COALESCE(c.apellido2, " ")) AS "Nombre Completo", 
ex.nombreExcursion AS "Excursión", ex.precio AS "Precio Excursión", ' ' AS "Vehículo", ' ' AS "Precio Vehículo"
FROM clientes c 
JOIN servicioCliente sc ON c.num_documento_cliente = sc.num_documento_cliente
JOIN servicios_extras se ON sc.id_servicio = se.id_servicio
JOIN excursiones ex ON se.id_servicio = ex.id_servicio
UNION
SELECT c.num_documento_cliente, CONCAT (c.nombre, " ", c.apellido1, " ", COALESCE(c.apellido2, " ")) AS "Nombre Completo", 
' ' AS "Excursión", ' ' AS "Precio Excursión", tv.tipoVehiculo AS "Vehículo", av.precio "Precio Vehículo"
FROM clientes c 
JOIN servicioCliente sc ON c.num_documento_cliente = sc.num_documento_cliente
JOIN servicios_extras se ON sc.id_servicio = se.id_servicio
JOIN alquiler_vehiculos av ON se.id_servicio = av.id_servicio
JOIN tipoVehiculo tv ON av.tipo_vehiculo = tv.id_tipoVehiculo; 

-- 6º-Teniendo en cuenta cada empleado que ha realizado registros, muestra el nombre del empleado y categoría. Además calcula la media de ingresos de todas las facturas de los 
-- clientes que haya registrado cada empleado y Ordénalo de manera ascendente.

SELECT CONCAT(e.NombreEmpleado, " ", e.apellidos) AS "Nombre Empleado", c.nombre_cargo AS "Cargo", 
ROUND(AVG(f.precio_total),2) AS "Media Facturado"
FROM empleados e 
JOIN cargos c ON e.id_cargoEmpleado = c.id_cargo
JOIN registroClientes rc ON e.id_empleado = rc.id_empleado
JOIN facturas f ON rc.num_documento_cliente = f.num_documento_cliente
JOIN detalles_facturas df ON f.id_factura = df.id_factura
WHERE (estado_pago = "PAGADO")
GROUP BY e.id_empleado, c.nombre_cargo
ORDER BY "Media Facturado" ASC;

-- 7º Muestra un listado de los detalles de facturas impagas, junto con el nombre del cliente, indica el importe y
-- por separado indica el de que si se trata de reserva o servicio, y a que factura está vinculada.

SELECT CONCAT(c.nombre, " ", c.apellido1, " ", COALESCE(c.apellido2, "")) AS "Nombre Cliente", 
df.subtotal AS "Subtotal Pendiente", df.num_reserva AS "Reserva", df.tipo_detalle AS "Servicio",
f.id_factura AS "Factura"
FROM clientes c
JOIN facturas f ON c.num_documento_cliente = f.num_documento_cliente
JOIN detalles_facturas df ON f.id_factura = df.id_factura
WHERE (df.estado_pago = "PENDIENTE" AND df.tipo_detalle = "RESERVA")
UNION
SELECT CONCAT(c.nombre, " ", c.apellido1, " ", COALESCE(c.apellido2, "")) AS "Nombre Cliente", 
df.subtotal AS "Subtotal Pendiente", df.num_reserva AS "Reserva", 
CONCAT(df.tipo_detalle," (", ts.tipoServicio ,")") AS "Servicio",
f.id_factura AS "Factura"
FROM clientes c
JOIN facturas f ON c.num_documento_cliente = f.num_documento_cliente
JOIN detalles_facturas df ON f.id_factura = df.id_factura
JOIN servicioCliente sc ON c.num_documento_cliente = sc.num_documento_cliente
JOIN servicios_extras se ON sc.id_servicio = se.id_servicio
JOIN tipoServicio ts ON se.tipo_servicio = ts.id_tipo_servicio
WHERE (df.estado_pago = "PENDIENTE" AND df.tipo_detalle = "SERVICIO")
;


-- 8º Indica las reviews realizadas por los usuarios con menos de 4 estrellas y su país de origen sea Reino Unido
-- usando una subconsulta.
SELECT r.comentario AS "Comentario", r.puntuacion AS "Puntuación"
FROM reviews r
WHERE r.puntuacion < 4 AND r.num_documento_cliente IN (
SELECT c.num_documento_cliente
FROM clientes c
JOIN paises p ON c.id_pais = p.id_pais
WHERE p.nombre = "Reino Unido");

-- Pogramación 

-- 1º.- Crea una función que muestre todas las facturas de un cliente, por separado y luego su total cuando 
-- sea llamada la función, esta función se mostrará cuando un cliente realice una reserva o compra de servicios extras.
-- Además otro para cuando se actualice o modifique una factura.


DROP FUNCTION IF EXISTS mostrarFacturasCliente;
DELIMITER //
CREATE FUNCTION mostrarFacturasCliente(p_cliente_num VARCHAR(9))
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
    DECLARE facturas_texto VARCHAR(1000);
    DECLARE total DECIMAL(10, 2);
    
    SET facturas_texto = '';
    SET total = 0.00;
    -- Esto vale para concatenar en una sola línea.
    SELECT GROUP_CONCAT(CONCAT('Factura ID: ', id_factura, ', Monto: ', precio_total) SEPARATOR '; ')
    INTO facturas_texto
    FROM facturas 
    WHERE num_documento_cliente = p_cliente_num;

    SELECT SUM(precio_total) 
    INTO total
    FROM facturas
    WHERE num_documento_cliente = p_cliente_num;

    RETURN CONCAT(facturas_texto, 'Total Facturas ', num_documento_cliente, ': ', total);
END //

DELIMITER ;


DROP TRIGGER IF EXISTS nuevaFactura;
DELIMITER //
CREATE TRIGGER nuevaFactura
AFTER INSERT ON facturas
FOR EACH ROW
BEGIN
    CALL mostrarFacturasCliente(NEW.num_documento_cliente);
END //

DELIMITER ;

DROP TRIGGER IF EXISTS actualizarFactura;
DELIMITER //
CREATE TRIGGER actualizarFactura
AFTER UPDATE ON facturas
FOR EACH ROW
BEGIN
    CALL mostrarFacturasCliente(NEW.num_documento_cliente);
END //

DELIMITER ;

INSERT INTO facturas (num_documento_cliente, precio_total)
VALUES ('12345678A', 100.00);





-- 3º.- Realiza un procedimiento con un cursor que, calcule el total de las facturas de una reserva
-- (incluido clientes vinculados a la reserva que tengan gastos extras) en un periodo
-- entre dos fechas, siendo las fechas de inicio y fin datos obligatorios a introducir.
-- Ten en cuenta que el impuesto en el detalle de las facturas está a parte y debe sumarse,
-- Al final debe de mostrarse el resultado total de todas las facturas.
DROP PROCEDURE IF EXISTS totalFacturasReserva;
DELIMITER //
CREATE PROCEDURE totalFacturasReserva(IN p_fechaInicio DATETIME, IN p_fechaFin DATETIME)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE total DECIMAL(10,2) DEFAULT 0.00;
    DECLARE total_general DECIMAL(10,2) DEFAULT 0.00;
    DECLARE reserva_id INT;
    DECLARE cur CURSOR FOR 
        SELECT numero_reserva 
        FROM reservas 
        WHERE fecha_inicio BETWEEN p_fechaInicio AND p_fechaFin;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    leer_loop: LOOP
        FETCH cur INTO reserva_id;
        IF done THEN
            LEAVE leer_loop;
        END IF;

        SELECT SUM(df.subtotal + df.igic) INTO total
        FROM detalles_facturas df
        WHERE df.num_reserva = reserva_id;

        SET total_general = total_general + total;

        SELECT CONCAT('Reserva ID: ', reserva_id, ' - Total Facturado: ', total) AS "Resultado de la Reserva";
    END LOOP;

    CLOSE cur;

    SELECT CONCAT('Total General Facturado: ', total_general) AS "Resultado General";
END //
DELIMITER ;


CALL totalFacturasReserva('2024-12-19 00:00:00', '2024-12-31 23:59:59');

CALL totalFacturasReserva('2024-12-26 00:00:00', '2024-12-31 23:59:59');


