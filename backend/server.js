import express from "express";
import mysql from "mysql2";
import csv from "csv-parser";
import fs from "fs";
import multer from "multer";
import cors from "cors";
import path from "path"; // Importa path para rutas relativas y absolutas
import nodemailer from "nodemailer";
const app = express();  
const PORT = 3002;
// Middleware para servir la carpeta de imágenes como estática
const __dirname = path.resolve();
app.use("/img", express.static(path.join(__dirname, "../img")));

const upload = multer({dest: "uploads"})

// import nodemailer from "nodemailer";

const userGmail = "acopioemails@gmail.com";
const passAppGmail = "lioy pwrj ndph tgan";

// Set up Nodemailer transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: userGmail,
    pass: passAppGmail,
  },
});

// Define a route for sending emails
// Set up email options
const mailOptions = {
  from: userGmail,
  to: userGmail,
  subject: "Test Email 222",
  text: "This is a test email from Node.js!.",
};

// Send email
transporter.sendMail(mailOptions, (error, info) => {
  if (error) {
    console.log(error);
  }
  console.log("Email sent: " + info.response);
});

// Configuración de CORS
app.use(cors({
  origin: 'http://localhost:5173', // URL del frontend
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'], // Añadir 'PATCH' aquí
  allowedHeaders: ['Content-Type', 'Authorization'], // Encabezados permitidos
}));

// Middleware para procesar JSON
app.use(express.json());

// Configuración de la base de datos
const DB = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "acopio",
});

DB.connect((err) => {
  if (err) {
    console.error("Error connecting to database:", err);
    return;
  }
  console.log("Conexión exitosa a la base de datos");
});

// Endpoint para cargar el archivo CSV
app.post('/api/acopio/materiales/carga-masiva', upload.single('file'), (req, res) => {
  const filePath = req.file.path;

  const materiales = [];

  fs.createReadStream(filePath)
    .pipe(csv())
    .on('data', (row) => {
      materiales.push(row);
    })
    .on('end', () => {
      const materialesValidos = materiales.filter((material) => {
        return (
          material.id &&
          material.identificador &&
          material.nombre &&
          material.tipo &&
          material.cantidad_disponible &&
          material.estado &&
          material.descripcion &&
          material.color &&
          material.img
        );
      });
      
      if (materialesValidos.length === 0) {
        return res.status(400).json({ message: 'No hay datos válidos para insertar.' });
      }
      console.log('Datos procesados para insertar:', materialesValidos);

      
      // Inserta solo materiales válidos
      const query = 'INSERT INTO materiales (id, identificador, nombre, tipo, cantidad_disponible, estado, descripcion, color, img) VALUES ?';

const values = materialesValidos.map((material) => [
  material.id,
  material.identificador,
  material.nombre,
  material.tipo,
  material.cantidad_disponible,
  material.estado,
  material.descripcion,
  material.color,
  material.img,
]);
DB.query(query, [values], (err, result) => {
  if (err) {
    console.error('Error al insertar los datos:', err);
    return res.status(500).json({ message: 'Error al insertar los datos', error: err });
  }
  res.status(200).json({ message: 'Datos insertados correctamente', result });
});
    
      fs.unlinkSync(filePath); 
    });
});

// Ruta para obtener usuarios
app.get("/api/acopio/usuarios", (req, res) => {
  const { correo } = req.query;

  const SQL_QUERY = correo
    ? "SELECT * FROM usuarios WHERE correo = ?"
    : "SELECT * FROM usuarios";

  DB.query(SQL_QUERY, [correo], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send("Error al obtener los usuarios");
      return;
    }
    res.json(result);
  });
});

// Ruta para crear un nuevo usuario
// Ruta para crear un nuevo usuario y enviar correo de bienvenida
app.post("/api/acopio/usuarios", (req, res) => {
  console.log("Datos recibidos:", req.body);

  const { id, correo, contraseña, nombre, telefono, rol } = req.body;

  // Validar datos requeridos
  if (!id || !correo || !contraseña || !nombre || !telefono || !rol) {
    console.error("Faltan datos:", { id, correo, contraseña, nombre, telefono, rol });
    res.status(400).send("Faltan datos para registrar el usuario");
    return;
  }

  // Consulta SQL para insertar el usuario
  const SQL_QUERY = `
    INSERT INTO usuarios (id, correo, contraseña, nombre, telefono, rol)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  DB.query(SQL_QUERY, [id, correo, contraseña, nombre, telefono, rol], (err, result) => {
    if (err) {
      console.error("Error en la consulta SQL:", err);

      if (err.code === 'ER_DUP_ENTRY') {
        res.status(400).send("El correo ya está registrado.");
      } else {
        res.status(500).send("Error al crear el usuario");
      }
      return;
    }

    

    // Configurar las opciones del correo
    const mailOptions = {
      from: userGmail,
      to: correo, // Correo del destinatario
      subject: "¡Bienvenido a Acopio!",
      text: `Hola ${nombre},
    
    ¡Gracias por registrarte en *Acopio*! Nos alegra que te unas a nuestra comunidad. 
    
    Estos son tus datos de acceso para comenzar a usar nuestro sistema:
    
    Usuario: ${correo}
    Contraseña: usuarioacopio
    
    Por favor, recuerda mantener tus credenciales seguras. Te recomendamos cambiar la contraseña una vez inicies sesión.
    
    Si tienes alguna pregunta o necesitas ayuda, no dudes en contactarnos.
    
    ¡Bienvenido a bordo!
      
    El equipo de Acopio
    `,
    };
    

    
  
    // Enviar correo al nuevo usuario
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error("Error al enviar el correo:", error);
        res.status(500).send("Usuario creado, pero no se pudo enviar el correo.");
        return;
      }
      console.log("Correo enviado: " + info.response);
      res.send("Usuario creado exitosamente y correo enviado.");
    });
  });
});

// Ruta para actualizar la contraseña de un usuario
app.patch("/api/acopio/usuarios/:id", (req, res) => {
  const { id } = req.params;
  const { contraseña } = req.body;

  if (!contraseña || contraseña.length < 6) {
    return res.status(400).send("La contraseña debe tener al menos 6 caracteres.");
  }

  const SQL_QUERY = "UPDATE usuarios SET contraseña = ? WHERE id = ?";

  DB.query(SQL_QUERY, [contraseña, id], (err, result) => {
    if (err) {
      console.error("Error al actualizar la contraseña:", err);
      return res.status(500).send("Error al actualizar la contraseña.");
    }

    if (result.affectedRows === 0) {
      return res.status(404).send("Usuario no encontrado.");
    }

    res.send("Contraseña actualizada correctamente.");
  });
});



// Ruta para obtener todos los materiales
app.get("/api/acopio/materiales", (req, res) => {
  const SQL_QUERY = "SELECT * FROM materiales";
  DB.query(SQL_QUERY, (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send("Error al obtener los materiales");
      return;
    }
    res.json(result);
  });
});

// Ruta para obtener un material específico por ID
app.get("/api/acopio/materiales/:id", (req, res) => {
  const { id } = req.params; // Obtener el ID de los parámetros de la solicitud

  const SQL_QUERY = "SELECT * FROM materiales WHERE id = ?";
  
  DB.query(SQL_QUERY, [id], (err, result) => {
    if (err) {
      console.error("Error al obtener el material:", err);
      res.status(500).send("Error al obtener el material");
      return;
    }

    if (result.length === 0) {
      res.status(404).send("Material no encontrado");
      return;
    }

    res.json(result[0]); // Enviar el primer resultado como objeto JSON
  });
});


// Ruta para crear un nuevo material
app.post("/api/acopio/materiales", (req, res) => {
  console.log("Datos recibidos para material:", req.body);

  // Desestructuración de los datos recibidos
  const { id, identificador, nombre, tipo, cantidad_disponible, estado, descripcion, color, img } = req.body;

  // Validación de los datos necesarios
  if (!id || !nombre || !tipo || cantidad_disponible === undefined || !estado) {
    console.error("Faltan datos necesarios para registrar el material:", {
      id, identificador, nombre, tipo, cantidad_disponible, estado, descripcion, color, img
    });
    return res.status(400).send("Faltan datos necesarios para registrar el material");
  }

  // Consulta SQL para insertar el nuevo material
  const SQL_QUERY = `
    INSERT INTO materiales (id, identificador, nombre, tipo, cantidad_disponible, estado, descripcion, color, img)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  DB.query(
    SQL_QUERY,
    [id, identificador || "", nombre, tipo, cantidad_disponible, estado, descripcion || "", color || "", img || ""],
    (err, result) => {
      if (err) {
        console.error("Error en la consulta SQL:", err);

        // Manejo de errores comunes
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(400).send("El ID del material ya está registrado.");
        }

        return res.status(500).send("Error al crear el material");
      }

      res.send("Material creado exitosamente");
    }
  );
});

// Ruta para actualizar un material por ID
app.put("/api/acopio/materiales/:id", (req, res) => {
  const { id } = req.params; // Obtener el ID del material
  const { identificador, descripcion, estado, cantidad_disponible, tipo, color } = req.body;

  if (!id) {
    return res.status(400).send("ID del material es requerido");
  }

  const SQL_QUERY = `
    UPDATE materiales
    SET identificador = ?, descripcion = ?, estado = ?, cantidad_disponible = ?, tipo = ?, color = ?
    WHERE id = ?
  `;

  DB.query(
    SQL_QUERY,
    [identificador, descripcion, estado, cantidad_disponible, tipo, color, id],
    (err, result) => {
      if (err) {
        console.error("Error al actualizar el material:", err);
        return res.status(500).send("Error al actualizar el material");
      }

      if (result.affectedRows === 0) {
        return res.status(404).send("Material no encontrado");
      }

      res.send("Material actualizado exitosamente");
    }
  );
});



app.post("/api/acopio/carrito/solicitar", (req, res) => {
  const { usuario_id, nombre_usuario, numero_telefono, fecha_devolucion, correo_usuario } = req.body;

  // Validar campos requeridos
  if (!usuario_id || !nombre_usuario || !numero_telefono || !fecha_devolucion || !correo_usuario) {
    return res.status(400).send("Faltan datos para procesar la solicitud");
  }

  // Generar un nuevo ID único para la solicitud
  const peticion_id = `P${Date.now()}`;
  const fecha_peticion = new Date().toISOString().slice(0, 19).replace('T', ' '); // Fecha del sistema en formato MySQL

  // Iniciar una transacción para garantizar consistencia
  DB.beginTransaction((transactionErr) => {
    if (transactionErr) {
      console.error("Error al iniciar la transacción:", transactionErr);
      return res.status(500).send("Error interno del servidor");
    }

    // 1. Crear nueva solicitud en la tabla `peticiones`
    const SQL_INSERT_PETICION = `
      INSERT INTO peticiones (id, usuario_id, nombre_usuario, numero_telefono, estado, fecha_peticion, fecha_devolucion)
      VALUES (?, ?, ?, ?, 'Pendiente', ?, ?)
    `;
    DB.query(SQL_INSERT_PETICION, [peticion_id, usuario_id, nombre_usuario, numero_telefono, fecha_peticion, fecha_devolucion], (err) => {
      if (err) {
        console.error("Error al crear la petición:", err);
        return DB.rollback(() => res.status(500).send("Error al crear la petición"));
      }

      // 2. Mover productos del carrito a la tabla `peticion_detalle`
      const SQL_INSERT_DETALLE = `
        INSERT INTO peticion_detalle (peticion_id, material_id, cantidad)
        SELECT ?, material_id, cantidad
        FROM carrito
        WHERE usuario_id = ?
      `;
      DB.query(SQL_INSERT_DETALLE, [peticion_id, usuario_id], (err) => {
        if (err) {
          console.error("Error al mover productos al detalle de la petición:", err);
          return DB.rollback(() => res.status(500).send("Error al procesar los materiales"));
        }

        // 3. Vaciar el carrito del usuario
        const SQL_VACIAR_CARRITO = `DELETE FROM carrito WHERE usuario_id = ?`;
        DB.query(SQL_VACIAR_CARRITO, [usuario_id], (err) => {
          if (err) {
            console.error("Error al vaciar el carrito:", err);
            return DB.rollback(() => res.status(500).send("Error al vaciar el carrito"));
          }

          // 4. Confirmar la transacción
          DB.commit((commitErr) => {
            if (commitErr) {
              console.error("Error al confirmar la transacción:", commitErr);
              return DB.rollback(() => res.status(500).send("Error interno del servidor"));
            }

            // Enviar correo de confirmación
            const mailOptions = {
              from: userGmail,
              to: correo_usuario, // Correo dinámico del usuario
              subject: "Confirmación de solicitud",
              text: `
                ¡Hola ${nombre_usuario}!

                Nos complace informarte que tu solicitud ha sido registrada exitosamente. 
                A continuación, encontrarás los detalles de tu solicitud:

                -------------------------------------
                📄 ID de la solicitud: ${peticion_id}
                📅 Fecha de la petición: ${fecha_peticion}
                📅 Fecha de devolución: ${fecha_devolucion}
                -------------------------------------

                Si tienes alguna pregunta o necesitas más información, no dudes en contactarnos.

                Gracias por confiar en nuestro servicio. 😊
                
                Saludos cordiales,  
                El equipo de soporte.
              `,
            };

            transporter.sendMail(mailOptions, (error, info) => {
              if (error) {
                console.error("Error al enviar correo:", error);
                return res.status(500).send("Solicitud creada, pero no se pudo enviar el correo.");
              }
              console.log("Correo enviado: " + info.response);
              res.status(200).send("Solicitud procesada con éxito");
            });
          });
        });
      });
    });
  });
});



// Agregar material al carrito
app.post("/api/acopio/carrito", (req, res) => {
  const { usuario_id, material_id, cantidad, fecha_agregado } = req.body;

  if (!usuario_id || !material_id || !cantidad) {
    return res.status(400).send("Faltan datos para agregar al carrito");
  }

  const SQL_QUERY = `
    INSERT INTO carrito (usuario_id, material_id, cantidad, fecha_agregado)
    VALUES (?, ?, ?, NOW());
  `;

  DB.query(SQL_QUERY, [usuario_id, material_id, cantidad], (err, result) => {
    if (err) {
      console.error("Error al agregar al carrito:", err);
      return res.status(500).send("Error al agregar al carrito");
    }
    res.status(200).send("Material agregado al carrito");
  });
});

// Obtener materiales del carrito de un usuario
app.get("/api/acopio/carrito/:usuario_id", (req, res) => {
  const { usuario_id } = req.params;

  const SQL_QUERY = `
    SELECT c.*, m.nombre AS material_nombre, m.img, m.tipo
    FROM carrito c
    JOIN materiales m ON c.material_id = m.id
    WHERE c.usuario_id = ?;
  `;

  DB.query(SQL_QUERY, [usuario_id], (err, result) => {
    if (err) {
      console.error("Error al obtener el carrito:", err);
      return res.status(500).send("Error al obtener el carrito");
    }
    res.json(result);
  });
});

// Eliminar material del carrito
app.delete("/api/acopio/carrito/:usuario_id/:material_id", (req, res) => {
  const { usuario_id, material_id } = req.params;

  const SQL_QUERY = `
    DELETE FROM carrito WHERE usuario_id = ? AND material_id = ?;
  `;

  DB.query(SQL_QUERY, [usuario_id, material_id], (err, result) => {
    if (err) {
      console.error("Error al eliminar del carrito:", err);
      return res.status(500).send("Error al eliminar del carrito");
    }
    res.status(200).send("Material eliminado del carrito");
  });
});

// Vaciar carrito de un usuario
app.delete("/api/acopio/carrito/:usuario_id", (req, res) => {
  const { usuario_id } = req.params;

  const SQL_QUERY = `
    DELETE FROM carrito WHERE usuario_id = ?;
  `;

  DB.query(SQL_QUERY, [usuario_id], (err, result) => {
    if (err) {
      console.error("Error al vaciar el carrito:", err);
      return res.status(500).send("Error al vaciar el carrito");
    }
    res.status(200).send("Carrito vaciado");
  });
});


// Ruta para obtener las solicitudes de la tabla 'peticiones'
app.get("/api/acopio/peticiones", (req, res) => {
  const SQL_QUERY = "SELECT * FROM peticiones"; // Consulta para obtener todas las peticiones
  DB.query(SQL_QUERY, (err, result) => {
    if (err) {
      console.error("Error al obtener las peticiones:", err);
      res.status(500).send("Error al obtener las peticiones");
      return;
    }
    res.json(result); // Retorna las peticiones como JSON
  });
});

// Ruta para obtener una petición y sus materiales asociados
app.get("/api/acopio/peticiones/:id", (req, res) => {
  const { id } = req.params;

  // Consulta la solicitud
  const peticionQuery = `
    SELECT * FROM peticiones WHERE id = ?
  `;

  DB.query(peticionQuery, [id], (err, peticionResult) => {
    if (err) {
      console.error("Error al obtener la solicitud:", err);
      return res.status(500).json({ error: "Error interno del servidor" });
    }

    if (peticionResult.length === 0) {
      return res.status(404).json({ error: "Solicitud no encontrada" });
    }

    const peticion = peticionResult[0];

    // Consulta los materiales asociados a la solicitud
    const materialesQuery = `
      SELECT pd.material_id, pd.cantidad, m.nombre, m.descripcion 
      FROM peticion_detalle pd
      INNER JOIN materiales m ON pd.material_id = m.id
      WHERE pd.peticion_id = ?
    `;

    DB.query(materialesQuery, [id], (err, materialesResult) => {
      if (err) {
        console.error("Error al obtener los materiales asociados:", err);
        return res.status(500).json({ error: "Error interno del servidor" });
      }

      // Devuelve los datos combinados
      res.json({
        peticion,
        materiales: materialesResult,
      });
    });
  });
});

// Ruta para actualizar el estado de una solicitud
app.put("/api/acopio/peticiones/:id/estado", (req, res) => {
  const { id } = req.params;
  const { estado } = req.body;

  if (!estado) {
    return res.status(400).send("Se requiere el estado para actualizar la solicitud.");
  }

  const SQL_QUERY = `
    UPDATE peticiones SET estado = ? WHERE id = ?
  `;

  DB.query(SQL_QUERY, [estado, id], (err, result) => {
    if (err) {
      console.error("Error al actualizar el estado de la solicitud:", err);
      return res.status(500).send("Error interno del servidor");
    }

    if (result.affectedRows === 0) {
      return res.status(404).send("Solicitud no encontrada.");
    }

    res.send("Estado de la solicitud actualizado con éxito.");
  });
});

app.post("/api/acopio/devoluciondetalle", (req, res) => {
  const { id, descripcion, usuario_id, nombre_usuario, numero_telefono, fecha, peticion_id } = req.body;

  if (!id || !peticion_id || !usuario_id || !nombre_usuario || !numero_telefono || !descripcion || !fecha) {
    return res.status(400).send("Todos los campos son obligatorios.");
  }

  const SQL_INSERT = `
    INSERT INTO devoluciondetalle (id, descripcion, usuario_id, nombre_usuario, numero_telefono, fecha, peticion_id)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  DB.query(SQL_INSERT, [id, descripcion, usuario_id, nombre_usuario, numero_telefono, fecha, peticion_id], (err) => {
    if (err) {
      console.error("Error al registrar la devolución:", err);
      return res.status(500).send("Error al registrar la devolución.");
    }

    res.send("Devolución registrada correctamente.");
  });
});

// Función para enviar correo de recordatorio de devolución
function enviarCorreoRecordatorioDevolucion(correo, nombre, detallesMaterial, fechaDevolucion) {
  const mailOptionsRecordatorio = {
    from: userGmail,
    to: correo,
    subject: "Recordatorio: Próxima Devolución de Material en Acopio",
    text: `Hola ${nombre},

Esperamos que estés bien. Te escribimos para recordarte que mañana es la fecha límite para devolver el material que tienes en préstamo con Acopio.

Detalles del Préstamo:
- Nombre del Material: ${detallesMaterial.nombre || 'Material no especificado'}
- Identificador: ${detallesMaterial.identificador || 'Sin identificador'}
- Fecha de Devolución: ${fechaDevolucion}

Por favor, asegúrate de devolver el material en perfectas condiciones y en el tiempo establecido. Si necesitas más tiempo o tienes alguna duda, no dudes en contactarnos.

Pasos para la Devolución:
1. Verifica el estado del material
2. Limpia y prepara el material para su devolución
3. Acude al punto de recolección de Acopio
4. Entrega el material con tu comprobante de préstamo

Si has extraviado el material o tienes algún inconveniente, ponte en contacto con nuestro equipo lo antes posible.

Gracias por ser parte de Acopio.

Saludos cordiales,
El Equipo de Acopio`
  };

  // Enviar correo de recordatorio
  transporter.sendMail(mailOptionsRecordatorio, (error, info) => {
    if (error) {
      console.error("Error al enviar correo de recordatorio:", error);
    } else {
      console.log("Correo de recordatorio enviado: " + info.response);
    }
  });
}


// Ruta para obtener todas las devoluciones
app.get("/api/acopio/devoluciondetalle", (req, res) => {
  const SQL_QUERY = `
    SELECT * FROM devoluciondetalle
  `;

  DB.query(SQL_QUERY, (err, results) => {
    if (err) {
      console.error("Error al obtener las devoluciones:", err);
      return res.status(500).send("Error interno del servidor");
    }

    // Devolver los resultados como respuesta JSON
    res.json(results);
  });
});


// Ejecución del servidor
app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
